function voiDefaultMenu(ptrRoi, sTag)
%function voiDefaultMenu(ptrRoi, sTag)
%Add VOI default right click menu.
%See TriDFuison.doc (or pdf) for more information about options.
%
%Author: Daniel Lafontaine, lafontad@mskcc.org
%
%Last specifications modified:
%
% Copyright 2022, Daniel Lafontaine, on behalf of the TriDFusion development team.
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

    if ~exist('sTag', 'var') % Add menu

        mVoiFolder = ...
            uimenu(ptrRoi.UIContextMenu, ...
                   'Label'    , 'Volume-of-interest' , ...
                   'UserData' , ptrRoi, ...
                   'Visible'  , 'off', ...
                   'Separator', 'on' ...
                   );

        uimenu(mVoiFolder, ...
               'Label'    , 'Edit Label' , ...
               'UserData' , ptrRoi, ...
               'Callback' , @editVoiLabelCallback, ...
               'Separator', 'off' ...
               ); 

        aList = getRoiLabelList();               
        mPredefinedLabels = uimenu(mVoiFolder, 'Label', 'Predefined Label');
    
        arrayfun(@(x) uimenu(mPredefinedLabels, ...
                             'Text', aList{x}, ...
                             'UserData', ptrRoi, ...
                             'MenuSelectedFcn', @predefinedVoiLabelCallback), ...
            1:numel(aList));

        [~, asLesionList] = getLesionType('');
        
        if ~isempty(asLesionList)
    
            mEditLocation = uimenu(mVoiFolder, ...
                                   'Label', 'Edit Location', ...
                                   'UserData', ptrRoi      , ...
                                   'Visible'  , 'off'      , ...
                                   'MenuSelectedFcn'       , @refreshVoiMenuLocationCallback);
    
            arrayfun(@(x) uimenu(mEditLocation, ...
                                 'Text', asLesionList{x}, ...
                                 'UserData', ptrRoi, ...
                                 'MenuSelectedFcn', @editVoiLesionTypeCallback), ...
                1:numel(asLesionList));            
    
        end

        uimenu(mVoiFolder, ...
               'Label'   , 'Edit Color', ...
               'UserData', ptrRoi, ...
               'Callback', @editVoiColorCallback ...
               );

       uimenu(mVoiFolder, ...
              'Label', 'Hide/View Face Alpha', ...
              'UserData', ptrRoi, ...
              'Callback', @hideViewVoiFaceAlhaCallback ...
             ); 

        mVoiConstraint = ...
            uimenu(mVoiFolder, ...
                   'Label'    , 'Constraint' , ...
                   'UserData' , ptrRoi, ...
                   'Visible'  , 'off', ...
                   'Callback' , @setMenuConstraintCheckedCallback, ...
                   'Separator', 'on' ... 
                  );

            uimenu(mVoiConstraint, ...
                   'Label'    , 'Inside This Contour' , ...
                   'UserData' , ptrRoi.Tag, ...
                   'Callback' , @constraintContourFromMenuCallback ...
                  );

            uimenu(mVoiConstraint, ...
                   'Label'   , 'Invert Constraint' , ...
                   'Checked' , invertConstraint('get'), ...
                   'Callback', @invertConstraintFromMenuCallback ...
                  );

        mVoiMask = ...
            uimenu(mVoiFolder, ...
                   'Label'    , 'Mask' , ...
                   'UserData' , ptrRoi, ...
                   'Visible'  , 'off', ...
                   'Separator', 'on' ...
                   );

            uimenu(mVoiMask, ...
                   'Label'    , 'Inside This Contour' , ...
                   'UserData' , ptrRoi.Tag, ...
                   'Visible'  , 'off', ...
                   'Callback' , @maskContourFromMenuCallback ...
                  );

            uimenu(mVoiMask, ...
                   'Label'    , 'Outside This Contour' , ...
                   'UserData' , ptrRoi.Tag, ...
                   'Visible'  , 'off', ...
                   'Callback' , @maskContourFromMenuCallback ...
                  );

            uimenu(mVoiFolder, ...
                   'Label'    , 'Adjust increment ratio' , ...
                   'UserData' , ptrRoi.Tag, ...
                   'Separator', 'on', ...
                   'Visible'  , 'off', ...
                   'Callback' , @editIncrementRatioVoiPositionCallback ...
                  );

            uimenu(mVoiFolder, ...
                   'Label'    , 'Increase Contours' , ...
                   'UserData' , ptrRoi, ...
                   'Visible'  , 'off', ...
                   'Callback' , @increaseVoiPositionCallback ...
                   );

            uimenu(mVoiFolder, ...
                   'Label'    , 'Decrease Contours' , ...
                   'UserData' , ptrRoi, ...
                   'Visible'  , 'off', ...
                   'Callback' , @decreaseVoiPositionCallback ...
                   );

    else % Make menu visible (when creating a VOI)

        if ~isstruct(ptrRoi)
            for mc=1:numel(ptrRoi.ContextMenu.Children)
                if strcmpi(ptrRoi.ContextMenu.Children(mc).Label, 'Volume-of-interest')

                    set(ptrRoi.ContextMenu.Children(mc),          'Visible', 'on');   % Activate mVoiFolder
                    set(ptrRoi.ContextMenu.Children(mc).Children, 'Visible', 'on');   % Activate mVoiConstraint & mVoiMaskt

                    set(ptrRoi.ContextMenu.Children(mc),          'UserData', sTag);   % Set VOI tag mVoiFoldert
                    set(ptrRoi.ContextMenu.Children(mc).Children, 'UserData', sTag);   % Set VOI tag mVoiConstraint & mVoiMaskt

                    for cc=1:numel(ptrRoi.ContextMenu.Children(mc).Children) % Set both Mask and Constraint sub menu
                        set(ptrRoi.ContextMenu.Children(mc).Children(cc).Children, 'Visible' , 'on');
                        set(ptrRoi.ContextMenu.Children(mc).Children(cc).Children, 'UserData', sTag);
                    end

                    break;
                end
            end
        end
    end

    function setMenuConstraintCheckedCallback(hObject, ~)

        if isprop(ptrRoi, 'ContextMenu')

            for mcc=1:numel(hObject.Children)

                if strcmpi(hObject.Children(mcc).Label, 'Invert Constraint')

                    if invertConstraint('get') == true

                        set(hObject.Children(mcc), 'Checked', 'on');
                    else
                        set(hObject.Children(mcc), 'Checked', 'off');
                    end
                else
                    sConstraintTag = get(hObject, 'UserData');

                    [asConstraintTagList, asConstraintTypeList] = roiConstraintList('get', get(uiSeriesPtr('get'), 'Value') );

                    if isempty(asConstraintTagList)

                        set(hObject.Children(mcc), 'Checked', 'off');
                    else
                        aTagOffset = strcmp( cellfun( @(asConstraintTagList) asConstraintTagList, asConstraintTagList, 'uni', false ), sConstraintTag);
                        dVoiTagOffset = find(aTagOffset, 1);

                        if ~isempty(dVoiTagOffset) % tag is active

                            if     strcmpi(asConstraintTypeList{dVoiTagOffset}, 'Inside This Contour')
                                set(hObject.Children(mcc), 'Checked', 'on');

                            elseif strcmpi(asConstraintTypeList{dVoiTagOffset}, 'Inside Every Slice')
                                set(hObject.Children(mcc), 'Checked', 'on');

                            else
                                set(hObject.Children(mcc), 'Checked', 'off');
                            end
                        else
                            set(hObject.Children(mcc), 'Checked', 'off');
                        end
                    end
                end
            end
        end
    end

    function editIncrementRatioVoiPositionCallback(~, ~)

    DLG_INCREAMENT_X = 380;
    DLG_INCREAMENT_Y = 100;
    
    dlgIncrement = ...
        dialog('Position', [(getMainWindowPosition('xpos')+(getMainWindowSize('xsize')/2)-DLG_INCREAMENT_X/2) ...
                            (getMainWindowPosition('ypos')+(getMainWindowSize('ysize')/2)-DLG_INCREAMENT_Y/2) ...
                            DLG_INCREAMENT_X ...
                            DLG_INCREAMENT_Y ...
                            ],...
               'MenuBar', 'none',...
               'Resize', 'off', ...    
               'NumberTitle','off',...
               'MenuBar', 'none',...
               'Color', viewerBackgroundColor('get'), ...
               'Name', 'Adjust increment ratio',...
               'Toolbar','none'...               
               );        

    edtIncrementRatio = ...
       uicontrol(dlgIncrement,...
                 'style'     , 'edit',...
                 'enable'    , 'on',...
                 'Background', 'white',...
                 'string'    , num2str(voiIncrementRatio('get')),...
                 'position'  , [200 50 100 20],...
                 'BackgroundColor', viewerBackgroundColor('get'), ...
                 'ForegroundColor', viewerForegroundColor('get'), ...                  
                 'Callback'  , @editIncrementRatioCallback...
                 );
    set(edtIncrementRatio, 'KeyPressFcn', @checkEditRatioKeyPress);

        uicontrol(dlgIncrement,...
                  'style'   , 'text',...
                  'string'  , 'Increment ratio',...
                  'horizontalalignment', 'left',...
                  'position', [20 47 180 20],...
                  'Enable', 'On',...
                  'BackgroundColor', viewerBackgroundColor('get'), ...
                  'ForegroundColor', viewerForegroundColor('get') ...                   
                  ); 

     % Cancel or Proceed

     uicontrol(dlgIncrement,...
               'String','Cancel',...
               'Position',[285 7 75 25],...
               'BackgroundColor', viewerBackgroundColor('get'), ...
               'ForegroundColor', viewerForegroundColor('get'), ...                
               'Callback', @cancelEditIncrementRatioCallback...
               );

     uicontrol(dlgIncrement,...
              'String','Change',...
              'Position',[200 7 75 25],...
              'BackgroundColor', viewerBackgroundColor('get'), ...
              'ForegroundColor', viewerForegroundColor('get'), ...               
              'Callback', @changeEditIncrementRatioCallback...
              );

        function checkEditRatioKeyPress(~, event)
            if strcmp(event.Key, 'return')
                drawnow;
                changeEditIncrementRatioCallback();
            end
        end 

        function editIncrementRatioCallback(~, ~)

            dIncrement = str2double(get(edtIncrementRatio, 'String'));

            if dIncrement < 0
                set(edtIncrementRatio, 'String', '1');
            end
        end

        function changeEditIncrementRatioCallback(~, ~)

            dIncrement = str2double(get(edtIncrementRatio, 'String'));

            if dIncrement < 0

                set(edtIncrementRatio, 'String', '1');
            else
                voiIncrementRatio('set', dIncrement);

                delete(dlgIncrement);
            end
        end

        function cancelEditIncrementRatioCallback(~, ~) 

            delete(dlgIncrement);
        end

    end

    function increaseVoiPositionCallback(hObject, ~)

        increaseVoiPosition(get(hObject, 'UserData'), voiIncrementRatio('get'));

        plotRotatedRoiOnMip(axesMipPtr('get', [], get(uiSeriesPtr('get'), 'Value')), dicomBuffer('get', [], get(uiSeriesPtr('get'), 'Value')), mipAngle('get'))
     
    end

    function decreaseVoiPositionCallback(hObject, ~)

        decreaseVoiPosition(get(hObject, 'UserData'), voiIncrementRatio('get'));

        plotRotatedRoiOnMip(axesMipPtr('get', [], get(uiSeriesPtr('get'), 'Value')), dicomBuffer('get', [], get(uiSeriesPtr('get'), 'Value')), mipAngle('get'))

    end

    function refreshVoiMenuLocationCallback(hObject, ~) 

        atVoiInput = voiTemplate('get', get(uiSeriesPtr('get'), 'Value'));

        dTagOffset = find(strcmp( cellfun( @(atVoiInput) atVoiInput.Tag, atVoiInput, 'uni', false ), hObject.UserData ) );

        if ~isempty(dTagOffset) % Tag is a VOI

            for ch=1:numel(hObject.Children)
    
                if strcmpi(hObject.Children(ch).Text, atVoiInput{dTagOffset}.LesionType)
                    
                    set(hObject.Children(ch), 'Checked', 'on');
                else

                    set(hObject.Children(ch), 'Checked', 'off');
                end
            end

        end
    end
end
