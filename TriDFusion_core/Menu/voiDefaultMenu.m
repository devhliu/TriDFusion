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

        % Create the main Volume-of-interest menu
        mVoiFolder = uimenu(ptrRoi.UIContextMenu, ...
            'Label', 'Volume-of-interest', ...
            'UserData', ptrRoi, ...
            'Visible', 'off', ...
            'Separator', 'on');

        % Add Edit Label menu item
        uimenu(mVoiFolder, ...
            'Label', 'Edit Label', ...
            'UserData', ptrRoi, ...
            'Callback', @editVoiLabelCallback);

        % Get predefined labels
        aList = getRoiLabelList();

        mPredefinedLabels = uimenu(mVoiFolder, 'Label', 'Predefined Label');

        numLabels = numel(aList);  % Get the number of labels

        for i = 1:numLabels
            uimenu(mPredefinedLabels, ...
                'Text'           , aList{i}, ...
                'UserData'       , ptrRoi, ...
                'MenuSelectedFcn', @predefinedVoiLabelCallback);
        end

        % Get lesion types

        [~, asLesionList] = getLesionType('');

        if ~isempty(asLesionList)
            % Create Edit Location submenu
            mEditLocation = uimenu(mVoiFolder, ...
                'Label', 'Edit Location', ...
                'UserData', ptrRoi, ...
                'Visible', 'off', ...
                'MenuSelectedFcn', @refreshVoiMenuLocationCallback);

            numLesionTypes = numel(asLesionList);  % Get the number of lesion types

            for i = 1:numLesionTypes
                uimenu(mEditLocation, ...
                    'Text', asLesionList{i}, ...
                    'UserData', ptrRoi, ...
                    'MenuSelectedFcn', @editVoiLesionTypeCallback);
            end
        end

        % Add other menu items
        uimenu(mVoiFolder, ...
            'Label', 'Edit Color', ...
            'UserData', ptrRoi, ...
            'Callback', @editVoiColorCallback);
        
        uimenu(mVoiFolder, ...
            'Label', 'Hide/View Face Alpha', ...
            'UserData', ptrRoi, ...
            'Callback', @hideViewVoiFaceAlhaCallback);
        
        % Create the Constraint submenu
        mVoiConstraint = uimenu(mVoiFolder, ...
            'Label', 'Constraint', ...
            'UserData', ptrRoi, ...
            'Visible', 'off', ...
            'Callback', @setMenuConstraintCheckedCallback, ...
            'Separator', 'on');

        uimenu(mVoiConstraint, ...
            'Label', 'Inside This Contour', ...
            'UserData', ptrRoi.Tag, ...
            'Callback', @constraintContourFromMenuCallback);
        
        uimenu(mVoiConstraint, ...
            'Label', 'Invert Constraint', ...
            'Checked', invertConstraint('get'), ...
            'Callback', @invertConstraintFromMenuCallback);

        % Create Mask submenu
        mVoiMask = uimenu(mVoiFolder, ...
            'Label', 'Mask', ...
            'UserData', ptrRoi, ...
            'Visible', 'off', ...
            'Separator', 'on');

        % Create Mask options
        uimenu(mVoiMask, ...
            'Label', 'Inside This Contour', ...
            'UserData', ptrRoi.Tag, ...
            'Visible', 'off', ...
            'Callback', @maskContourFromMenuCallback);

        uimenu(mVoiMask, ...
            'Label', 'Outside This Contour', ...
            'UserData', ptrRoi.Tag, ...
            'Visible', 'off', ...
            'Callback', @maskContourFromMenuCallback);

        % Additional menu items
        uimenu(mVoiFolder, ...
            'Label', 'Adjust increment ratio', ...
            'UserData', ptrRoi.Tag, ...
            'Separator', 'on', ...
            'Visible', 'off', ...
            'Callback', @editIncrementRatioVoiPositionCallback);

        uimenu(mVoiFolder, ...
            'Label', 'Increase Contours', ...
            'UserData', ptrRoi, ...
            'Visible', 'off', ...
            'Callback', @increaseVoiPositionCallback);

        uimenu(mVoiFolder, ...
            'Label', 'Decrease Contours', ...
            'UserData', ptrRoi, ...
            'Visible', 'off', ...
            'Callback', @decreaseVoiPositionCallback);

    else % Make menu visible (when creating a VOI)
        if ~isstruct(ptrRoi)

            % Find the Volume-of-interest folder
            mVoiFolderIndex = find(strcmpi({ptrRoi.ContextMenu.Children.Label}, 'Volume-of-interest'), 1);

            if ~isempty(mVoiFolderIndex)
                % Activate mVoiFolder
                set(ptrRoi.ContextMenu.Children(mVoiFolderIndex), 'Visible', 'on'); 

                % Get children of the mVoiFolder
                children = ptrRoi.ContextMenu.Children(mVoiFolderIndex).Children; 

                % Activate mVoiConstraint & mVoiMask
                set(children, 'Visible', 'on', 'UserData', sTag); 
            
                % Set both Mask and Constraint submenus
                for childIdx = 1:numel(children)

                    set(children(childIdx).Children, 'Visible', 'on', 'UserData', sTag);
                end
            end
        end
    end

    function setMenuConstraintCheckedCallback(hObject, ~)

        if isprop(ptrRoi, 'ContextMenu')
            % Check/uncheck the Invert Constraint option
            invertChecked = invertConstraint('get');
            invertItem = hObject.Children(strcmpi({hObject.Children.Label}, 'Invert Constraint'));
            set(invertItem, 'Checked', invertChecked);

            % Check/uncheck other constraints
            sConstraintTag = get(hObject, 'UserData');
            [asConstraintTagList, asConstraintTypeList] = roiConstraintList('get', get(uiSeriesPtr('get'), 'Value'));

            % Check if constraints exist
            if isempty(asConstraintTagList)
                set(hObject.Children, 'Checked', 'off');
            else
                activeIndex = strcmp(asConstraintTagList, sConstraintTag);
                if any(activeIndex)
                    checkedType = asConstraintTypeList{activeIndex};
                    set(hObject.Children(strcmpi({hObject.Children.Label}, checkedType)), 'Checked', 'on');
                else
                    set(hObject.Children, 'Checked', 'off');
                end
            end
        end
    end

    function editIncrementRatioVoiPositionCallback(~, ~)

        DLG_INCREAMENT_X = 380;
        DLG_INCREAMENT_Y = 100;

        % Create dialog for increment ratio
        dlgIncrement = dialog('Position', [(getMainWindowPosition('xpos')+(getMainWindowSize('xsize')/2)-DLG_INCREAMENT_X/2) ...
            (getMainWindowPosition('ypos')+(getMainWindowSize('ysize')/2)-DLG_INCREAMENT_Y/2) ...
            DLG_INCREAMENT_X DLG_INCREAMENT_Y], ...
            'MenuBar', 'none', ...
            'Resize', 'off', ...
            'NumberTitle', 'off', ...
            'Color', viewerBackgroundColor('get'), ...
            'Name', 'Adjust increment ratio', ...
            'Toolbar', 'none');

        % Create increment ratio input
        edtIncrementRatio = uicontrol(dlgIncrement, ...
            'style', 'edit', ...
            'Background', 'white', ...
            'string', num2str(voiIncrementRatio('get')), ...
            'position', [200 50 100 20], ...
            'BackgroundColor', viewerBackgroundColor('get'), ...
            'ForegroundColor', viewerForegroundColor('get'), ...
            'Callback', @editIncrementRatioCallback, ...
            'KeyPressFcn', @checkEditRatioKeyPress);

        % Create label for increment ratio
        uicontrol(dlgIncrement, ...
            'style', 'text', ...
            'string', 'Increment ratio', ...
            'horizontalalignment', 'left', ...
            'position', [20 47 180 20], ...
            'Enable', 'On', ...
            'BackgroundColor', viewerBackgroundColor('get'), ...
            'ForegroundColor', viewerForegroundColor('get'));

        % Cancel and Change buttons
        uicontrol(dlgIncrement, ...
            'String', 'Cancel', ...
            'Position', [285 7 75 25], ...
            'BackgroundColor', viewerBackgroundColor('get'), ...
            'ForegroundColor', viewerForegroundColor('get'), ...
            'Callback', @cancelEditIncrementRatioCallback);

        uicontrol(dlgIncrement, ...
            'String', 'Change', ...
            'Position', [200 7 75 25], ...
            'BackgroundColor', viewerBackgroundColor('get'), ...
            'ForegroundColor', viewerForegroundColor('get'), ...
            'Callback', @changeEditIncrementRatioCallback);

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

            if dIncrement >= 0
                voiIncrementRatio('set', dIncrement);
                delete(dlgIncrement);
            else
                set(edtIncrementRatio, 'String', '1');
            end
        end

        function cancelEditIncrementRatioCallback(~, ~) 

            delete(dlgIncrement);
        end
    end

    function increaseVoiPositionCallback(hObject, ~)

        increaseVoiPosition(get(hObject, 'UserData'), voiIncrementRatio('get'));
        plotRotatedRoiOnMip(axesMipPtr('get', [], get(uiSeriesPtr('get'), 'Value')), dicomBuffer('get', [], get(uiSeriesPtr('get'), 'Value')), mipAngle('get'));
    end

    function decreaseVoiPositionCallback(hObject, ~)

        decreaseVoiPosition(get(hObject, 'UserData'), voiIncrementRatio('get'));
        plotRotatedRoiOnMip(axesMipPtr('get', [], get(uiSeriesPtr('get'), 'Value')), dicomBuffer('get', [], get(uiSeriesPtr('get'), 'Value')), mipAngle('get'));
    end

    function refreshVoiMenuLocationCallback(hObject, ~) 

        atVoiInput = voiTemplate('get', get(uiSeriesPtr('get'), 'Value'));
        
        dTagOffset = find(strcmp( cellfun( @(atVoiInput) atVoiInput.Tag, atVoiInput, 'uni', false ), hObject.UserData ), 1 );

        if ~isempty(dTagOffset) % Tag is a VOI

            set(hObject.Children, 'Checked', 'off'); % Reset all
            set(hObject.Children(strcmpi({hObject.Children.Text}, atVoiInput{dTagOffset}.LesionType)), 'Checked', 'on'); % Set checked for active type
        end
    end
end
