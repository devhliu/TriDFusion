function maskToVoi(aMask, sLabel, aColor)
%function maskToVoi(aMask, aColor)
%Create a VOI from a 3D mask.
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
% TriDFusion development has been led by: Daniel Lafontaine
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

    aMaskSize = size(aMask);

    if numel(aMaskSize) ~= 3 % Must be 3D array
        return;
    end
    
    axRoi = axes3Ptr('get');
     
    asTag = [];
    
    for mm=1: aMaskSize(3)
        if any(aMask(:,:,mm), 'all')
            
            sliceNumber('set', 'axial', mm);
            
            sTag = num2str(rand);

            B = bwboundaries(aMask(:,:,mm));
            pRoi = drawfreehand(axRoi, 'Position', flip(B{1}, 2), 'Color', aColor, 'LineWidth', 1, 'Label', '', 'LabelVisible', 'off', 'Tag', sTag, 'Visible', 'off');         
            
            gca = axes3Ptr('get');
            addRoi(pRoi);                  

            roiDefaultMenu(pRoi);

            uimenu(pRoi.UIContextMenu,'Label', 'Clear Waypoints' , 'UserData',pRoi, 'Callback', @clearWaypointsCallback); 

            cropMenu(pRoi);

            uimenu(pRoi.UIContextMenu,'Label', 'Display Result' , 'UserData',pRoi, 'Callback',@figRoiDialogCallback, 'Separator', 'on'); 

            set(fiMainWindowPtr('get'), 'WindowScrollWheelFcn' , @wheelScroll);
            
            asTag{numel(asTag)+1} = sTag;
            
        end
    end
    
    if ~isempty(asTag)
        createVoiFromRois(asTag, sLabel);
    end
    
end