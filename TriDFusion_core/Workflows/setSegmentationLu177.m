function setSegmentationLu177(dBoneMaskThreshold, dSmalestVoiValue, dPixelEdge, bUseDefault)
%function setSegmentationLu177(dBoneMaskThreshold, dSmalestVoiValue, dPixelEdge, bUseDefault)
%Run Lu177 Segmentation base on normal liver Threshold.
%See TriDFuison.doc (or pdf) for more information about options.
%
%Author: Daniel Lafontaine, lafontad@mskcc.org
%
%Last specifications modified:
%
% Copyright 2023, Daniel Lafontaine, on behalf of the TriDFusion development team.
%
% This file is part of The Triple Dimention Fusion (TriDFusion).
%
% TriDFusion development has been led by:  Daniel Lafontaine
%
% TriDFusion is distributed under the terms of the Lesser GNU Public License.
%
%     This version of TriDFusion is free software: you can redistribute it and/or modify
%     it under the terms of the GNU General Public License as published by
%     the Free Software Foundation, either version 3 of the License, or
%     (at your option) any later version.
%
% TriDFusion is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY;
% without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
% See the GNU General Public License for more details.
%
% You should have received a copy of the GNU General Public License
% along with TriDFusion.  If not, see <http://www.gnu.org/licenses/>.

    gbProceedWithSegmentation = false;
    gdNormalLiverMean = [];
    gdNormalLiverSTD = [];

    atInput = inputTemplate('get');

    % Modality validation

    dCTSerieOffset = [];
    for tt=1:numel(atInput)
        if strcmpi(atInput(tt).atDicomInfo{1}.Modality, 'ct')
            dCTSerieOffset = tt;
            break
        end
    end

    dNMSerieOffset = [];
    for tt=1:numel(atInput)
        if strcmpi(atInput(tt).atDicomInfo{1}.Modality, 'nm')
            dNMSerieOffset = tt;
            break
        end
    end

    if isempty(dCTSerieOffset) || ...
       isempty(dNMSerieOffset)
        progressBar(1, 'Error: PSMA Lu177 tumor segmentation require a CT and NM image!');
        errordlg('PSMA Lu177 tumor segmentation require a CT and NM image!', 'Modality Validation');
        return;
    end


    atNMMetaData = dicomMetaData('get', [], dNMSerieOffset);
    atCTMetaData = dicomMetaData('get', [], dCTSerieOffset);

    aNMImage = dicomBuffer('get', [], dNMSerieOffset);
    if isempty(aNMImage)
        aInputBuffer = inputBuffer('get');
        aNMImage = aInputBuffer{dNMSerieOffset};
    end

    aCTImage = dicomBuffer('get', [], dCTSerieOffset);
    if isempty(aCTImage)
        aInputBuffer = inputBuffer('get');
        aCTImage = aInputBuffer{dCTSerieOffset};
    end

    if isempty(atNMMetaData)
        atNMMetaData = atInput(dNMSerieOffset).atDicomInfo;
    end

    if isempty(atCTMetaData)
        atCTMetaData = atInput(dCTSerieOffset).atDicomInfo;
    end

    if get(uiSeriesPtr('get'), 'Value') ~= dNMSerieOffset
        set(uiSeriesPtr('get'), 'Value', dNMSerieOffset);

        setSeriesCallback();
    end

    tQuant = quantificationTemplate('get');

    if isfield(tQuant, 'tSUV')
        dSUVScale = tQuant.tSUV.dScale;
    else
        dSUVScale = 1;
    end

    atRoiInput = roiTemplate('get', dNMSerieOffset);

    if ~isempty(atRoiInput)

        aTagOffset = strcmpi( cellfun( @(atRoiInput) atRoiInput.Label, atRoiInput, 'uni', false ), {'Normal Liver'} );
        dTagOffset = find(aTagOffset, 1);

        aSlice = [];

        if ~isempty(dTagOffset)

            switch lower(atRoiInput{dTagOffset}.Axe)

                case 'axes1'
                    aSlice = permute(aNMImage(atRoiInput{dTagOffset}.SliceNb,:,:), [3 2 1]);

                case 'axes2'
                    aSlice = permute(aNMImage(:,atRoiInput{dTagOffset}.SliceNb,:), [3 1 2]);

                case 'axes3'
                    aSlice = aNMImage(:,:,atRoiInput{dTagOffset}.SliceNb);
            end

            aLogicalMask = roiTemplateToMask(atRoiInput{dTagOffset}, aSlice);

            gdNormalLiverMean = mean(aSlice(aLogicalMask), 'all')   * dSUVScale;


   %         H = fspecial('average',5);
   %         blurred = imfilter(aSlice(aLogicalMask),H,'replicate');

            gdNormalLiverSTD = std(aSlice(aLogicalMask), [],'all') * dSUVScale;

            clear aSlice;
        else
            if bUseDefault == false

                waitfor(msgbox('Warning: Please define a Normal Liver ROI. Draw an ROI on the normal liver, right-click on the ROI, and select Predefined Label ''Normal Liver,'' or manually input a normal liver mean and SD into the following dialog.', 'Warning'));

                Lu177NormalLiverMeanSDDialog();

                if gbProceedWithSegmentation == false
                    return;
                end
            else
                gdNormalLiverMean = Lu177NormalLiverMeanValue('get');
                gdNormalLiverSTD  = Lu177NormalLiverSDValue('get');
            end
        end
    else
        if bUseDefault == false
            waitfor(msgbox('Warning: Please define a Normal Liver ROI. Draw an ROI on the normal liver, right-click on the ROI, and select Predefined Label ''Normal Liver,'' or manually input a normal liver mean and SD into the following dialog.', 'Warning'));

            Lu177NormalLiverMeanSDDialog();

            if gbProceedWithSegmentation == false
                return;
            end
        else
            gdNormalLiverMean = Lu177NormalLiverMeanValue('get');
            gdNormalLiverSTD  = Lu177NormalLiverSDValue('get');
        end
    end

    % Apply ROI constraint

    [asConstraintTagList, asConstraintTypeList] = roiConstraintList('get', dNMSerieOffset);

    bInvertMask = invertConstraint('get');

    tRoiInput = roiTemplate('get', dNMSerieOffset);

    aNMImageTemp = aNMImage;
    aLogicalMask = roiConstraintToMask(aNMImageTemp, tRoiInput, asConstraintTagList, asConstraintTypeList, bInvertMask);
    aNMImageTemp(aLogicalMask==0) = 0;  % Set constraint

    resetSeries(dNMSerieOffset, true);

    try

    set(fiMainWindowPtr('get'), 'Pointer', 'watch');
    drawnow;

    if isInterpolated('get') == false

        isInterpolated('set', true);

        setImageInterpolation(true);
    end

    progressBar(5/10, 'Resampling data series, please wait...');

    [aResampledNMImageTemp, ~] = resampleImage(aNMImageTemp, atNMMetaData, aCTImage, atCTMetaData, 'Linear', false, false);
    [aResampledNMImage, atResampledNMMetaData] = resampleImage(aNMImage, atNMMetaData, aCTImage, atCTMetaData, 'Linear', false, true);

    dicomMetaData('set', atResampledNMMetaData, dNMSerieOffset);
    dicomBuffer  ('set', aResampledNMImage, dNMSerieOffset);

    aResampledNMImage = aResampledNMImageTemp;

    clear aNMImageTemp;
    clear aResampledNMImageTemp;

    progressBar(6/10, 'Resampling MIP, please wait...');

    refMip = mipBuffer('get', [], dCTSerieOffset);
    aMip   = mipBuffer('get', [], dNMSerieOffset);

    aMip = resampleMip(aMip, atNMMetaData, refMip, atCTMetaData, 'Linear', false);

    mipBuffer('set', aMip, dNMSerieOffset);

    setQuantification(dNMSerieOffset);

    tQuant = quantificationTemplate('get');

    if isfield(tQuant, 'tSUV')
        dSUVScale = tQuant.tSUV.dScale;
    else
        dSUVScale = 1;
    end

    progressBar(7/10, 'Computing mask, please wait...');

    aBWMask = aResampledNMImage;

    dMin = min(aBWMask, [], 'all');

%    dThreshold = (4.44/gdNormalLiverMean)*(gdNormalLiverMean+gdNormalLiverSTD);
    dThreshold = (1.5*gdNormalLiverMean) + (2*gdNormalLiverSTD);

    if dThreshold < 2.5
        dThreshold = 2.5;
    end

    aBWMask(aBWMask*dSUVScale<dThreshold)=dMin;

    aBWMask = imbinarize(aBWMask);

    progressBar(8/10, 'Computing CT map, please wait...');

%     tRegistration = registrationTemplate('get');
%
%     optimizer = tRegistration.Optimizer;
%     metric    = tRegistration.Metric;

%     [BWCT, ~, ~, ~, ~] = ...
%         registerImage(aCTImage             , ...
%                       atCTMetaData         , ...
%                       aResampledNMImage    , ...
%                       atResampledNMMetaData, ...
%                       aLogicalMask         , ...
%                       'translation', 'multimodal', ...
%                       optimizer            , ...
%                       metric               , ...
%                       true                 , ...
%                       false                );

    BWCT = aCTImage >= dBoneMaskThreshold;   % Logical mask creation
    BWCT = imfill(single(BWCT), 4, 'holes'); % Fill holes in the binary mask

%     BWCT = aCTImage;
%
%     % Thresholding to create a binary mask
%     BWCT = BWCT >= dBoneMaskThreshold;
%
%     % Perform morphological closing to smooth contours and fill small gaps
%     se = strel('disk', 3); % Adjust the size as needed
%     BWCT = imclose(BWCT, se);
%
%     % Fill holes in the binary image
%     BWCT = imfill(BWCT, 'holes');
%
%     % Optional: Remove small objects that are not part of the bone
%     BWCT = bwareaopen(BWCT, 100); % Adjust the size threshold as needed
%
%     % Perform another round of morphological closing if necessary
%     BWCT = imclose(BWCT, se);
%
%     % Optional: Perform morphological opening to remove small spurious regions
%     BWCT = imopen(BWCT, se);

    if ~isequal(size(BWCT), size(aResampledNMImage)) % Verify if both images are in the same field of view

        BWCT = resample3DImage(BWCT, atCTMetaData, aResampledNMImage, atResampledNMMetaData, 'Cubic');

        BWCT = imbinarize(BWCT);

        if ~isequal(size(BWCT), size(aResampledNMImage)) % Verify if both images are in the same field of view
            BWCT = resizeMaskToImageSize(BWCT, aResampledNMImage);
        end
    else
        BWCT = imbinarize(BWCT);
    end

    progressBar(9/10, 'Generating contours, please wait...');

    imMask = aResampledNMImage;
%     imMask(aBWMask == 0) = dMin;

    setSeriesCallback();

%     sFormula = '(4.44/Normal Liver SUVmean)x(Normal Liver SUVmean + Normal Liver SD), Soft Tissue & Bone SUV 3, CT Bone Map';
    sFormula = '(1.5 x Normal Liver SUVmean)+(2 x Normal Liver SD), Soft Tissue & Bone SUV 2.5, CT Bone Map';
    maskAddVoiToSeries(imMask, aBWMask, dPixelEdge, false, 0, false, 0, true, sFormula, BWCT, dSmalestVoiValue,  gdNormalLiverMean, gdNormalLiverSTD, 'TUMOR');

    clear aResampledNMImage;
    clear aBWMask;
    clear refMip;
    clear aMip;
    clear BWCT;
    clear imMask;

    setVoiRoiSegPopup();

    % Set TCS Axes intensity

    dMin = 0/dSUVScale;
    dMax = 7/dSUVScale;

    windowLevel('set', 'max', dMax);
    windowLevel('set', 'min' ,dMin);

    setWindowMinMax(dMax, dMin);

    dMin = 0/dSUVScale;
    dMax = 7/dSUVScale;

    % Set MIP Axe intensity

    set(axesMipPtr('get', [], get(uiSeriesPtr('get'), 'Value')), 'CLim', [dMin dMax]);

    % Deactivate MIP Fusion

    link2DMip('set', false);

    set(btnLinkMipPtr('get'), 'BackgroundColor', viewerBackgroundColor('get'));
    set(btnLinkMipPtr('get'), 'ForegroundColor', viewerForegroundColor('get'));
    set(btnLinkMipPtr('get'), 'FontWeight', 'normal');

    % Set fusion

    if isFusion('get') == false

        set(uiFusedSeriesPtr('get'), 'Value', dCTSerieOffset);

        setFusionCallback();
    end

    [dMax, dMin] = computeWindowLevel(500, 50);

    fusionWindowLevel('set', 'max', dMax);
    fusionWindowLevel('set', 'min' ,dMin);

    setFusionWindowMinMax(dMax, dMin);

    % Triangulate og 1st VOI

    atVoiInput = voiTemplate('get', dNMSerieOffset);

    if ~isempty(atVoiInput)

        dRoiOffset = round(numel(atVoiInput{1}.RoisTag)/2);

        triangulateRoi(atVoiInput{1}.RoisTag{dRoiOffset});
    end

    % Activate ROI Panel

    if viewRoiPanel('get') == false
        setViewRoiPanel();
    end

    refreshImages();

    plotRotatedRoiOnMip(axesMipPtr('get', [], dNMSerieOffset), dicomBuffer('get', [], dNMSerieOffset), mipAngle('get'));

    clear aNMImage;
    clear aCTImage;


    progressBar(1, 'Ready');

    catch
        resetSeries(dNMSerieOffset, true);
        progressBar( 1 , 'Error: setSegmentationLu177()' );
    end

    set(fiMainWindowPtr('get'), 'Pointer', 'default');
    drawnow;

    function Lu177NormalLiverMeanSDDialog()

        DLG_Lu177_MEAN_SD_X = 380;
        DLG_Lu177_MEAN_SD_Y = 150;

        if viewerUIFigure('get') == true

            dlgLu177meanSD = ...
                uifigure('Position', [(getMainWindowPosition('xpos')+(getMainWindowSize('xsize')/2)-DLG_Lu177_MEAN_SD_X/2) ...
                                    (getMainWindowPosition('ypos')+(getMainWindowSize('ysize')/2)-DLG_Lu177_MEAN_SD_Y/2) ...
                                    DLG_Lu177_MEAN_SD_X ...
                                    DLG_Lu177_MEAN_SD_Y ...
                                    ],...
                       'Resize', 'off', ...
                       'Color', viewerBackgroundColor('get'),...
                       'WindowStyle', 'modal', ...
                       'Name' , 'Lu177 Segmentation Mean and SD'...
                       );
        else
            dlgLu177meanSD = ...
                dialog('Position', [(getMainWindowPosition('xpos')+(getMainWindowSize('xsize')/2)-DLG_Lu177_MEAN_SD_X/2) ...
                                    (getMainWindowPosition('ypos')+(getMainWindowSize('ysize')/2)-DLG_Lu177_MEAN_SD_Y/2) ...
                                    DLG_Lu177_MEAN_SD_X ...
                                    DLG_Lu177_MEAN_SD_Y ...
                                    ],...
                       'MenuBar', 'none',...
                       'Resize', 'off', ...
                       'NumberTitle','off',...
                       'MenuBar', 'none',...
                       'Color', viewerBackgroundColor('get'), ...
                       'Name', 'Lu177 Segmentation Mean and SD',...
                       'Toolbar','none'...
                       );
        end

        % Normal Liver Mean

            uicontrol(dlgLu177meanSD,...
                      'style'   , 'text',...
                      'Enable'  , 'On',...
                      'string'  , 'Normal Liver Mean',...
                      'horizontalalignment', 'left',...
                      'BackgroundColor', viewerBackgroundColor('get'), ...
                      'ForegroundColor', viewerForegroundColor('get'), ...
                      'position', [20 90 250 20]...
                      );

        edtLu177NormalLiverMeanValue = ...
            uicontrol(dlgLu177meanSD, ...
                      'Style'   , 'Edit', ...
                      'Position', [285 90 75 20], ...
                      'String'  , num2str(Lu177NormalLiverMeanValue('get')), ...
                      'Enable'  , 'on', ...
                      'BackgroundColor', viewerBackgroundColor('get'), ...
                      'ForegroundColor', viewerForegroundColor('get'), ...
                      'CallBack', @edtLu177NormalLiverMeanValueCallback ...
                      );

        % Normal Liver Standard Deviation

            uicontrol(dlgLu177meanSD,...
                      'style'   , 'text',...
                      'Enable'  , 'On',...
                      'string'  , 'Normal Liver Standard Deviation',...
                      'horizontalalignment', 'left',...
                      'BackgroundColor', viewerBackgroundColor('get'), ...
                      'ForegroundColor', viewerForegroundColor('get'), ...
                      'position', [20 65 250 20]...
                      );

        edtLu177NormalLiverSDValue = ...
            uicontrol(dlgLu177meanSD, ...
                      'Style'   , 'Edit', ...
                      'Position', [285 65 75 20], ...
                      'String'  , num2str(Lu177NormalLiverSDValue('get')), ...
                      'Enable'  , 'on', ...
                      'BackgroundColor', viewerBackgroundColor('get'), ...
                      'ForegroundColor', viewerForegroundColor('get'), ...
                      'CallBack', @edtLu177NormalLiverSDValueCallback ...
                      );

         % Cancel or Proceed

         uicontrol(dlgLu177meanSD,...
                   'String','Cancel',...
                   'Position',[285 7 75 25],...
                   'BackgroundColor', viewerBackgroundColor('get'), ...
                   'ForegroundColor', viewerForegroundColor('get'), ...
                   'Callback', @cancelLu177meanSDCallback...
                   );

         uicontrol(dlgLu177meanSD,...
                  'String','Continue',...
                  'Position',[200 7 75 25],...
                  'BackgroundColor', viewerBackgroundColor('get'), ...
                  'ForegroundColor', viewerForegroundColor('get'), ...
                  'Callback', @proceedLu177meanSDCallback...
                  );

        waitfor(dlgLu177meanSD);

        function edtLu177NormalLiverMeanValueCallback(~, ~)

            dMeanValue = str2double(get(edtLu177NormalLiverMeanValue, 'Value'));

            if dMeanValue < 0
                dMeanValue = 0.1;
                set(edtLu177NormalLiverMeanValue, 'Value', num2str(dMeanValue));
            end

            Lu177NormalLiverMeanValue('set', dMeanValue);
        end

        function edtLu177NormalLiverSDValueCallback(~, ~)

            dSDValue = str2double(get(edtLu177NormalLiverSDValue, 'Value'));

            if dSDValue < 0
                dSDValue = 0.1;
                set(edtLu177NormalLiverSDValue, 'Value', num2str(dSDValue));
            end

            Lu177NormalLiverSDValue('set', dSDValue);
        end

        function proceedLu177meanSDCallback(~, ~)

            gdNormalLiverMean = str2double(get(edtLu177NormalLiverMeanValue, 'String'));
            gdNormalLiverSTD  = str2double(get(edtLu177NormalLiverSDValue, 'String'));

            delete(dlgLu177meanSD);
            gbProceedWithSegmentation = true;
        end

        function cancelLu177meanSDCallback(~, ~)

            delete(dlgLu177meanSD);
            gbProceedWithSegmentation = false;
        end
    end
end
