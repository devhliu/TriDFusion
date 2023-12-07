function setMachineLearningFDGLymphNodeSUVCallback(~, ~)
%function setMachineLearningFDGLymphNodeSUVCallback()
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
    

    dlgFDGLymphNodeSUVSegmentation  = [];
  
    if ~isempty(sSegmentatorScript) ... % External Segmentor is installed
        
        DLG_FDGLYMPHNODE_PERCENT_X = 380;
        DLG_FDGLYMPHNODE_PERCENT_Y = 440;
    
        dlgFDGLymphNodeSUVSegmentation = ...
            dialog('Position', [(getMainWindowPosition('xpos')+(getMainWindowSize('xsize')/2)-DLG_FDGLYMPHNODE_PERCENT_X/2) ...
                                (getMainWindowPosition('ypos')+(getMainWindowSize('ysize')/2)-DLG_FDGLYMPHNODE_PERCENT_Y/2) ...
                                DLG_FDGLYMPHNODE_PERCENT_X ...
                                DLG_FDGLYMPHNODE_PERCENT_Y ...
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

        uicontrol(dlgFDGLymphNodeSUVSegmentation,...
                  'style'   , 'text',...
                  'FontWeight','bold'  ,...
                  'string'  , 'Exclude organ list',...
                  'horizontalalignment', 'left',...
                  'BackgroundColor', viewerBackgroundColor('get'), ...
                  'ForegroundColor', viewerForegroundColor('get'), ...                   
                  'position', [20 390 300 20]...
                  );

    % Brain

        uicontrol(dlgFDGLymphNodeSUVSegmentation,...
                  'style'   , 'text',...
                  'Enable'  , 'Inactive',...
                  'string'  , 'Brain',...
                  'horizontalalignment', 'left',...
                  'BackgroundColor', viewerBackgroundColor('get'), ...
                  'ForegroundColor', viewerForegroundColor('get'), ...                   
                  'ButtonDownFcn'  , @chkLymphNodeSUVBrainCallback, ...
                  'position', [60 362 150 20]...
                  );

    chkLymphNodeSUVBrain = ...
        uicontrol(dlgFDGLymphNodeSUVSegmentation,...
                  'style'   , 'checkbox',...
                  'enable'  , 'on',...
                  'value'   , excludeLymphNodeSUVBrain('get'),...
                  'position', [40 365 20 20],...
                  'BackgroundColor', viewerBackgroundColor('get'), ...
                  'ForegroundColor', viewerForegroundColor('get'), ...                   
                  'Callback', @chkLymphNodeSUVBrainCallback...
                  );

    % Urinary bladder

        uicontrol(dlgFDGLymphNodeSUVSegmentation,...
                  'style'   , 'text',...
                  'Enable'  , 'Inactive',...
                  'string'  , 'Urinary bladder',...
                  'horizontalalignment', 'left',...
                  'BackgroundColor', viewerBackgroundColor('get'), ...
                  'ForegroundColor', viewerForegroundColor('get'), ...                   
                  'ButtonDownFcn'  , @chkLymphNodeSUVUrinaryBladderCallback, ...
                  'position', [60 337 150 20]...
                  );

    chkLymphNodeSUVUrinaryBladder = ...
        uicontrol(dlgFDGLymphNodeSUVSegmentation,...
                  'style'   , 'checkbox',...
                  'enable'  , 'on',...
                  'value'   , excludeLymphNodeSUVUrinaryBladder('get'),...
                  'position', [40 340 20 20],...
                  'BackgroundColor', viewerBackgroundColor('get'), ...
                  'ForegroundColor', viewerForegroundColor('get'), ...                   
                  'Callback', @chkLymphNodeSUVUrinaryBladderCallback...
                  );
    % Kidney left

        uicontrol(dlgFDGLymphNodeSUVSegmentation,...
                  'style'   , 'text',...
                  'Enable'  , 'Inactive',...
                  'string'  , 'Kidney left',...
                  'horizontalalignment', 'left',...
                  'BackgroundColor', viewerBackgroundColor('get'), ...
                  'ForegroundColor', viewerForegroundColor('get'), ...                   
                  'ButtonDownFcn'  , @chkLymphNodeSUVKidneyLeftCallback, ...
                  'position', [60 312 150 20]...
                  );

    chkLymphNodeSUVKidneyLeft = ...
        uicontrol(dlgFDGLymphNodeSUVSegmentation,...
                  'style'   , 'checkbox',...
                  'enable'  , 'on',...
                  'value'   , excludeLymphNodeSUVKidneyLeft('get'),...
                  'position', [40 315 20 20],...
                  'BackgroundColor', viewerBackgroundColor('get'), ...
                  'ForegroundColor', viewerForegroundColor('get'), ...                   
                  'Callback', @chkLymphNodeSUVKidneyLeftCallback...
                  );

    % Kidney right

        uicontrol(dlgFDGLymphNodeSUVSegmentation,...
                  'style'   , 'text',...
                  'Enable'  , 'Inactive',...
                  'string'  , 'Kidney right',...
                  'horizontalalignment', 'left',...
                  'BackgroundColor', viewerBackgroundColor('get'), ...
                  'ForegroundColor', viewerForegroundColor('get'), ...                   
                  'ButtonDownFcn'  , @chkLymphNodeSUVKidneyRightCallback, ...
                  'position', [60 287 150 20]...
                  );

    chkLymphNodeSUVKidneyRight = ...
        uicontrol(dlgFDGLymphNodeSUVSegmentation,...
                  'style'   , 'checkbox',...
                  'enable'  , 'on',...
                  'value'   , excludeLymphNodeSUVKidneyRight('get'),...
                  'position', [40 290 20 20],...
                  'BackgroundColor', viewerBackgroundColor('get'), ...
                  'ForegroundColor', viewerForegroundColor('get'), ...                   
                  'Callback', @chkLymphNodeSUVKidneyRightCallback...
                  );
    
    % Small bowel

        uicontrol(dlgFDGLymphNodeSUVSegmentation,...
                  'style'   , 'text',...
                  'Enable'  , 'Inactive',...
                  'string'  , 'Small bowel',...
                  'horizontalalignment', 'left',...
                  'BackgroundColor', viewerBackgroundColor('get'), ...
                  'ForegroundColor', viewerForegroundColor('get'), ...                   
                  'ButtonDownFcn'  , @chkLymphNodeSUVSmallBowelCallback, ...
                  'position', [60 262 150 20]...
                  );

    chkLymphNodeSUVSmallBowel = ...
        uicontrol(dlgFDGLymphNodeSUVSegmentation,...
                  'style'   , 'checkbox',...
                  'enable'  , 'on',...
                  'value'   , excludeLymphNodeSUVSmallBowel('get'),...
                  'position', [40 265 20 20],...
                  'BackgroundColor', viewerBackgroundColor('get'), ...
                  'ForegroundColor', viewerForegroundColor('get'), ...                   
                  'Callback', @chkLymphNodeSUVSmallBowelCallback...
                  );

    % Segmentation organ list

        uicontrol(dlgFDGLymphNodeSUVSegmentation,...
                  'style'   , 'text',...
                  'FontWeight','bold'  ,...
                  'string'  , 'Segmentation organ list',...
                  'horizontalalignment', 'left',...
                  'BackgroundColor', viewerBackgroundColor('get'), ...
                  'ForegroundColor', viewerForegroundColor('get'), ...                   
                  'position', [20 215 300 20]...
                  );
    % Spleen

        uicontrol(dlgFDGLymphNodeSUVSegmentation,...
                  'style'   , 'text',...
                  'Enable'  , 'Inactive',...
                  'string'  , 'Spleen',...
                  'horizontalalignment', 'left',...
                  'BackgroundColor', viewerBackgroundColor('get'), ...
                  'ForegroundColor', viewerForegroundColor('get'), ...                   
                  'ButtonDownFcn'  , @chkLymphNodeSUVSpleenCallback, ...
                  'position', [60 187 150 20]...
                  );

    chkLymphNodeSUVSpleen = ...
        uicontrol(dlgFDGLymphNodeSUVSegmentation,...
                  'style'   , 'checkbox',...
                  'enable'  , 'on',...
                  'value'   , segmentLymphNodeSUVSpleen('get'),...
                  'position', [40 190 20 20],...
                  'BackgroundColor', viewerBackgroundColor('get'), ...
                  'ForegroundColor', viewerForegroundColor('get'), ...                   
                  'Callback', @chkLymphNodeSUVSpleenCallback...
                  );

    % Options

        uicontrol(dlgFDGLymphNodeSUVSegmentation,...
                  'style'     , 'text',...
                  'FontWeight','bold'  ,...
                  'string'    , 'Options',...
                  'horizontalalignment', 'left',...
                  'BackgroundColor', viewerBackgroundColor('get'), ...
                  'ForegroundColor', viewerForegroundColor('get'), ...                   
                  'position', [20 140 300 20]...
                  );

        % SUV threshold
    
            uicontrol(dlgFDGLymphNodeSUVSegmentation,...
                      'style'   , 'text',...
                      'Enable'  , 'On',...
                      'string'  , 'SUV Threshold',...
                      'horizontalalignment', 'left',...
                      'BackgroundColor', viewerBackgroundColor('get'), ...
                      'ForegroundColor', viewerForegroundColor('get'), ...                   
                      'position', [20 112 250 20]...
                      );
    
        edtFDGLymphNodeSUVThresholdOfMaxValue = ...
            uicontrol(dlgFDGLymphNodeSUVSegmentation, ...
                      'Style'   , 'Edit', ...
                      'Position', [285 115 75 20], ...
                      'String'  , num2str(FDGSegmentationSUVThresholdValue('get')), ...
                      'Enable'  , 'on', ...
                      'BackgroundColor', viewerBackgroundColor('get'), ...
                      'ForegroundColor', viewerForegroundColor('get'), ...
                      'CallBack', @edtFDGLymphNodeSUVThresholdOfMaxValueCallback ...
                      );     
    
         % Pixel Edge
    
            uicontrol(dlgFDGLymphNodeSUVSegmentation,...
                      'style'   , 'text',...
                      'Enable'  , 'Inactive',...
                      'string'  , 'Pixel Edge',...
                      'horizontalalignment', 'left',...
                      'BackgroundColor', viewerBackgroundColor('get'), ...
                      'ForegroundColor', viewerForegroundColor('get'), ...                   
                      'ButtonDownFcn'  , @chkFDGLymphNodeSUVPixelEdgeCallback, ...
                      'position', [40 87 150 20]...
                      );
    
        chkFDGLymphNodeSUVPixelEdge = ...
            uicontrol(dlgFDGLymphNodeSUVSegmentation,...
                      'style'   , 'checkbox',...
                      'enable'  , 'on',...
                      'value'   , pixelEdge('get'),...
                      'position', [20 90 20 20],...
                      'BackgroundColor', viewerBackgroundColor('get'), ...
                      'ForegroundColor', viewerForegroundColor('get'), ...                   
                      'Callback', @chkFDGLymphNodeSUVPixelEdgeCallback...
                      );
    
        % Smallest Contour (ml)
    
            uicontrol(dlgFDGLymphNodeSUVSegmentation,...
                      'style'   , 'text',...
                      'Enable'  , 'On',...
                      'string'  , 'Smallest Contour (ml)',...
                      'horizontalalignment', 'left',...
                      'BackgroundColor', viewerBackgroundColor('get'), ...
                      'ForegroundColor', viewerForegroundColor('get'), ...                   
                      'position', [20 62 250 20]...
                      );
    
        edtFDGLymphNodeSUVSmalestVoiValue = ...
            uicontrol(dlgFDGLymphNodeSUVSegmentation, ...
                      'Style'   , 'Edit', ...
                      'Position', [285 65 75 20], ...
                      'String'  , num2str(FDGSmalestVoiValue('get')), ...
                      'Enable'  , 'on', ...
                      'BackgroundColor', viewerBackgroundColor('get'), ...
                      'ForegroundColor', viewerForegroundColor('get'), ...
                      'CallBack', @edtFDGLymphNodeSUVSmalestVoiValueCallback ...
                      );  
    
         % Cancel or Proceed
    
         uicontrol(dlgFDGLymphNodeSUVSegmentation,...
                   'String','Cancel',...
                   'Position',[285 7 75 25],...
                   'BackgroundColor', viewerBackgroundColor('get'), ...
                   'ForegroundColor', viewerForegroundColor('get'), ...                
                   'Callback', @cancelFDGLymphNodeSUVSegmentationCallback...
                   );
    
         uicontrol(dlgFDGLymphNodeSUVSegmentation,...
                  'String','Proceed',...
                  'Position',[200 7 75 25],...
                  'BackgroundColor', viewerBackgroundColor('get'), ...
                  'ForegroundColor', viewerForegroundColor('get'), ...               
                  'Callback', @proceedFDGLymphNodeSUVSegmentationCallback...
                  );    
    end

    % Exclude organ list

    % Brain

    function chkLymphNodeSUVBrainCallback(hObject, ~)  
                
        bObjectValue = get(chkLymphNodeSUVBrain, 'Value');
        
        if strcmpi(get(hObject, 'Style'), 'text')
            
            set(chkLymphNodeSUVBrain, 'Value', ~bObjectValue);
        end        
        
        bObjectValue = get(chkLymphNodeSUVBrain, 'Value');

        excludeLymphNodeSUVBrain('set', bObjectValue);

    end

    % Kidney Left

    function chkLymphNodeSUVKidneyLeftCallback(hObject, ~)  
                
        bObjectValue = get(chkLymphNodeSUVKidneyLeft, 'Value');
        
        if strcmpi(get(hObject, 'Style'), 'text')
            
            set(chkLymphNodeSUVKidneyLeft, 'Value', ~bObjectValue);
        end        
        
        bObjectValue = get(chkLymphNodeSUVKidneyLeft, 'Value');

        excludeLymphNodeSUVKidneyLeft('set', bObjectValue);

    end

    % Kidney Right

    function chkLymphNodeSUVKidneyRightCallback(hObject, ~)  
                
        bObjectValue = get(chkLymphNodeSUVKidneyRight, 'Value');
        
        if strcmpi(get(hObject, 'Style'), 'text')
            
            set(chkLymphNodeSUVKidneyRight, 'Value', ~bObjectValue);
        end        
        
        bObjectValue = get(chkLymphNodeSUVKidneyRight, 'Value');

        excludeLymphNodeSUVKidneyRight('set', bObjectValue);

    end

    % Small Bowel

    function chkLymphNodeSUVSmallBowelCallback(hObject, ~)  
                
        bObjectValue = get(chkLymphNodeSUVSmallBowel, 'Value');
        
        if strcmpi(get(hObject, 'Style'), 'text')
            
            set(chkLymphNodeSUVSmallBowel, 'Value', ~bObjectValue);
        end        
        
        bObjectValue = get(chkLymphNodeSUVSmallBowel, 'Value');

        excludeLymphNodeSUVSmallBowel('set', bObjectValue);

    end

    % Segmentation organ list

    % Spleen

    function chkLymphNodeSUVSpleenCallback(hObject, ~)  
                
        bObjectValue = get(chkLymphNodeSUVSpleen, 'Value');
        
        if strcmpi(get(hObject, 'Style'), 'text')
            
            set(chkLymphNodeSUVSpleen, 'Value', ~bObjectValue);
        end        
        
        bObjectValue = get(chkLymphNodeSUVSpleen, 'Value');

        segmentLymphNodeSUVSpleen('set', bObjectValue);

    end

    function edtFDGLymphNodeSUVSmalestVoiValueCallback(~, ~)

        dObjectValue = str2double(get(edtFDGLymphNodeSUVSmalestVoiValue, 'String'));

        if dObjectValue < 0

            dObjectValue = 0;

            set(edtFDGLymphNodeSUVSmalestVoiValue, 'String', num2str(dObjectValue));
        end

        FDGSmalestVoiValue('set', dObjectValue);

    end

    function chkFDGLymphNodeSUVPixelEdgeCallback(hObject, ~)  
                
        bObjectValue = get(chkFDGLymphNodeSUVPixelEdge, 'Value');
        
        if strcmpi(get(hObject, 'Style'), 'text')
            
            set(chkFDGLymphNodeSUVPixelEdge, 'Value', ~bObjectValue);
        end        
        
        bObjectValue = get(chkFDGLymphNodeSUVPixelEdge, 'Value');

        pixelEdge('set', bObjectValue);
        
        % Set contour panel checkbox

        set(chkPixelEdgePtr('get'), 'Value', pixelEdge('get'));
    end

    function edtFDGLymphNodeSUVThresholdOfMaxValueCallback(~, ~)     

        dLymphNodeThreshold = str2double(get(edtFDGLymphNodeSUVThresholdOfMaxValue, 'String'));

        if dLymphNodeThreshold <= 0

            dLymphNodeThreshold = 4;

            set(edtFDGLymphNodeSUVThresholdOfMaxValue, 'String', num2str(dLymphNodeThreshold));
        end

        FDGSegmentationSUVThresholdValue('set', dLymphNodeThreshold);

    end

    function cancelFDGLymphNodeSUVSegmentationCallback(~, ~)   

        delete(dlgFDGLymphNodeSUVSegmentation);
    end
    
    function proceedFDGLymphNodeSUVSegmentationCallback(~, ~)

        % Exclude List

        % Other Organs

        tLymphNodeSUV.exclude.organ.brain       = get(chkLymphNodeSUVBrain      , 'value');
        tLymphNodeSUV.exclude.organ.kidneyLeft  = get(chkLymphNodeSUVKidneyLeft , 'value');
        tLymphNodeSUV.exclude.organ.kidneyRight = get(chkLymphNodeSUVKidneyRight, 'value');

        % Gastrointestinal Tract Name

        tLymphNodeSUV.exclude.gastrointestinal.smallBowel     = get(chkLymphNodeSUVSmallBowel    , 'value');
        tLymphNodeSUV.exclude.gastrointestinal.urinaryBladder = get(chkLymphNodeSUVUrinaryBladder, 'value');

        % Segment List

        tLymphNodeSUV.segment.organ.spleen = get(chkLymphNodeSUVSpleen, 'value');

        % Options

        tLymphNodeSUV.options.smalestVoiValue = str2double(get(edtFDGLymphNodeSUVSmalestVoiValue    , 'String'));
        tLymphNodeSUV.options.pixelEdge       = get(chkFDGLymphNodeSUVPixelEdge                     , 'value');
        tLymphNodeSUV.options.SUVThreshold    = str2double(get(edtFDGLymphNodeSUVThresholdOfMaxValue, 'String'));

        delete(dlgFDGLymphNodeSUVSegmentation);

        setMachineLearningFDGLymphNodeSUV(sSegmentatorScript, tLymphNodeSUV); 
    end
    
end