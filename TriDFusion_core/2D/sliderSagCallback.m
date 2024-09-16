function sliderSagCallback(~, ~)
%function sliderSagCallback(~, ~)
%Set Sagittal Slider.
%See TriDFuison.doc (or pdf) for more information about options.
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

    if ~isempty(uiSliderSagPtr('get'))

        if get(uiSliderSagPtr('get'), 'Value') >= 0 && ...
           get(uiSliderSagPtr('get'), 'Value') <= 1 && ...
           strcmpi(windowButton('get'), 'up')  
    
            if get(uiSliderSagPtr('get'), 'Value') == 0
                dSliceNumber = 1;
            else
                dSliceNumber = round(get(uiSliderSagPtr('get'), 'Value') * size(dicomBuffer('get', [], get(uiSeriesPtr('get'), 'Value')), 2));
            end
            if dSliceNumber < 0
                dSliceNumber = 1;
            end
            
            sliceNumber('set', 'sagittal', dSliceNumber); 
            
            refreshImages();
            
            % drawnow;
        end
    end
end    