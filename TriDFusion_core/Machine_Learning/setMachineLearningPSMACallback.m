function setMachineLearningPSMACallback(~, ~)
%function setMachineLearningPSMACallback()
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

    [sSegmentatorScript, ~] = validateSegmentatorInstallation();

    dlgMachineLearningPSMA  = [];
  
    if ~isempty(sSegmentatorScript) % External Segmentor is installed

        DLG_PSMA_PERCENT_X = 380;
        DLG_PSMA_PERCENT_Y = 355;
    
        dlgMachineLearningPSMA = ...
            dialog('Position', [(getMainWindowPosition('xpos')+(getMainWindowSize('xsize')/2)-DLG_PSMA_PERCENT_X/2) ...
                                (getMainWindowPosition('ypos')+(getMainWindowSize('ysize')/2)-DLG_PSMA_PERCENT_Y/2) ...
                                DLG_PSMA_PERCENT_X ...
                                DLG_PSMA_PERCENT_Y ...
                                ],...
                   'MenuBar', 'none',...
                   'Resize', 'off', ...    
                   'NumberTitle','off',...
                   'MenuBar', 'none',...
                   'Color', viewerBackgroundColor('get'), ...
                   'Name', 'FDG Lymph Node SUV Segmentation',...
                   'Toolbar','none'...               
                   );    

    % Exclude organ list

        uicontrol(dlgMachineLearningPSMA,...
                  'style'   , 'text',...
                  'FontWeight','bold'  ,...
                  'string'  , 'Exclude organ list',...
                  'horizontalalignment', 'left',...
                  'BackgroundColor', viewerBackgroundColor('get'), ...
                  'ForegroundColor', viewerForegroundColor('get'), ...                   
                  'position', [20 315 300 20]...
                  );

    % Brain

        uicontrol(dlgMachineLearningPSMA,...
                  'style'   , 'text',...
                  'Enable'  , 'Inactive',...
                  'string'  , 'Brain',...
                  'horizontalalignment', 'left',...
                  'BackgroundColor', viewerBackgroundColor('get'), ...
                  'ForegroundColor', viewerForegroundColor('get'), ...                   
                  'ButtonDownFcn'  , @chkPSMABrainCallback, ...
                  'position', [60 287 150 20]...
                  );

    chkPSMABrain = ...
        uicontrol(dlgMachineLearningPSMA,...
                  'style'   , 'checkbox',...
                  'enable'  , 'on',...
                  'value'   , excludePSMABrain('get'),...
                  'position', [40 290 20 20],...
                  'BackgroundColor', viewerBackgroundColor('get'), ...
                  'ForegroundColor', viewerForegroundColor('get'), ...                   
                  'Callback', @chkPSMABrainCallback...
                  );

    % Spleen

        uicontrol(dlgMachineLearningPSMA,...
                  'style'   , 'text',...
                  'Enable'  , 'Inactive',...
                  'string'  , 'Spleen',...
                  'horizontalalignment', 'left',...
                  'BackgroundColor', viewerBackgroundColor('get'), ...
                  'ForegroundColor', viewerForegroundColor('get'), ...                   
                  'ButtonDownFcn'  , @chkPSMASpleenCallback, ...
                  'position', [60 262 150 20]...
                  );

    chkPSMASpleen = ...
        uicontrol(dlgMachineLearningPSMA,...
                  'style'   , 'checkbox',...
                  'enable'  , 'on',...
                  'value'   , excludePSMASpleen('get'),...
                  'position', [40 265 20 20],...
                  'BackgroundColor', viewerBackgroundColor('get'), ...
                  'ForegroundColor', viewerForegroundColor('get'), ...                   
                  'Callback', @chkPSMASpleenCallback...
                  );

    % Kidney left

        uicontrol(dlgMachineLearningPSMA,...
                  'style'   , 'text',...
                  'Enable'  , 'Inactive',...
                  'string'  , 'Kidney left',...
                  'horizontalalignment', 'left',...
                  'BackgroundColor', viewerBackgroundColor('get'), ...
                  'ForegroundColor', viewerForegroundColor('get'), ...                   
                  'ButtonDownFcn'  , @chkPSMAKidneyLeftCallback, ...
                  'position', [60 237 150 20]...
                  );

    chkPSMAKidneyLeft = ...
        uicontrol(dlgMachineLearningPSMA,...
                  'style'   , 'checkbox',...
                  'enable'  , 'on',...
                  'value'   , excludePSMAKidneyLeft('get'),...
                  'position', [40 240 20 20],...
                  'BackgroundColor', viewerBackgroundColor('get'), ...
                  'ForegroundColor', viewerForegroundColor('get'), ...                   
                  'Callback', @chkPSMAKidneyLeftCallback...
                  );

    % Kidney right

        uicontrol(dlgMachineLearningPSMA,...
                  'style'   , 'text',...
                  'Enable'  , 'Inactive',...
                  'string'  , 'Kidney right',...
                  'horizontalalignment', 'left',...
                  'BackgroundColor', viewerBackgroundColor('get'), ...
                  'ForegroundColor', viewerForegroundColor('get'), ...                   
                  'ButtonDownFcn'  , @chkPSMAKidneyRightCallback, ...
                  'position', [60 212 150 20]...
                  );

    chkPSMAKidneyRight = ...
        uicontrol(dlgMachineLearningPSMA,...
                  'style'   , 'checkbox',...
                  'enable'  , 'on',...
                  'value'   , excludePSMAKidneyRight('get'),...
                  'position', [40 215 20 20],...
                  'BackgroundColor', viewerBackgroundColor('get'), ...
                  'ForegroundColor', viewerForegroundColor('get'), ...                   
                  'Callback', @chkPSMAKidneyRightCallback...
                  );
    
    % Small bowel

        uicontrol(dlgMachineLearningPSMA,...
                  'style'   , 'text',...
                  'Enable'  , 'Inactive',...
                  'string'  , 'Small bowel',...
                  'horizontalalignment', 'left',...
                  'BackgroundColor', viewerBackgroundColor('get'), ...
                  'ForegroundColor', viewerForegroundColor('get'), ...                   
                  'ButtonDownFcn'  , @chkPSMASmallBowelCallback, ...
                  'position', [60 187 150 20]...
                  );

    chkPSMASmallBowel = ...
        uicontrol(dlgMachineLearningPSMA,...
                  'style'   , 'checkbox',...
                  'enable'  , 'on',...
                  'value'   , excludePSMASmallBowel('get'),...
                  'position', [40 190 20 20],...
                  'BackgroundColor', viewerBackgroundColor('get'), ...
                  'ForegroundColor', viewerForegroundColor('get'), ...                   
                  'Callback', @chkPSMASmallBowelCallback...
                  );

    % Urinary bladder

        uicontrol(dlgMachineLearningPSMA,...
                  'style'   , 'text',...
                  'Enable'  , 'Inactive',...
                  'string'  , 'Urinary bladder',...
                  'horizontalalignment', 'left',...
                  'BackgroundColor', viewerBackgroundColor('get'), ...
                  'ForegroundColor', viewerForegroundColor('get'), ...                   
                  'ButtonDownFcn'  , @chkPSMAUrinaryBladderCallback, ...
                  'position', [60 162 150 20]...
                  );

    chkPSMAUrinaryBladder = ...
        uicontrol(dlgMachineLearningPSMA,...
                  'style'   , 'checkbox',...
                  'enable'  , 'on',...
                  'value'   , excludePSMAUrinaryBladder('get'),...
                  'position', [40 165 20 20],...
                  'BackgroundColor', viewerBackgroundColor('get'), ...
                  'ForegroundColor', viewerForegroundColor('get'), ...                   
                  'Callback', @chkPSMAUrinaryBladderCallback...
                  );

    % Options

        uicontrol(dlgMachineLearningPSMA,...
                  'style'     , 'text',...
                  'FontWeight','bold'  ,...
                  'string'    , 'Options',...
                  'horizontalalignment', 'left',...
                  'BackgroundColor', viewerBackgroundColor('get'), ...
                  'ForegroundColor', viewerForegroundColor('get'), ...                   
                  'position', [20 115 300 20]...
                  );    

         % Pixel Edge
    
            uicontrol(dlgMachineLearningPSMA,...
                      'style'   , 'text',...
                      'Enable'  , 'Inactive',...
                      'string'  , 'Pixel Edge',...
                      'horizontalalignment', 'left',...
                      'BackgroundColor', viewerBackgroundColor('get'), ...
                      'ForegroundColor', viewerForegroundColor('get'), ...                   
                      'ButtonDownFcn'  , @chkPSMAPixelEdgeCallback, ...
                      'position', [40 87 150 20]...
                      );
    
        chkPSMAPixelEdge = ...
            uicontrol(dlgMachineLearningPSMA,...
                      'style'   , 'checkbox',...
                      'enable'  , 'on',...
                      'value'   , pixelEdge('get'),...
                      'position', [20 90 20 20],...
                      'BackgroundColor', viewerBackgroundColor('get'), ...
                      'ForegroundColor', viewerForegroundColor('get'), ...                   
                      'Callback', @chkPSMAPixelEdgeCallback...
                      );
    
        % Smallest Contour (ml)
    
            uicontrol(dlgMachineLearningPSMA,...
                      'style'   , 'text',...
                      'Enable'  , 'On',...
                      'string'  , 'Smallest Contour (ml)',...
                      'horizontalalignment', 'left',...
                      'BackgroundColor', viewerBackgroundColor('get'), ...
                      'ForegroundColor', viewerForegroundColor('get'), ...                   
                      'position', [20 62 250 20]...
                      );
    
        edtPSMASmalestVoiValue = ...
            uicontrol(dlgMachineLearningPSMA, ...
                      'Style'   , 'Edit', ...
                      'Position', [285 65 75 20], ...
                      'String'  , num2str(FDGSmalestVoiValue('get')), ...
                      'Enable'  , 'on', ...
                      'BackgroundColor', viewerBackgroundColor('get'), ...
                      'ForegroundColor', viewerForegroundColor('get'), ...
                      'CallBack', @edtPSMASmalestVoiValueCallback ...
                      );  
    
         % Cancel or Proceed
    
         uicontrol(dlgMachineLearningPSMA,...
                   'String','Cancel',...
                   'Position',[285 7 75 25],...
                   'BackgroundColor', viewerBackgroundColor('get'), ...
                   'ForegroundColor', viewerForegroundColor('get'), ...                
                   'Callback', @cancelMachineLearningPSMACallback...
                   );
    
         uicontrol(dlgMachineLearningPSMA,...
                  'String','Proceed',...
                  'Position',[200 7 75 25],...
                  'BackgroundColor', viewerBackgroundColor('get'), ...
                  'ForegroundColor', viewerForegroundColor('get'), ...               
                  'Callback', @proceedMachineLearningPSMACallback...
                  );    
    end

    % Exclude organ list

    % Brain

    function chkPSMABrainCallback(hObject, ~)  
                
        bObjectValue = get(chkPSMABrain, 'Value');
        
        if strcmpi(get(hObject, 'Style'), 'text')
            
            set(chkPSMABrain, 'Value', ~bObjectValue);
        end        
        
        bObjectValue = get(chkPSMABrain, 'Value');

        excludePSMABrain('set', bObjectValue);

    end

    % Kidney Left

    function chkPSMAKidneyLeftCallback(hObject, ~)  
                
        bObjectValue = get(chkPSMAKidneyLeft, 'Value');
        
        if strcmpi(get(hObject, 'Style'), 'text')
            
            set(chkPSMAKidneyLeft, 'Value', ~bObjectValue);
        end        
        
        bObjectValue = get(chkPSMAKidneyLeft, 'Value');

        excludePSMAKidneyLeft('set', bObjectValue);

    end

    % Kidney Right

    function chkPSMAKidneyRightCallback(hObject, ~)  
                
        bObjectValue = get(chkPSMAKidneyRight, 'Value');
        
        if strcmpi(get(hObject, 'Style'), 'text')
            
            set(chkPSMAKidneyRight, 'Value', ~bObjectValue);
        end        
        
        bObjectValue = get(chkPSMAKidneyRight, 'Value');

        excludePSMAKidneyRight('set', bObjectValue);

    end

    % Small Bowel

    function chkPSMASmallBowelCallback(hObject, ~)  
                
        bObjectValue = get(chkPSMASmallBowel, 'Value');
        
        if strcmpi(get(hObject, 'Style'), 'text')
            
            set(chkPSMASmallBowel, 'Value', ~bObjectValue);
        end        
        
        bObjectValue = get(chkPSMASmallBowel, 'Value');

        excludePSMASmallBowel('set', bObjectValue);

    end


    % Spleen

    function chkPSMASpleenCallback(hObject, ~)  
                
        bObjectValue = get(chkPSMASpleen, 'Value');
        
        if strcmpi(get(hObject, 'Style'), 'text')
            
            set(chkPSMASpleen, 'Value', ~bObjectValue);
        end        
        
        bObjectValue = get(chkPSMASpleen, 'Value');

        excludePSMASpleen('set', bObjectValue);

    end

    function edtPSMASmalestVoiValueCallback(~, ~)

        dObjectValue = str2double(get(edtPSMASmalestVoiValue, 'String'));

        if dObjectValue < 0

            dObjectValue = 0;

            set(edtPSMASmalestVoiValue, 'String', num2str(dObjectValue));
        end

        FDGSmalestVoiValue('set', dObjectValue);

    end

    function chkPSMAPixelEdgeCallback(hObject, ~)  
                
        bObjectValue = get(chkPSMAPixelEdge, 'Value');
        
        if strcmpi(get(hObject, 'Style'), 'text')
            
            set(chkPSMAPixelEdge, 'Value', ~bObjectValue);
        end        
        
        bObjectValue = get(chkPSMAPixelEdge, 'Value');

        pixelEdge('set', bObjectValue);
        
        % Set contour panel checkbox

        set(chkPixelEdgePtr('get'), 'Value', pixelEdge('get'));
    end


    function cancelMachineLearningPSMACallback(~, ~)   

        delete(dlgMachineLearningPSMA);
    end
    
    function proceedMachineLearningPSMACallback(~, ~)

        % Exclude List

        % Other Organs

        tPSMA.exclude.organ.brain       = get(chkPSMABrain      , 'value');
        tPSMA.exclude.organ.kidneyLeft  = get(chkPSMAKidneyLeft , 'value');
        tPSMA.exclude.organ.kidneyRight = get(chkPSMAKidneyRight, 'value');
        tPSMA.exclude.organ.spleen      = get(chkPSMASpleen     , 'value');

        % Gastrointestinal Tract Name

        tPSMA.exclude.gastrointestinal.smallBowel     = get(chkPSMASmallBowel    , 'value');
        tPSMA.exclude.gastrointestinal.urinaryBladder = get(chkPSMAUrinaryBladder, 'value');

        % Options

        tPSMA.options.smalestVoiValue = str2double(get(edtPSMASmalestVoiValue, 'String'));
        tPSMA.options.pixelEdge       = get(chkPSMAPixelEdge                 , 'value');

        delete(dlgMachineLearningPSMA);

        setMachineLearningPSMA(sSegmentatorScript, tPSMA); 
    end
    
end