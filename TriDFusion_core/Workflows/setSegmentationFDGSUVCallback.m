function setSegmentationFDGSUVCallback(hObject, ~)
%function setSegmentationFDGSUVCallback(hObject)
%Run FDGSUV Tumor Segmentation, The tool is called from the main menu.
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

    if exist('hObject', 'var')

        DLG_FDGSU_PERCENT_X = 380;
        DLG_FDGSU_PERCENT_Y = 210;

        if viewerUIFigure('get') == true
    
            dlgFDGSUVSegmentation = ...
                uifigure('Position', [(getMainWindowPosition('xpos')+(getMainWindowSize('xsize')/2)-DLG_FDGSU_PERCENT_X/2) ...
                                    (getMainWindowPosition('ypos')+(getMainWindowSize('ysize')/2)-DLG_FDGSU_PERCENT_Y/2) ...
                                    DLG_FDGSU_PERCENT_X ...
                                    DLG_FDGSU_PERCENT_Y ...
                                    ],...
                       'Resize', 'off', ...
                       'Color', viewerBackgroundColor('get'),...
                       'WindowStyle', 'modal', ...
                       'Name' , 'FDG SUV Segmentation'...
                       );
        else     
            dlgFDGSUVSegmentation = ...
                dialog('Position', [(getMainWindowPosition('xpos')+(getMainWindowSize('xsize')/2)-DLG_FDGSU_PERCENT_X/2) ...
                                    (getMainWindowPosition('ypos')+(getMainWindowSize('ysize')/2)-DLG_FDGSU_PERCENT_Y/2) ...
                                    DLG_FDGSU_PERCENT_X ...
                                    DLG_FDGSU_PERCENT_Y ...
                                    ],...
                       'MenuBar', 'none',...
                       'Resize', 'off', ...    
                       'NumberTitle','off',...
                       'MenuBar', 'none',...
                       'Color', viewerBackgroundColor('get'), ...
                       'Name', 'FDG SUV Segmentation',...
                       'Toolbar','none'...               
                       );       
        end
        % SUV threshold
    
            uicontrol(dlgFDGSUVSegmentation,...
                      'style'   , 'text',...
                      'Enable'  , 'On',...
                      'string'  , 'SUV Threshold',...
                      'horizontalalignment', 'left',...
                      'BackgroundColor', viewerBackgroundColor('get'), ...
                      'ForegroundColor', viewerForegroundColor('get'), ...                   
                      'position', [20 165 250 20]...
                      );
    
        edtFDGSUVThresholdOfMaxValue = ...
            uicontrol(dlgFDGSUVSegmentation, ...
                      'Style'   , 'Edit', ...
                      'Position', [285 165 75 20], ...
                      'String'  , num2str(FDGSegmentationSUVThresholdValue('get')), ...
                      'Enable'  , 'on', ...
                      'BackgroundColor', viewerBackgroundColor('get'), ...
                      'ForegroundColor', viewerForegroundColor('get'), ...
                      'CallBack', @edtFDGSUVThresholdOfMaxValueCallback ...
                      ); 
    
        % Bone mask threshold
    
            uicontrol(dlgFDGSUVSegmentation,...
                      'style'   , 'text',...
                      'Enable'  , 'On',...
                      'string'  , 'Bone mask threshold (HU)',...
                      'horizontalalignment', 'left',...
                      'BackgroundColor', viewerBackgroundColor('get'), ...
                      'ForegroundColor', viewerForegroundColor('get'), ...                   
                      'position', [20 140 250 20]...
                      );
    
        edtFDGSUVBoneMaskThresholdValue = ...
            uicontrol(dlgFDGSUVSegmentation, ...
                      'Style'   , 'Edit', ...
                      'Position', [285 140 75 20], ...
                      'String'  , num2str(FDGSegmentationBoneMaskThresholdValue('get')), ...
                      'Enable'  , 'on', ...
                      'BackgroundColor', viewerBackgroundColor('get'), ...
                      'ForegroundColor', viewerForegroundColor('get'), ...
                      'CallBack', @edtFDGSUVBoneMaskThresholdValueCallback ...
                      ); 
    
         % Pixel Edge
    
            uicontrol(dlgFDGSUVSegmentation,...
                      'style'   , 'text',...
                      'Enable'  , 'Inactive',...
                      'string'  , 'Pixel Edge',...
                      'horizontalalignment', 'left',...
                      'BackgroundColor', viewerBackgroundColor('get'), ...
                      'ForegroundColor', viewerForegroundColor('get'), ...                   
                      'ButtonDownFcn'  , @chkFDGSUVPixelEdgeCallback, ...
                      'position', [40 90 150 20]...
                      );
    
        chkFDGSUVPixelEdge = ...
            uicontrol(dlgFDGSUVSegmentation,...
                      'style'   , 'checkbox',...
                      'enable'  , 'on',...
                      'value'   , pixelEdge('get'),...
                      'position', [20 90 20 20],...
                      'BackgroundColor', viewerBackgroundColor('get'), ...
                      'ForegroundColor', viewerForegroundColor('get'), ...                   
                      'Callback', @chkFDGSUVPixelEdgeCallback...
                      );
    
        % Smallest Contour (ml)
    
            uicontrol(dlgFDGSUVSegmentation,...
                      'style'   , 'text',...
                      'Enable'  , 'On',...
                      'string'  , 'Smallest Contour (ml)',...
                      'horizontalalignment', 'left',...
                      'BackgroundColor', viewerBackgroundColor('get'), ...
                      'ForegroundColor', viewerForegroundColor('get'), ...                   
                      'position', [20 65 250 20]...
                      );
    
        edtFDGSUVSmalestVoiValue = ...
            uicontrol(dlgFDGSUVSegmentation, ...
                      'Style'   , 'Edit', ...
                      'Position', [285 65 75 20], ...
                      'String'  , num2str(FDGSmalestVoiValue('get')), ...
                      'Enable'  , 'on', ...
                      'BackgroundColor', viewerBackgroundColor('get'), ...
                      'ForegroundColor', viewerForegroundColor('get'), ...
                      'CallBack', @edtFDGSUVSmalestVoiValueCallback ...
                      );  
    
         % Cancel or Proceed
    
         uicontrol(dlgFDGSUVSegmentation,...
                   'String','Cancel',...
                   'Position',[285 7 75 25],...
                   'BackgroundColor', viewerBackgroundColor('get'), ...
                   'ForegroundColor', viewerForegroundColor('get'), ...                
                   'Callback', @cancelFDGSUVSegmentationCallback...
                   );
    
         uicontrol(dlgFDGSUVSegmentation,...
                  'String','Proceed',...
                  'Position',[200 7 75 25],...
                  'BackgroundColor', viewerBackgroundColor('get'), ...
                  'ForegroundColor', viewerForegroundColor('get'), ...               
                  'Callback', @proceedFDGSUVSegmentationCallback...
                  );    
         
    else % Execute the segmentation using the default values

        setSegmentationFDGSUV(FDGSegmentationBoneMaskThresholdValue('get'), ...
                              FDGSmalestVoiValue('get'), ...
                              pixelEdge('get'), ...
                              FDGSegmentationSUVThresholdValue('get'));        
    end

    function edtFDGSUVSmalestVoiValueCallback(~, ~)

        dObjectValue = str2double(get(edtFDGSUVSmalestVoiValue, 'String'));

        if dObjectValue < 0

            dObjectValue = 0;

            set(edtFDGSUVSmalestVoiValue, 'String', num2str(dObjectValue));
        end

        FDGSmalestVoiValue('set', dObjectValue);

    end

    function chkFDGSUVPixelEdgeCallback(hObject, ~)  
                
        bObjectValue = get(chkFDGSUVPixelEdge, 'Value');
        
        if strcmpi(get(hObject, 'Style'), 'text')
            
            set(chkFDGSUVPixelEdge, 'Value', ~bObjectValue);
        end        
        
        bObjectValue = get(chkFDGSUVPixelEdge, 'Value');

        pixelEdge('set', bObjectValue);
        
        % Set contour panel checkbox
        set(chkPixelEdgePtr('get'), 'Value', pixelEdge('get'));
    end

    function edtFDGSUVThresholdOfMaxValueCallback(~, ~)     

        dSUVThreshold = str2double(get(edtFDGSUVThresholdOfMaxValue, 'String'));

        if dSUVThreshold <= 0

            dSUVThreshold = 10;
            set(edtFDGSUVThresholdOfMaxValue, 'String', num2str(dSUVThreshold));

        elseif dSUVThreshold >= 100
            
            dSUVThreshold = 10;
            set(edtFDGSUVThresholdOfMaxValue, 'String', num2str(dSUVThreshold));           
        end

        FDGSegmentationSUVThresholdValue('set', dSUVThreshold);

    end

    function edtFDGSUVBoneMaskThresholdValueCallback(~, ~)     

        dBoneMaskThreshold = str2double(get(edtFDGSUVBoneMaskThresholdValue, 'String'));

        if dBoneMaskThreshold <= 0

            dBoneMaskThreshold = 100;
            set(edtFDGSUVBoneMaskThresholdValue, 'String', num2str(dBoneMaskThreshold));        
        end

        FDGSegmentationBoneMaskThresholdValue('set', dBoneMaskThreshold);

    end

    function cancelFDGSUVSegmentationCallback(~, ~)   

        delete(dlgFDGSUVSegmentation);
    end
    
    function proceedFDGSUVSegmentationCallback(~, ~)

        dSmalestVoiValue   = str2double(get(edtFDGSUVSmalestVoiValue, 'String'));
        dPixelEdge         = get(chkFDGSUVPixelEdge, 'value');
        dBoneMaskThreshold = str2double(get(edtFDGSUVBoneMaskThresholdValue, 'String'));
        dSUVThreshold      = str2double(get(edtFDGSUVThresholdOfMaxValue, 'String'));

        delete(dlgFDGSUVSegmentation);

        setSegmentationFDGSUV(dBoneMaskThreshold, dSmalestVoiValue, dPixelEdge, dSUVThreshold); 
    end

end