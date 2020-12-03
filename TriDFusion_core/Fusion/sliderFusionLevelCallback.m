function sliderFusionLevelCallback(~, ~)  
%function sliderFusionLevelCallback(~, ~)
%Set Fusion Level Slider.
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

    lMax = fusionWindowLevel('get', 'max');
    [lInitMax, lInitMin] = getFusionInitWindowMinMax('get');

    lNewMax = (1+lInitMax) * get(uiFusionSliderLevelPtr('get'),'Value')/0.5;

    lRange = abs(lInitMax-lInitMin);
    lMin = lNewMax - lRange;

    if (lMin < lMax)

        windowLevel('set', 'min', lMin);
        sliderFusionWindowLevelValue('set', 'min', get(uiFusionSliderLevelPtr('get'), 'Value'));

        if switchTo3DMode('get')     == false && ...
           switchToIsoSurface('get') == false && ...
           switchToMIPMode('get')    == false

            if size(dicomBuffer('get'), 3) == 1            
                set(axefPtr('get'), 'CLim', [lMin lMax]);
            else
                set(axes1fPtr('get'), 'CLim', [lMin lMax]);
                set(axes2fPtr('get'), 'CLim', [lMin lMax]);
                set(axes3fPtr('get'), 'CLim', [lMin lMax]);
            end

            if isVsplash('get') == false      
                refreshImages();
            end
        end
    end
end
