function setMetastaticBreastCancerSegmentationCallback(hObject, ~)
%function setMetastaticBreastCancerSegmentationCallback(hObject)
%Run Metastatic Breast Cancer Tumor Segmentation, The tool is called from the main menu.
%See TriDFuison.doc (or pdf) for more information about options.
%
%Author: Daniel Lafontaine, lafontad@mskcc.org
%
%Last specifications modified:
%
% Copyright 2024, Daniel Lafontaine, on behalf of the TriDFusion development team.
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

    gdNormalLiverMean = [];
    gdNormalLiverSTD  = [];

    atRoiInput = roiTemplate('get', get(uiSeriesPtr('get'), 'Value'));

    if ~isempty(atRoiInput)
        
        aTagOffset = strcmpi( cellfun( @(atRoiInput) atRoiInput.Label, atRoiInput, 'uni', false ), {'Normal Liver'} );            
        dTagOffset = find(aTagOffset, 1);
        
        aSlice = [];
        
        if ~isempty(dTagOffset)

            aNMImage = dicomBuffer('get', [], get(uiSeriesPtr('get'), 'Value'));
            
            if ~isempty(aNMImage)

                tQuant = quantificationTemplate('get');
            
                if isfield(tQuant, 'tSUV')

                    dSUVScale = tQuant.tSUV.dScale;
                 
                    switch lower(atRoiInput{dTagOffset}.Axe)
        
                        case 'axes1'                            
                            aSlice = permute(aNMImage(atRoiInput{dTagOffset}.SliceNb,:,:), [3 2 1]);
        
                        case 'axes2'
                            aSlice = permute(aNMImage(:,atRoiInput{dTagOffset}.SliceNb,:), [3 1 2]);
        
                        case 'axes3'
                            aSlice = aNMImage(:,:,atRoiInput{dTagOffset}.SliceNb);       
                    end
                    
                    aLogicalMask = roiTemplateToMask(atRoiInput{dTagOffset}, aSlice);
                             
                    gdNormalLiverMean = mean(aSlice(aLogicalMask), 'all') * dSUVScale;
                    gdNormalLiverSTD  = std(aSlice(aLogicalMask), [], 'all') * dSUVScale;
                end

                clear aNMImage;
            end
        end
    end

    if exist('hObject', 'var') && isempty(gdNormalLiverMean)

        DLG_BREAST_CANCER_PERCENT_X = 380;
        DLG_BREAST_CANCER_PERCENT_Y = 235;

        if viewerUIFigure('get') == true
    
            dlgBreastCancerSegmentation = ...
                uifigure('Position', [(getMainWindowPosition('xpos')+(getMainWindowSize('xsize')/2)-DLG_BREAST_CANCER_PERCENT_X/2) ...
                                    (getMainWindowPosition('ypos')+(getMainWindowSize('ysize')/2)-DLG_BREAST_CANCER_PERCENT_Y/2) ...
                                    DLG_BREAST_CANCER_PERCENT_X ...
                                    DLG_BREAST_CANCER_PERCENT_Y ...
                                    ],...
                       'Resize', 'off', ...
                       'Color', viewerBackgroundColor('get'),...
                       'WindowStyle', 'modal', ...
                       'Name' , 'Breast Cancer Segmentation'...
                       );
        else     
            dlgBreastCancerSegmentation = ...
                dialog('Position', [(getMainWindowPosition('xpos')+(getMainWindowSize('xsize')/2)-DLG_BREAST_CANCER_PERCENT_X/2) ...
                                    (getMainWindowPosition('ypos')+(getMainWindowSize('ysize')/2)-DLG_BREAST_CANCER_PERCENT_Y/2) ...
                                    DLG_BREAST_CANCER_PERCENT_X ...
                                    DLG_BREAST_CANCER_PERCENT_Y ...
                                    ],...
                       'MenuBar', 'none',...
                       'Resize', 'off', ...    
                       'NumberTitle','off',...
                       'MenuBar', 'none',...
                       'Color', viewerBackgroundColor('get'), ...
                       'Name', 'Breast Cancer Segmentation',...
                       'Toolbar','none'...               
                       );       
        end

        % SUV threshold
    
            uicontrol(dlgBreastCancerSegmentation,...
                      'style'   , 'text',...
                      'Enable'  , 'On',...
                      'string'  , 'Lymph Nodes SUV Threshold',...
                      'horizontalalignment', 'left',...
                      'BackgroundColor', viewerBackgroundColor('get'), ...
                      'ForegroundColor', viewerForegroundColor('get'), ...                   
                      'position', [20 190 250 20]...
                      );
    
        edtBreastCancerThresholdOfMaxValue = ...
            uicontrol(dlgBreastCancerSegmentation, ...
                      'Style'   , 'Edit', ...
                      'Position', [285 190 75 20], ...
                      'String'  , num2str(breastCancerSegmentationSUVThresholdValue('get')), ...
                      'Enable'  , 'on', ...
                      'BackgroundColor', viewerBackgroundColor('get'), ...
                      'ForegroundColor', viewerForegroundColor('get'), ...
                      'CallBack', @edtBreastCancerThresholdOfMaxValueCallback ...
                      ); 

        % SUV Bone threshold
    
            uicontrol(dlgBreastCancerSegmentation,...
                      'style'   , 'text',...
                      'Enable'  , 'On',...
                      'string'  , 'Bone SUV Threshold',...
                      'horizontalalignment', 'left',...
                      'BackgroundColor', viewerBackgroundColor('get'), ...
                      'ForegroundColor', viewerForegroundColor('get'), ...                   
                      'position', [20 165 250 20]...
                      );
    
        edtFDGBoneSUVThresholdOfMaxValue = ...
            uicontrol(dlgBreastCancerSegmentation, ...
                      'Style'   , 'Edit', ...
                      'Position', [285 165 75 20], ...
                      'String'  , num2str(breastCancerSegmentationBoneSUVThresholdValue('get')), ...
                      'Enable'  , 'on', ...
                      'BackgroundColor', viewerBackgroundColor('get'), ...
                      'ForegroundColor', viewerForegroundColor('get'), ...
                      'CallBack', @edtFDGBoneSUVThresholdOfMaxValueCallback ...
                      );     

        % Bone mask threshold
    
            uicontrol(dlgBreastCancerSegmentation,...
                      'style'   , 'text',...
                      'Enable'  , 'On',...
                      'string'  , 'Bone mask threshold (HU)',...
                      'horizontalalignment', 'left',...
                      'BackgroundColor', viewerBackgroundColor('get'), ...
                      'ForegroundColor', viewerForegroundColor('get'), ...                   
                      'position', [20 140 250 20]...
                      );
    
        edtBreastCancerBoneMaskThresholdValue = ...
            uicontrol(dlgBreastCancerSegmentation, ...
                      'Style'   , 'Edit', ...
                      'Position', [285 140 75 20], ...
                      'String'  , num2str(breastCancerSegmentationBoneMaskThresholdValue('get')), ...
                      'Enable'  , 'on', ...
                      'BackgroundColor', viewerBackgroundColor('get'), ...
                      'ForegroundColor', viewerForegroundColor('get'), ...
                      'CallBack', @edtBreastCancerBoneMaskThresholdValueCallback ...
                      ); 
    
         % Pixel Edge
    
            uicontrol(dlgBreastCancerSegmentation,...
                      'style'   , 'text',...
                      'Enable'  , 'Inactive',...
                      'string'  , 'Pixel Edge',...
                      'horizontalalignment', 'left',...
                      'BackgroundColor', viewerBackgroundColor('get'), ...
                      'ForegroundColor', viewerForegroundColor('get'), ...                   
                      'ButtonDownFcn'  , @chkBreastCancerPixelEdgeCallback, ...
                      'position', [40 90 150 20]...
                      );
    
        chkBreastCancerPixelEdge = ...
            uicontrol(dlgBreastCancerSegmentation,...
                      'style'   , 'checkbox',...
                      'enable'  , 'on',...
                      'value'   , pixelEdge('get'),...
                      'position', [20 90 20 20],...
                      'BackgroundColor', viewerBackgroundColor('get'), ...
                      'ForegroundColor', viewerForegroundColor('get'), ...                   
                      'Callback', @chkBreastCancerPixelEdgeCallback...
                      );
    
        % Smallest Contour (ml)
    
            uicontrol(dlgBreastCancerSegmentation,...
                      'style'   , 'text',...
                      'Enable'  , 'On',...
                      'string'  , 'Smallest Contour (ml)',...
                      'horizontalalignment', 'left',...
                      'BackgroundColor', viewerBackgroundColor('get'), ...
                      'ForegroundColor', viewerForegroundColor('get'), ...                   
                      'position', [20 65 250 20]...
                      );
    
        edtBreastCancerSmalestVoiValue = ...
            uicontrol(dlgBreastCancerSegmentation, ...
                      'Style'   , 'Edit', ...
                      'Position', [285 65 75 20], ...
                      'String'  , num2str(breastCancerSmalestVoiValue('get')), ...
                      'Enable'  , 'on', ...
                      'BackgroundColor', viewerBackgroundColor('get'), ...
                      'ForegroundColor', viewerForegroundColor('get'), ...
                      'CallBack', @edtBreastCancerSmalestVoiValueCallback ...
                      );  
    
         % Cancel or Proceed
    
         uicontrol(dlgBreastCancerSegmentation,...
                   'String','Cancel',...
                   'Position',[285 7 75 25],...
                   'BackgroundColor', viewerBackgroundColor('get'), ...
                   'ForegroundColor', viewerForegroundColor('get'), ...                
                   'Callback', @cancelBreastCancerSegmentationCallback...
                   );
    
         uicontrol(dlgBreastCancerSegmentation,...
                  'String','Proceed',...
                  'Position',[200 7 75 25],...
                  'BackgroundColor', viewerBackgroundColor('get'), ...
                  'ForegroundColor', viewerForegroundColor('get'), ...               
                  'Callback', @proceedBreastCancerSegmentationCallback...
                  );    
         
    else % Execute the segmentation using the default values

        dSmalestVoiValue   = breastCancerSmalestVoiValue('get');
        dPixelEdge         = pixelEdge('get');
        dBoneMaskThreshold = breastCancerSegmentationBoneMaskThresholdValue('get');
        dSUVThreshold      = breastCancerSegmentationSUVThresholdValue('get');
        dBoneThreshold     = breastCancerSegmentationBoneSUVThresholdValue('get');

        if ~isempty(gdNormalLiverMean) && ~isempty(gdNormalLiverSTD)

            dSUVThreshold = (1.5*gdNormalLiverMean)+(2 * gdNormalLiverSTD);

            dBoneThreshold = dSUVThreshold * 3 / 4;

%             if dBoneThreshold > dSUVThreshold
% 
%                 dBoneThreshold = dSUVThreshold;
%             end
        end

        setSegmentationFDGSUV(dBoneMaskThreshold, dSmalestVoiValue, dPixelEdge, dSUVThreshold, dBoneThreshold); 

    end

    function edtBreastCancerSmalestVoiValueCallback(~, ~)

        dObjectValue = str2double(get(edtBreastCancerSmalestVoiValue, 'String'));

        if dObjectValue < 0

            dObjectValue = 0;

            set(edtBreastCancerSmalestVoiValue, 'String', num2str(dObjectValue));
        end

        breastCancerSmalestVoiValue('set', dObjectValue);

    end

    function chkBreastCancerPixelEdgeCallback(hObject, ~)  
                
        bObjectValue = get(chkBreastCancerPixelEdge, 'Value');
        
        if strcmpi(get(hObject, 'Style'), 'text')
            
            set(chkBreastCancerPixelEdge, 'Value', ~bObjectValue);
        end        
        
        bObjectValue = get(chkBreastCancerPixelEdge, 'Value');

        pixelEdge('set', bObjectValue);
        
        % Set contour panel checkbox
        set(chkPixelEdgePtr('get'), 'Value', pixelEdge('get'));
    end

    function edtBreastCancerThresholdOfMaxValueCallback(~, ~)     

        dSUVThreshold = str2double(get(edtBreastCancerThresholdOfMaxValue, 'String'));

        if dSUVThreshold <= 0

            dSUVThreshold = 10;
            set(edtBreastCancerThresholdOfMaxValue, 'String', num2str(dSUVThreshold));

        elseif dSUVThreshold >= 100
            
            dSUVThreshold = 10;
            set(edtBreastCancerThresholdOfMaxValue, 'String', num2str(dSUVThreshold));           
        end

        breastCancerSegmentationSUVThresholdValue('set', dSUVThreshold);

    end

    function edtFDGBoneSUVThresholdOfMaxValueCallback(~, ~)     

        dSUVThreshold = str2double(get(edtFDGBoneSUVThresholdOfMaxValue, 'String'));

        if dSUVThreshold <= 0

            dSUVThreshold = 10;
            set(edtFDGBoneSUVThresholdOfMaxValue, 'String', num2str(dSUVThreshold));

        elseif dSUVThreshold >= 100
            
            dSUVThreshold = 10;
            set(edtFDGBoneSUVThresholdOfMaxValue, 'String', num2str(dSUVThreshold));           
        end

        breastCancerSegmentationBoneSUVThresholdValue('set', dSUVThreshold);

    end

    function edtBreastCancerBoneMaskThresholdValueCallback(~, ~)     

        dBoneMaskThreshold = str2double(get(edtBreastCancerBoneMaskThresholdValue, 'String'));

        if dBoneMaskThreshold <= 0

            dBoneMaskThreshold = 100;
            set(edtBreastCancerBoneMaskThresholdValue, 'String', num2str(dBoneMaskThreshold));        
        end

        breastCancerSegmentationBoneMaskThresholdValue('set', dBoneMaskThreshold);

    end

    function cancelBreastCancerSegmentationCallback(~, ~)   

        delete(dlgBreastCancerSegmentation);
    end
    
    function proceedBreastCancerSegmentationCallback(~, ~)

        dSmalestVoiValue   = str2double(get(edtBreastCancerSmalestVoiValue, 'String'));
        dPixelEdge         = get(chkBreastCancerPixelEdge, 'value');
        dBoneMaskThreshold = str2double(get(edtBreastCancerBoneMaskThresholdValue, 'String'));
        dSUVThreshold      = str2double(get(edtBreastCancerThresholdOfMaxValue, 'String'));
        dBoneThreshold     = str2double(get(edtFDGBoneSUVThresholdOfMaxValue, 'String'));

        delete(dlgBreastCancerSegmentation);

        setSegmentationFDGSUV(dBoneMaskThreshold, dSmalestVoiValue, dPixelEdge, dSUVThreshold, dBoneThreshold); 
    end

end