function setMachineLearningFDGBrownFatSUV(sSegmentatorScript, sSegmentatorCombineMasks, tBrownFatSUV)
%function setMachineLearningFDGBrownFatSUV(sSegmentatorScript, sSegmentatorCombineMasks, tBrownFatSUV)
%Run FDG brown Fat Segmentation base on a SUV treshold.
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
            
    atInput = inputTemplate('get');
    
    % Modality validation    
       
    dCTSerieOffset = [];
    for tt=1:numel(atInput)
        if strcmpi(atInput(tt).atDicomInfo{1}.Modality, 'ct')
            dCTSerieOffset = tt;
            break
        end
    end

    dPTSerieOffset = [];
    for tt=1:numel(atInput)
        if strcmpi(atInput(tt).atDicomInfo{1}.Modality, 'pt')
            dPTSerieOffset = tt;
            break
        end
    end

    if isempty(dCTSerieOffset) || ...
       isempty(dPTSerieOffset)  
        progressBar(1, 'Error: FDG tumor segmentation require a CT and PT image!');
        errordlg('FDG tumor segmentation require a CT and PT image!', 'Modality Validation');  
        return;               
    end


    atPTMetaData = dicomMetaData('get', [], dPTSerieOffset);
    atCTMetaData = dicomMetaData('get', [], dCTSerieOffset);

    aPTImage = dicomBuffer('get', [], dPTSerieOffset);
    if isempty(aPTImage)
        aInputBuffer = inputBuffer('get');
        aPTImage = aInputBuffer{dPTSerieOffset};
    end

    aCTImage = dicomBuffer('get', [], dCTSerieOffset);
    if isempty(aCTImage)
        aInputBuffer = inputBuffer('get');
        aCTImage = aInputBuffer{dCTSerieOffset};
    end

    if isempty(atPTMetaData)
        atPTMetaData = atInput(dPTSerieOffset).atDicomInfo;
    end

    if isempty(atCTMetaData)
        atCTMetaData = atInput(dCTSerieOffset).atDicomInfo;
    end

    if get(uiSeriesPtr('get'), 'Value') ~= dPTSerieOffset
        set(uiSeriesPtr('get'), 'Value', dPTSerieOffset);

        setSeriesCallback();
    end

    tQuant = quantificationTemplate('get');

    if isfield(tQuant, 'tSUV')
        dSUVScale = tQuant.tSUV.dScale;
    else
        dSUVScale = 0;
    end 

    % Apply ROI constraint 

    [asConstraintTagList, asConstraintTypeList] = roiConstraintList('get', dPTSerieOffset);

    bInvertMask = invertConstraint('get');

    tRoiInput = roiTemplate('get', dPTSerieOffset);
    
    aPTImageTemp = aPTImage;
    aLogicalMask = roiConstraintToMask(aPTImageTemp, tRoiInput, asConstraintTagList, asConstraintTypeList, bInvertMask); 
    aPTImageTemp(aLogicalMask==0) = 0;  % Set constraint 

    resetSeries(dPTSerieOffset, true);       

    try 

    set(fiMainWindowPtr('get'), 'Pointer', 'watch');
    drawnow;    

    % Get DICOM directory directory    
    
    [sFilePath, ~, ~] = fileparts(char(atInput(dCTSerieOffset).asFilesList{1}));
    
    % Create an empty directory    

    sNiiTmpDir = sprintf('%stemp_nii_%s/', viewerTempDirectory('get'), datetime('now','Format','MMMM-d-y-hhmmss'));
    if exist(char(sNiiTmpDir), 'dir')
        rmdir(char(sNiiTmpDir), 's');
    end
    mkdir(char(sNiiTmpDir));    
    
    % Convert dicom to .nii     
    
    progressBar(1/12, 'DICOM to NII conversion, please wait.');

    dicm2nii(sFilePath, sNiiTmpDir, 1);
    
    sNiiFullFileName = '';
    
    f = java.io.File(char(sNiiTmpDir)); % Get .nii file name
    dinfo = f.listFiles();                   
    for K = 1 : 1 : numel(dinfo)
        if ~(dinfo(K).isDirectory)
            if contains(sprintf('%s%s', sNiiTmpDir, dinfo(K).getName()), '.nii.gz')
                sNiiFullFileName = sprintf('%s%s', sNiiTmpDir, dinfo(K).getName());
                break;
            end
        end
    end 

    if isempty(sNiiFullFileName)
        
        progressBar(1, 'Error: nii file mot found!');
        errordlg('nii file mot found!!', '.nii file Validation'); 
    else

        progressBar(2/12, 'Machine learning in progress, this might take several minutes, please be patient.');
       
        sSegmentationFolderName = sprintf('%stemp_seg_%s/', viewerTempDirectory('get'), datetime('now','Format','MMMM-d-y-hhmmss'));
        if exist(char(sSegmentationFolderName), 'dir')
            rmdir(char(sSegmentationFolderName), 's');
        end
        mkdir(char(sSegmentationFolderName)); 
    
        if ispc % Windows
      
%            if fastMachineLearningDialog('get') == true
%                sCommandLine = sprintf('cmd.exe /c python.exe %sTotalSegmentator -i %s -o %s --fast', sSegmentatorScript, sNiiFullFileName, sSegmentationFolderName);    
%            else
                sCommandLine = sprintf('cmd.exe /c python.exe %s -i %s -o %s --fast --force_split --body_seg', sSegmentatorScript, sNiiFullFileName, sSegmentationFolderName);    
%            end
        
            [bStatus, sCmdout] = system(sCommandLine);
            
            if bStatus 
                progressBar( 1, 'Error: An error occur during machine learning segmentation!');
                errordlg(sprintf('An error occur during machine learning segmentation: %s', sCmdout), 'Segmentation Error');  
            else % Process succeed

                progressBar(3/12, 'Importing organ exclusion mask, please wait.');

                aExcludeMask = getBrownFatSUVExcludeMask(tBrownFatSUV, sSegmentationFolderName, sSegmentatorCombineMasks, zeros(size(aCTImage)));
                aExcludeMask = imdilate(aExcludeMask, strel('sphere', 4)); % Increse mask by 4 pixels

                if tBrownFatSUV.exclude.organ.skeleton == true

                    progressBar(4/12, 'Importing bone exclusion mask, please wait.');

                    aBoneExcludeMask = getTotalSegmentorWholeBodyMask(sSegmentationFolderName, zeros(size(aCTImage)));
%                     aBoneExcludeMask = imfill(aBoneExcludeMask, 4, 'holes');   

%                     aBoneExcludeMask = imdilate(aBoneExcludeMask, strel('sphere', 2)); % Increse mask by 2 pixels

                    aExcludeMask(aBoneExcludeMask~=0) = 1;

                    clear aBoneExcludeMask;
                end

                dLowerSlice = getTotalSegmentorObjectSliceNumber(sSegmentationFolderName, 'sacrum', 'upper');

                if dLowerSlice > 1 && dLowerSlice < size(aExcludeMask, 3)
                    aExcludeMask(:,:,dLowerSlice:end) = 1;
                end

                dUpperSlice = getTotalSegmentorObjectSliceNumber(sSegmentationFolderName, 'skull' , 'lower')-5;

                if dUpperSlice > 1 && dUpperSlice < size(aExcludeMask, 3)
                    aExcludeMask(:,:,1:dUpperSlice)   = 1;
                end

if 0
                progressBar(5/12, 'Computing fuzzy c-means clustering, please wait.');

                aFuzzImage = fuzzy3DSegmentation(aPTImage);
%                 aFuzzImage = aFuzzImage >= tBrownFatSUV.options.fuzzyClusterSelection;
                aFuzzImage = aFuzzImage >= 2;

%                 aFuzzImage(aFuzzImage<4)= min(aFuzzImage, [], 'all');
%                 aFuzzImage = imbinarize(aFuzzImage);

                aPTImageTemp(aFuzzImage==0) = min(aPTImageTemp, [], 'all');   

                clear aFuzzImage;
end

                progressBar(6/12, 'Resampling series, please wait.');

                [aResampledPTImageTemp, ~] = resampleImage(aPTImageTemp, atPTMetaData, aCTImage, atCTMetaData, 'Linear', true, false);   
                [aResampledPTImage, atResampledPTMetaData] = resampleImage(aPTImage, atPTMetaData, aCTImage, atCTMetaData, 'Linear', true, false);   

                dicomMetaData('set', atResampledPTMetaData, dPTSerieOffset);
                dicomBuffer  ('set', aResampledPTImage, dPTSerieOffset);
    
                aResampledPTImage = aResampledPTImageTemp;

                if ~isequal(size(aExcludeMask), size(aResampledPTImage)) % Verify if both images are in the same field of view 
            
                     aExcludeMask = resample3DImage(aExcludeMask, atCTMetaData, aResampledPTImage, atResampledPTMetaData, 'Cubic');
                     aExcludeMask = imbinarize(aExcludeMask);
            
                    if ~isequal(size(aExcludeMask), size(aResampledPTImage)) % Verify if both images are in the same field of view     
                        aExcludeMask = resizeMaskToImageSize(aExcludeMask, aResampledPTImage); 
                    end
                else
                    aExcludeMask = imbinarize(aExcludeMask);
                end

                aResampledPTImage(aExcludeMask) = min(aResampledPTImage, [], 'all');

if 1                    
                progressBar(7/12, 'Computing CT HU exclusion mask, please wait.');

                aHUExcludeMask = ones(size(aCTImage));

                aHUExcludeMask(aCTImage < tBrownFatSUV.options.HUThreshold.min) = 0;
                aHUExcludeMask(aCTImage > tBrownFatSUV.options.HUThreshold.max) = 0;

                aHUExcludeMask = imdilate(aHUExcludeMask, strel('sphere', 4)); % Increse mask by 4 pixels

                if ~isequal(size(aHUExcludeMask), size(aResampledPTImage)) % Verify if both images are in the same field of view 
            
                     aHUExcludeMask = resample3DImage(aHUExcludeMask, atCTMetaData, aResampledPTImage, atResampledPTMetaData, 'Cubic');
                     aHUExcludeMask = imbinarize(aHUExcludeMask);
            
                    if ~isequal(size(aHUExcludeMask), size(aResampledPTImage)) % Verify if both images are in the same field of view     
                        aHUExcludeMask = resizeMaskToImageSize(aHUExcludeMask, aResampledPTImage); 
                    end
                else
                    aHUExcludeMask = imbinarize(aHUExcludeMask);
                end

                aResampledPTImage(aHUExcludeMask==0) = min(aResampledPTImage, [], 'all');

                clear aHUExcludeMask;

end
                progressBar(8/12, 'Computing CT BW mask, please wait.');

                BWCT = imbinarize(aCTImage);

%                 dCTMin = min(aCTImage, [], 'all');
% 
%                 aCTImage(aCTImage < tBrownFatSUV.options.HUThreshold.min) = dCTMin;
%                 aCTImage(aCTImage > tBrownFatSUV.options.HUThreshold.max) = dCTMin;
%                  
%                 aResampledPTImage(aCTImage==dCTMin) = min(aResampledPTImage, [], 'all');

                clear aPTImageTemp;
                clear aResampledPTImageTemp;
                clear aExcludeMask;
            
                progressBar(9/12, 'Resampling mip, please wait.');
                        
                refMip = mipBuffer('get', [], dCTSerieOffset);                        
                aMip   = mipBuffer('get', [], dPTSerieOffset);
              
                aMip = resampleMip(aMip, atPTMetaData, refMip, atCTMetaData, 'Linear', true);
                               
                mipBuffer('set', aMip, dPTSerieOffset);
            
                setQuantification(dPTSerieOffset);    
            
            
                progressBar(10/12, 'Computing SUV mask, please wait.');
            

                aBWMask = aResampledPTImage;
            
                dMin = min(aResampledPTImage, [], 'all');

                dTreshold = tBrownFatSUV.options.SUVThreshold;
                aBWMask(aBWMask*dSUVScale<dTreshold) = dMin;
     
                aBWMask = imbinarize(aBWMask);
         

                progressBar(11/12, 'Creating contours, please wait.');

                imMask = aResampledPTImage;
                imMask(aBWMask == 0) = dMin;
            
                setSeriesCallback();
            
                sFormula = [];

                dSmalestVoiValue = tBrownFatSUV.options.smalestVoiValue;
                bPixelEdge = tBrownFatSUV.options.pixelEdge;

                maskAddVoiToSeries(imMask, aBWMask, bPixelEdge, false, dTreshold, false, 0, false, sFormula, BWCT, dSmalestVoiValue); 

                clear aResampledPTImage;
                clear aBWMask;
                clear refMip;                        
                clear aMip;
                clear BWCT;
                clear imMask;

            end

        elseif isunix % Linux is not yet supported

            progressBar( 1, 'Error: Machine Learning under Linux is not supported');
            errordlg('Machine Learning under Linux is not supported', 'Machine Learning Validation');

        else % Mac is not yet supported

            progressBar( 1, 'Error: Machine Learning under Mac is not supported');
            errordlg('Machine Learning under Mac is not supported', 'Machine Learning Validation');
        end

        if exist(char(sSegmentationFolderName), 'dir')
            rmdir(char(sSegmentationFolderName), 's');
        end         
    end

    setVoiRoiSegPopup();

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

    % Triangulate og 1st VOI

    atVoiInput = voiTemplate('get', dPTSerieOffset);

    if ~isempty(atVoiInput)

        dRoiOffset = round(numel(atVoiInput{1}.RoisTag)/2);

        triangulateRoi(atVoiInput{1}.RoisTag{dRoiOffset});
    end

    % Activate ROI Panel

    if viewRoiPanel('get') == false
        setViewRoiPanel();
    end

    refreshImages();

    clear aPTImage;
    clear aCTImage;

    % Delete .nii folder    
    
    if exist(char(sNiiTmpDir), 'dir')
        rmdir(char(sNiiTmpDir), 's');
    end       
    
    progressBar(1, 'Ready');

    catch 
        resetSeries(dPTSerieOffset, true);       
        progressBar( 1 , 'Error: setSegmentationFDGBrownFatSUV()' );
    end

    set(fiMainWindowPtr('get'), 'Pointer', 'default');
    drawnow;
            
end