function adjScroll(dInitCoord)
%function adjScroll(dInitCoord)
%Ajust 2D Window Level using mouse right click.
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

    persistent pdInitialCoord;

    if exist('dInitCoord', 'var')

        pdInitialCoord = dInitCoord;
    end
   
    pFigure = fiMainWindowPtr('get');
    
    aPosDiff = pFigure.CurrentPoint(1, 1:2) - pdInitialCoord;

    if aPosDiff(2) > 0
        evnt.VerticalScrollCount = 0;
    else
        evnt.VerticalScrollCount = 1;
    end
       
    wheelScroll(1, evnt) 
    windowButton('set', 'down');  

    pdInitialCoord = pFigure.CurrentPoint(1, 1:2);
      
end
