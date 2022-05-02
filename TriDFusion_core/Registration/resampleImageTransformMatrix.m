function [resampImage, atDcmMetaData] = resampleImageTransformMatrix(dcmImage, atDcmMetaData, refImage, atRefMetaData, sMode)
%function [resampImage, atDcmMetaData] = resampleImageTransformMatrix(dcmImage, atDcmMetaData, refImage, atRefMetaData, sMode)
%Resample any modalities using a transfer matrix.
%See TriDFuison.doc (or pdf) for more information about options.
%
%Note: option settings must fit on one line and can contain one semicolon at most.
%Options can be strings, cell arrays of strings, or numerical arrays.
%
%Author: Daniel Lafontaine, lafontad@mskcc.org
%
%Last specifications modified:
%
% Copyright 2020, Daniel Lafontaine, on behalf of the TriDFusion development team.
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

    dimsRef = size(refImage);        
    dimsDcm = size(dcmImage);

    dcmSliceThickness = computeSliceSpacing(atDcmMetaData);
    refSliceThickness = computeSliceSpacing(atRefMetaData);       

    [M, ~] = getTransformMatrix(atDcmMetaData{1}, dcmSliceThickness, atRefMetaData{1}, refSliceThickness);
    TF = affine3d(M);

    Rdcm = imref3d(dimsDcm, atDcmMetaData{1}.PixelSpacing(2), atDcmMetaData{1}.PixelSpacing(1), dcmSliceThickness);
%    Rref = imref3d(size(refImage), atDcmMetaData{1}.PixelSpacing(2), atDcmMetaData{1}.PixelSpacing(1), refSliceThickness);
    [resampImage, ~] = imwarp(dcmImage, Rdcm, TF,'Interp', sMode, 'FillValues', double(min(dcmImage,[],'all')));  

    if numel(resampImage) ~=  numel(refImage) % SPECT and CT DX

        [resampImage, ~] = imwarp(dcmImage, Rdcm, TF,'Interp', sMode, 'FillValues', double(min(dcmImage,[],'all')));  

        dimsRsp = size(resampImage);         
        xMoveOffset = (dimsRsp(1)-dimsRef(1))/2;
        yMoveOffset = (dimsRsp(2)-dimsRef(2))/2;

        resampImage = imtranslate(resampImage,[-xMoveOffset, -yMoveOffset, 0], 'nearest', 'OutputView', 'same', 'FillValues', min(resampImage, [], 'all') );    

    end

    aResampledImageSize = size(resampImage);

    if numel(atDcmMetaData) ~= 1
        if aResampledImageSize(3) < numel(atDcmMetaData)
            atDcmMetaData = atDcmMetaData(1:numel(atRefMetaData)); % Remove some slices
        else
            for cc=1:aResampledImageSize(3) - numel(atDcmMetaData)
                atDcmMetaData{end+1} = atDcmMetaData{end}; %Add missing slice
            end            
        end
    end
    
    for jj=1:numel(atDcmMetaData)
        
        atDcmMetaData{jj}.InstanceNumber  = jj;               
        atDcmMetaData{jj}.NumberOfSlices  = aResampledImageSize(3);                
        
        atDcmMetaData{jj}.PixelSpacing(1) = atRefMetaData{1}.PixelSpacing(1);
        atDcmMetaData{jj}.PixelSpacing(2) = atRefMetaData{1}.PixelSpacing(2);
        atDcmMetaData{jj}.SliceThickness  = atRefMetaData{1}.SliceThickness;
        atDcmMetaData{jj}.SpacingBetweenSlices  = refSliceThickness;

        atDcmMetaData{jj}.Rows    = aResampledImageSize(1);
        atDcmMetaData{jj}.Columns = aResampledImageSize(2);
        
        
        atDcmMetaData{jj}.ImagePositionPatient(1) = atRefMetaData{1}.ImagePositionPatient(1);
        atDcmMetaData{jj}.ImagePositionPatient(2) = atRefMetaData{1}.ImagePositionPatient(2);
         
    end
              
    for cc=1:numel(atDcmMetaData)-1
        if atDcmMetaData{1}.ImagePositionPatient(3) < atDcmMetaData{2}.ImagePositionPatient(3)
            atDcmMetaData{cc+1}.ImagePositionPatient(3) = atDcmMetaData{cc}.ImagePositionPatient(3) + refSliceThickness;               
            atDcmMetaData{cc+1}.SliceLocation = atDcmMetaData{cc}.SliceLocation + refSliceThickness; 
        else
            atDcmMetaData{cc+1}.ImagePositionPatient(3) = atDcmMetaData{cc}.ImagePositionPatient(3) - refSliceThickness;               
            atDcmMetaData{cc+1}.SliceLocation = atDcmMetaData{cc}.SliceLocation - refSliceThickness;             
        end
    end    
    
end