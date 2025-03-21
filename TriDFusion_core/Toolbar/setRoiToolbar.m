function setRoiToolbar(sVisible)
%function setRoiToolbar(sVisible)
%Init and View ON/OFF ROIs Toolbar.
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

    atRoiMenu = roiMenuObject('get');

    if isempty(atRoiMenu)

        sRootPath  = viewerRootPath('get');
        sIconsPath = sprintf('%s/icons/', sRootPath);

    %    f = figure('ToolBar','none');
        atRoiMenu = uitoolbar(fiMainWindowPtr('get'));

%        jToolbar = atRoiMenu.JavaContainer.getComponentPeer;
%        jToolbar.setBackground();

        roiMenuObject('set', atRoiMenu);

        mViewRoi = viewRoiObject('get');

        if strcmp(sVisible, 'off')
            mViewRoi.Checked = 'off';
            atRoiMenu.Visible = 'off';
            roiToolbar('set', false);
       else
            mViewRoi.Checked = 'on';
            atRoiMenu.Visible = 'on';
            roiToolbar('set', true);
        end

        % Draw line

        [img,~] = imread(sprintf('%s//line.png', sIconsPath));
        img = double(img)/255;

        t8 = uitoggletool(atRoiMenu,'CData',img,'TooltipString','<html>Line Measurement (M)<br>Draw a line by clicking and dragging; measurement appears, and right-click to view the profile</html>');
        t8.ClickedCallback = @drawlineCallback;

        % Draw freehand

        [img,~] = imread(sprintf('%s//freehand.png', sIconsPath));
        img = rescaleAndRemoveIconBackground(img);

    %    icon = ind2rgb(img,map);

        t = uitoggletool(atRoiMenu,'CData',img,'TooltipString','<html>Draw Freehand (D)<br>Draw a freeform shape by clicking and dragging; release to finish</html>');
        t.ClickedCallback = @drawfreehandCallback;

%            img = zeros(16,16,3);
  %      [img,~] = imread(sprintf('%s//assisted.png', sIconsPath));
  %      img = double(img)/255;

  %      t7 = uitoggletool(atRoiMenu,'CData',img,'TooltipString','Draw Assisted');
  %      t7.ClickedCallback = @drawassistedCallback;

        % Draw polygon

        [img,~] = imread(sprintf('%s//polygon.png', sIconsPath));
        img = rescaleAndRemoveIconBackground(img);

        t6 = uitoggletool(atRoiMenu,'CData',img,'TooltipString','<html>Draw Polygon (P)<br>Draw a polygon by clicking to set each vertex; double-click to complete</html>');
        t6.ClickedCallback = @drawpolygonCallback;

        % Draw circle

        [img,~] = imread(sprintf('%s//circle.png', sIconsPath));
        img = rescaleAndRemoveIconBackground(img);

        t2 = uitoggletool(atRoiMenu,'CData',img,'TooltipString','Draw Circle');
        t2.ClickedCallback = @drawcircleCallback;

        % Draw elipse

        [img,~] = imread(sprintf('%s//elipse.png', sIconsPath));
        img = rescaleAndRemoveIconBackground(img);

        t5 = uitoggletool(atRoiMenu,'CData',img,'TooltipString','Draw Elipse');
        t5.ClickedCallback = @drawellipseCallback;

        % Draw rectangle

        [img,~] = imread(sprintf('%s//rectangle.png', sIconsPath));
        img = rescaleAndRemoveIconBackground(img);

        t3 = uitoggletool(atRoiMenu,'CData',img,'TooltipString','Draw Rectangle');
        t3.ClickedCallback = @drawrectangleCallback;

        % Click Sphere

        [img,~] = imread(sprintf('%s//sphere.png', sIconsPath));
        img = rescaleAndRemoveIconBackground(img);

        t11 = uitoggletool(atRoiMenu,'CData',img,'TooltipString','<html>Draw Sphere (E)<br>Click on the image to create a sphere. Modify its diameter from the View/Contour Panel</html>', 'Separator', 'on');
        t11.ClickedCallback = @drawsphereCallback;

        % Click VOI

        [img,~] = imread(sprintf('%s//voi-click.png', sIconsPath));
        img = rescaleAndRemoveIconBackground(img);

        t12 = uitoggletool(atRoiMenu,'CData',img,'TooltipString','<html>Click-VOI (V)<br>Create a VOI by clicking on the image. Adjust it relative to the maximum value in the View/Contour Panel</html>');
        t12.ClickedCallback = @drawClickVoiCallback;

        % Continuous

        [img,~] = imread(sprintf('%s//continuous.png', sIconsPath));
        img = rescaleAndRemoveIconBackground(img);

        tContinuous = uitoggletool(atRoiMenu,'CData',img,'TooltipString','Continuous', 'Separator', 'on');
        tContinuous.ClickedCallback = @setContinuousCallback;

        % Interpolate

        [img,~] = imread(sprintf('%s//interpolate.png', sIconsPath));
        img = rescaleAndRemoveIconBackground(img);

        tInterpolate = uitoggletool(atRoiMenu,'CData',img,'TooltipString','<html>Interpolate (X)<br>Generate VOI by interpolating between ROIs</html>');
        tInterpolate.ClickedCallback = @setInterpolateCallback;

        % Farthest distances

        [img,~] = imread(sprintf('%s//farthest.png', sIconsPath));
        img = rescaleAndRemoveIconBackground(img);

        tFarthest = uitoggletool(atRoiMenu,'CData',img,'TooltipString','View Farthest Distances');
        tFarthest.ClickedCallback = @viewFarthestDistancesCallback;

        % Brush

        [img,~] = imread(sprintf('%s//brush.png', sIconsPath));
        img = rescaleAndRemoveIconBackground(img);

        t2Dbrush = uitoggletool(atRoiMenu,'CData',img,'TooltipString','<html>2D Brush (B)<br>Click on the image to activate the brush. Hold Ctrl and scroll to adjust brush diameter</html>');
        t2Dbrush.ClickedCallback = @set2DBrushCallback;

        % Scissor

        [img,~] = imread(sprintf('%s//knife.png', sIconsPath));
        img = rescaleAndRemoveIconBackground(img);

        t2Dscissor = uitoggletool(atRoiMenu,'CData',img,'TooltipString','<html>Knife (K)<br>Split the contour into two objects by drawing a line across it</html>');
        t2Dscissor.ClickedCallback = @set2DScissorCallback;

        % Result

        [img,~] = imread(sprintf('%s//result.png', sIconsPath));
        img = rescaleAndRemoveIconBackground(img);

        t10 = uitoggletool(atRoiMenu,'CData',img,'TooltipString','Display Statistics', 'Tag', 'toolbar', 'Separator', 'on');
        t10.ClickedCallback = @figRoiDialogCallback;


%         [img,~] = imread(sprintf('%s//cuboid.png', sIconsPath));
%         img = double(img)/255;

%         t4 = uitoggletool(atRoiMenu,'CData',img,'TooltipString','Draw Cuboid', 'Separator', 'on');
%         t4.ClickedCallback = @drawcuboidCallback;
    else
        mViewRoi = viewRoiObject('get');

        if strcmp(sVisible, 'off')
            mViewRoi.Checked = 'off';
            atRoiMenu.Visible = 'off';
            roiToolbar('set', false);
        else
            mViewRoi.Checked = 'on';
            atRoiMenu.Visible = 'on';
            roiToolbar('set', true);
       end
    end

    function img = rescaleAndRemoveIconBackground(img)

        whiteThresh = 0.95; % You can adjust this threshold

        img = double(img)/255;

        backgroundMask = img(:,:,1) > whiteThresh & img(:,:,2) > whiteThresh & img(:,:,3) > whiteThresh;
        img(repmat(backgroundMask, [1 1 3])) = NaN;
    end

    function releaseRoiAxeWait(tMenu)

        axeClicked('set', true);
        uiresume(fiMainWindowPtr('get'));

        set(t  , 'State', 'off');
        set(t2 , 'State', 'off');
        set(t3 , 'State', 'off');
  %      set(t4, 'State', 'off');
        set(t5 , 'State', 'off');
        set(t6 , 'State', 'off');
      %  set(t7, 'State', 'off');
        set(t8 , 'State', 'off');
        set(t11, 'State', 'off');
        set(t12, 'State', 'off');

        set(tMenu, 'State', 'on');

    end

    function drawlineCallback(~,~)

        if switchTo3DMode('get')     == true || ...
           switchToIsoSurface('get') == true || ...
           switchToMIPMode('get')    == true || ...
           isVsplash('get')          == true
            set(t8, 'State', 'off');
            return;
        end

        dSeriesOffset = get(uiSeriesPtr('get'), 'Value');

%               releaseRoiAxeWait(t8);
    % robotReleaseKey();
        % axeClicked('set', true);
        % uiresume(fiMainWindowPtr('get'));

        if strcmpi(get(t8, 'State'), 'off')

 %           robotReleaseKey();

            set(t8, 'State', 'off');
            % roiSetAxeBorder(false);

            windowButton('set', 'up');
            mouseFcn('set');
            mainToolBarEnable('on');
            setCrossVisibility(true);

            return;
        end

        releaseRoiAxeWait(t8);

%         robotReleaseKey();

        setCrossVisibility(false);

        % triangulateCallback();

        doWhileContinuous = true;
        while doWhileContinuous == true

            if contourVisibilityRoiPanelValue('get') == false

                contourVisibilityRoiPanelValue('set', true);
                set(chkContourVisibilityPanelObject('get'), 'Value', true);

                % refreshImages();

                if size(dicomBuffer('get', [], dSeriesOffset), 3) ~= 1

                    plotRotatedRoiOnMip(axesMipPtr('get', [], dSeriesOffset), dicomBuffer('get', [], dSeriesOffset), mipAngle('get'));
                end
            end

     %       w=waitforbuttonpress;
            axeClicked('set', false);
            doWhile = true;
            while doWhile == true
                uiwait(fiMainWindowPtr('get'));
                if axeClicked('get') == true
                    doWhile = false;
                    if strcmpi(windowButton('get'), 'up')
                        doWhileContinuous = false;
                    end
        %            axeClicked('set', false);
                end
            end

            if ~isvalid(t8)
                return;
            end

            if strcmpi(get(t8, 'State'), 'off')
                return;
            end
     %       if w == 0
            if  strcmpi(windowButton('get'), 'down')

                robotClick();

                pAxe = getAxeFromMousePosition(dSeriesOffset);

                switch pAxe

                    case axePtr('get', [], dSeriesOffset)
                    case axes1Ptr('get', [], dSeriesOffset)
                    case axes2Ptr('get', [], dSeriesOffset)
                    case axes3Ptr('get', [], dSeriesOffset)

                    otherwise
                        return;
                end

                mainToolBarEnable('off');
                mouseFcn('reset');

                % roiSetAxeBorder(true, pAxe);

         %       while strcmpi(get(t8, 'State'), 'on')

                    a = drawline(pAxe, 'Color', 'cyan', 'lineWidth', 1, 'Tag', num2str(randi([-(2^52/2),(2^52/2)],1)), 'LabelVisible', 'on');
                    a.LabelVisible = 'on';
                    if ~isvalid(t8)
                        return;
                    end

                    if strcmpi(get(t8, 'State'), 'off')
                        % roiSetAxeBorder(false);

                   %     windowButton('set', 'up');
                   %     mouseFcn('set');
                   %     mainToolBarEnable('on');
                   %     setCrossVisibility(1);

                        return;
                    end

                    dLength = computeRoiLineLength(a);
                    a.Label = [num2str(dLength) ' mm'];

                    addRoi(a, dSeriesOffset, 'Unspecified');

%                    setVoiRoiSegPopup();

                    uimenu(a.UIContextMenu, 'Label', 'Copy Contour' , 'UserData', a, 'Callback', @copyRoiCallback, 'Separator', 'on');
                    uimenu(a.UIContextMenu, 'Label', 'Paste Contour', 'UserData', a, 'Callback', @pasteRoiCallback);
                    uimenu(a.UIContextMenu, 'Label', 'Paste Mirror', 'UserData', a, 'Callback', @pasteMirroirRoiCallback);

                    uimenu(a.UIContextMenu,'Label', 'Snap To Circles'   , 'UserData',a, 'Callback',@snapLinesToCirclesCallback, 'Separator', 'on');
                    uimenu(a.UIContextMenu,'Label', 'Snap To Rectangles', 'UserData',a, 'Callback',@snapLinesToRectanglesCallback);

                    uimenu(a.UIContextMenu,'Label', 'Edit Label' , 'UserData',a, 'Callback',@editLabelCallback, 'Separator', 'on');

                    uimenu(a.UIContextMenu,'Label', 'Hide/View Label', 'UserData',a, 'Callback',@hideViewLabelCallback);
                    uimenu(a.UIContextMenu,'Label', 'Edit Color'     , 'UserData',a, 'Callback',@editColorCallback);

                    constraintMenu(a);

                    cropMenu(a);

                    uimenu(a.UIContextMenu,'Label', 'Display Statistics' , 'UserData',a, 'Callback',@figRoiDialogCallback, 'Separator', 'on');

%                    set(fiMainWindowPtr('get'), 'WindowScrollWheelFcn' , @wheelScroll);
                    % refreshImages();

                    if size(dicomBuffer('get', [], dSeriesOffset), 3) ~= 1

                        plotRotatedRoiOnMip(axesMipPtr('get', [], dSeriesOffset), dicomBuffer('get', [], dSeriesOffset), mipAngle('get'));
                    end

                    if strcmpi(get(tContinuous, 'State'), 'off')
                        doWhileContinuous = false;
                    end

         %       end

                % roiSetAxeBorder(false);

                windowButton('set', 'up');
                mouseFcn('set');
                mainToolBarEnable('on');
            end
        end

        set(t8, 'State', 'off');

        setCrossVisibility(true);

    end
%test hf=[];
%test he=[];
    function drawfreehandCallback(~, ~)

        if switchTo3DMode('get')     == true || ...
           switchToIsoSurface('get') == true || ...
           switchToMIPMode('get')    == true || ...
           isVsplash('get')          == true
            set(t, 'State', 'off');
            return;
        end

        dSeriesOffset = get(uiSeriesPtr('get'), 'Value');

        % releaseRoiAxeWait(t);

        % robotReleaseKey();
        % axeClicked('set', true);
        % uiresume(fiMainWindowPtr('get'));

        if strcmpi(get(t, 'State'), 'off')
%                   robotReleaseKey();

            set(t, 'State', 'off');
            % roiSetAxeBorder(false);

            windowButton('set', 'up');
            mouseFcn('set');
            mainToolBarEnable('on');
            setCrossVisibility(true);

            return;
        end

        releaseRoiAxeWait(t);

%
%               robotReleaseKey();

        setCrossVisibility(false);

        % triangulateCallback();

        doWhileContinuous = true;
        while doWhileContinuous == true

            if contourVisibilityRoiPanelValue('get') == false

                contourVisibilityRoiPanelValue('set', true);
                set(chkContourVisibilityPanelObject('get'), 'Value', true);

                % refreshImages();

                if size(dicomBuffer('get', [], dSeriesOffset), 3) ~= 1

                    plotRotatedRoiOnMip(axesMipPtr('get', [], dSeriesOffset), dicomBuffer('get', [], dSeriesOffset), mipAngle('get'));
                end
            end

     %       w=waitforbuttonpress;

            axeClicked('set', false);

            % if bGetAxeFromMousePosition == true

                doWhile = true;
            % else
            %     doWhile = false;
            % end

            while doWhile == true
                uiwait(fiMainWindowPtr('get'));
                if axeClicked('get') == true
                    doWhile = false;
                    if strcmpi(windowButton('get'), 'up')
                        doWhileContinuous = false;
                    end
                end
            end

            if ~isvalid(t)
                return;
            end

            if strcmpi(get(t, 'State'), 'off')
                return;
            end

%import java.awt.event.*;
%mouse = Robot;
%mouse.mouseRelease(InputEvent.BUTTON3_MASK);
% mouse.mousePress(InputEvent.BUTTON3_MASK);

     %       if w == 0
            if  strcmpi(windowButton('get'), 'down')
               
                robotClick();

    %                 gca = getAxeFromMousePosition(get(uiSeriesPtr('get'), 'Value'));
                pAxe = getAxeFromMousePosition(dSeriesOffset);

                switch pAxe

                    case axePtr('get', [], dSeriesOffset)
                    case axes1Ptr('get', [], dSeriesOffset)
                    case axes2Ptr('get', [], dSeriesOffset)
                    case axes3Ptr('get', [], dSeriesOffset)

                    otherwise
                        return;
                end

                mainToolBarEnable('off');
                mouseFcn('reset');

                % roiSetAxeBorder(true, pAxe);

   %              while strcmpi(get(t, 'State'), 'on')

                a = drawfreehand(pAxe, ...
                                'Smoothing'     , 1, ...
                                'Color'         , 'cyan', ...
                                'LineWidth'     , 1, ...
                                'Label'         , roiLabelName(), ...
                                'LabelVisible'  , 'off', ...
                                'Tag'           , num2str(randi([-(2^52/2),(2^52/2)],1)), ...
                                'FaceSelectable', 0, ...
                                'FaceAlpha'     , 0 ...
                                );

                if numel(a.Position) >2

                    a.FaceAlpha = roiFaceAlphaValue('get');

                    a.Waypoints(:) = false;
    %test hf=a;
                    if ~isvalid(t)

                        return;
                    end

                    if strcmpi(get(t, 'State'), 'off')

                        % roiSetAxeBorder(false);

                 %       windowButton('set', 'up');
                 %       mouseFcn('set');
                 %       mainToolBarEnable('on');
                 %       setCrossVisibility(1);

                        return;
                    end

                    addRoi(a, dSeriesOffset, 'Unspecified');

                    addRoiMenu(a);
                    
                    % addlistener(a, 'WaypointAdded'  , @waypointEvents);
                    % addlistener(a, 'WaypointRemoved', @waypointEvents);


% %                     voiDefaultMenu(a);
% % 
% % %                    setVoiRoiSegPopup();
% % 
% %                     roiDefaultMenu(a);
% % 
% %                     uimenu(a.UIContextMenu,'Label', 'Hide/View Face Alpha', 'UserData',a, 'Callback', @hideViewFaceAlhaCallback);
% %                     uimenu(a.UIContextMenu,'Label', 'Clear Waypoints' , 'UserData',a, 'Callback', @clearWaypointsCallback);
% % 
% %                     constraintMenu(a);
% % 
% %                     cropMenu(a);
% % 
% %                     uimenu(a.UIContextMenu,'Label', 'Display Statistics' , 'UserData',a, 'Callback',@figRoiDialogCallback, 'Separator', 'on');

%                    set(fiMainWindowPtr('get'), 'WindowScrollWheelFcn' , @wheelScroll);
     %               refreshImages();

                    if size(dicomBuffer('get', [], dSeriesOffset), 3) ~= 1

                        plotRotatedRoiOnMip(axesMipPtr('get', [], dSeriesOffset), dicomBuffer('get', [], dSeriesOffset), mipAngle('get'));
                    end

                    if strcmpi(get(tContinuous, 'State'), 'off')

                        doWhileContinuous = false;
                    end

                    if strcmpi(get(tInterpolate, 'State'), 'on')

                        interpolateROIsByTag(a.Tag, lastRoiTag());                       
                    end
             %   end
                else
                    delete(a);
                end

                % roiSetAxeBorder(false);

                windowButton('set', 'up');
                mouseFcn('set');
                mainToolBarEnable('on');

            end
        end

        set(t, 'State', 'off');

        setCrossVisibility(true);

    end

    function drawcircleCallback(~,~)

        if switchTo3DMode('get')     == true || ...
           switchToIsoSurface('get') == true || ...
           switchToMIPMode('get')    == true || ...
           isVsplash('get')          == true
            set(t2, 'State', 'off');
            return;
        end

        dSeriesOffset = get(uiSeriesPtr('get'), 'Value');

%               releaseRoiAxeWait(t2);
        % robotReleaseKey();
        % axeClicked('set', true);
        % uiresume(fiMainWindowPtr('get'));

        if strcmpi(get(t2, 'State'), 'off')
%                    robotReleaseKey();

            set(t2, 'State', 'off');
            % roiSetAxeBorder(false);

            windowButton('set', 'up');
            mouseFcn('set');
            mainToolBarEnable('on');
            setCrossVisibility(true);

            return;
        end

        releaseRoiAxeWait(t2);

%               robotReleaseKey();

        setCrossVisibility(false);

        % triangulateCallback();

        doWhileContinuous = true;
        while doWhileContinuous == true

            if contourVisibilityRoiPanelValue('get') == false

                contourVisibilityRoiPanelValue('set', true);
                set(chkContourVisibilityPanelObject('get'), 'Value', true);

                % refreshImages();

                if size(dicomBuffer('get', [], dSeriesOffset), 3) ~= 1

                    plotRotatedRoiOnMip(axesMipPtr('get', [], dSeriesOffset), dicomBuffer('get', [], dSeriesOffset), mipAngle('get'));
                end
            end

   %         w = waitforbuttonpress;
            axeClicked('set', false);

            doWhile = true;
            while doWhile == true
                uiwait(fiMainWindowPtr('get'));
                if axeClicked('get') == true
                    doWhile = false;
                    if strcmpi(windowButton('get'), 'up')
                        doWhileContinuous = false;
                    end
                end
            end

            if ~isvalid(t2)
                return;
            end

            if strcmpi(get(t2, 'State'), 'off')
                return;
            end

    %        if w == 0
            if  strcmpi(windowButton('get'), 'down')

                robotClick();

                pAxe = getAxeFromMousePosition(dSeriesOffset);

                switch pAxe

                    case axePtr('get', [], dSeriesOffset)
                    case axes1Ptr('get', [], dSeriesOffset)
                    case axes2Ptr('get', [], dSeriesOffset)
                    case axes3Ptr('get', [], dSeriesOffset)

                    otherwise
                        return;
                end

                mainToolBarEnable('off');
                mouseFcn('reset');

                % roiSetAxeBorder(true, pAxe);

          %      while strcmpi(get(t2, 'State'), 'on')

                % hListener = addlistener(fiMainWindowPtr('get'), 'WaitStatus', 'PostSet', @(src, event) checkWaitStatus(src));

                a = drawcircle(pAxe, ...
                               'Color'         , 'cyan', ...
                               'lineWidth'     , 1, ...
                               'Label'         , roiLabelName(), ...
                               'LabelVisible'  , 'off', ...
                               'Tag'           , num2str(randi([-(2^52/2),(2^52/2)],1)), ...
                               'FaceSelectable', 1, ...
                               'FaceAlpha'     , 0 ...
                               );

                % if numel(a.Position) >2

                    a.FaceAlpha = roiFaceAlphaValue('get');

                    % delete(hListener);

                    if ~isvalid(t2)
                        return;
                    end

                    if strcmpi(get(t2, 'State'), 'off')
                        % roiSetAxeBorder(false);

    %                            windowButton('set', 'up');
    %                            mouseFcn('set');
    %                            mainToolBarEnable('on');
    %                            setCrossVisibility(1);

                        return;
                    end

    %test he=a;
    %test addlistener(he,'MovingROI', @(varargin)editorROIMoving(he, hf));
    %test addlistener(he,'ROIMoved', @(varargin)editFreehand(hf, he));

                    addRoi(a, dSeriesOffset, 'Unspecified');

                    addRoiMenu(a);

    %                    setVoiRoiSegPopup();
                    % voiDefaultMenu(a);
                    % 
                    % roiDefaultMenu(a);
                    % 
                    % uimenu(a.UIContextMenu,'Label', 'Hide/View Face Alpha', 'UserData',a, 'Callback', @hideViewFaceAlhaCallback);
                    % 
                    % constraintMenu(a);
                    % 
                    % cropMenu(a);
                    % 
                    % uimenu(a.UIContextMenu,'Label', 'Display Statistics' , 'UserData',a, 'Callback',@figRoiDialogCallback, 'Separator', 'on');

    %                    set(fiMainWindowPtr('get'), 'WindowScrollWheelFcn' , @wheelScroll);
                    % refreshImages();

                    if size(dicomBuffer('get', [], dSeriesOffset), 3) ~= 1

                        plotRotatedRoiOnMip(axesMipPtr('get', [], dSeriesOffset), dicomBuffer('get', [], dSeriesOffset), mipAngle('get'));
                    end

                    if strcmpi(get(tContinuous, 'State'), 'off')
                        doWhileContinuous = false;
                    end

                    if strcmpi(get(tInterpolate, 'State'), 'on')

                        interpolateROIsByTag(a.Tag, lastRoiTag());                       
                    end

            %    end
                % else
                %     delete(a);
                % end

                % roiSetAxeBorder(false);

                windowButton('set', 'up');
                mouseFcn('set');
                mainToolBarEnable('on');
            end
        end

        set(t2, 'State', 'off');

        setCrossVisibility(true);
    end

%            function drawcuboidCallback(~,~)
%
%                setCrossVisibility(0);

%                w = waitforbuttonpress;

%                if w == 0
%                    mainToolBarEnable('off');
%                    mouseFcn('reset');

%                    roiSetAxeBorder(1);

%                    a = drawcuboid(gca, 'Color', 'cyan', 'lineWidth', 1);
%                    set(t4, 'State', 'off');

%                    uimenu(a.UIContextMenu,'Label', 'Crop Inside' , 'UserData',a, 'Callback',@cropInsideCallback, 'Separator', 'on');
%                    uimenu(a.UIContextMenu,'Label', 'Crop Outside', 'UserData',a, 'Callback',@cropOutsideCallback);
%                    uimenu(a.UIContextMenu,'Label', 'Crop Inside all slices'    , 'UserData',a, 'Callback',@cropInsideAllSlicesCallback, 'Separator', 'on');
%                    uimenu(a.UIContextMenu,'Label', 'Crop Outside all slices'   , 'UserData',a, 'Callback',@cropOutsideAllSlicesCallback);

%                    roiSetAxeBorder(0);

%                    windowButton('set', 'up');
%                    mouseFcn('set');
%                    mainToolBarEnable('on');
%                end

%                setCrossVisibility(1);

%            end


    function drawellipseCallback(~,~)

        if switchTo3DMode('get')     == true || ...
           switchToIsoSurface('get') == true || ...
           switchToMIPMode('get')    == true || ...
           isVsplash('get')          == true
            set(t5, 'State', 'off');
            return;
        end

        dSeriesOffset = get(uiSeriesPtr('get'), 'Value');

%             releaseRoiAxeWait(t5);
        % robotReleaseKey();
        % axeClicked('set', true);
        % uiresume(fiMainWindowPtr('get'));

        if strcmpi(get(t5, 'State'), 'off')
%                    robotReleaseKey();

            set(t5, 'State', 'off');
            % roiSetAxeBorder(false);

            windowButton('set', 'up');
            mouseFcn('set');
            mainToolBarEnable('on');
            setCrossVisibility(true);

            return;
        end

        releaseRoiAxeWait(t5);

%              robotReleaseKey();

        setCrossVisibility(false);

        % triangulateCallback();

        doWhileContinuous = true;
        while doWhileContinuous == true

            if contourVisibilityRoiPanelValue('get') == false

                contourVisibilityRoiPanelValue('set', true);
                set(chkContourVisibilityPanelObject('get'), 'Value', true);

                % refreshImages();

                if size(dicomBuffer('get', [], dSeriesOffset), 3) ~= 1

                    plotRotatedRoiOnMip(axesMipPtr('get', [], dSeriesOffset), dicomBuffer('get', [], dSeriesOffset), mipAngle('get'));
                end
            end

            axeClicked('set', false);

            doWhile = true;
            while doWhile == true
                uiwait(fiMainWindowPtr('get'));
                if axeClicked('get') == true
                    doWhile = false;
                    if strcmpi(windowButton('get'), 'up')
                        doWhileContinuous = false;
                    end
                end
            end

            if ~isvalid(t5)
                return;
            end

            if strcmpi(get(t5, 'State'), 'off')
                return;
            end

%                w = waitforbuttonpress;

%                if w == 0
            if  strcmpi(windowButton('get'), 'down')

                robotClick();

                pAxe = getAxeFromMousePosition(dSeriesOffset);

                switch pAxe

                    case axePtr('get', [], dSeriesOffset)
                    case axes1Ptr('get', [], dSeriesOffset)
                    case axes2Ptr('get', [], dSeriesOffset)
                    case axes3Ptr('get', [], dSeriesOffset)

                    otherwise
                        return;
                end

                mainToolBarEnable('off');
                mouseFcn('reset');

                % roiSetAxeBorder(true, pAxe);

         %       while strcmpi(get(t5, 'State'), 'on')

                    a = drawellipse(pAxe, ...
                                    'Color'         , 'cyan', ...
                                    'lineWidth'     , 1, ...
                                    'Label'         , roiLabelName(), ...
                                    'LabelVisible'  , 'off', ...
                                    'Tag'           , num2str(randi([-(2^52/2),(2^52/2)],1)), ...
                                    'FaceSelectable', 1, ...
                                    'FaceAlpha'     , 0 ...
                                    );
                    a.FaceAlpha = roiFaceAlphaValue('get');

                    if ~isvalid(t5)
                        return;
                    end
                    if strcmpi(get(t5, 'State'), 'off')
                        % roiSetAxeBorder(false);

%                            windowButton('set', 'up');
%                            mouseFcn('set');
%                            mainToolBarEnable('on');
%                            setCrossVisibility(1);

                        return;
                    end

                    addRoi(a, dSeriesOffset, 'Unspecified');

                    addRoiMenu(a);

%                    setVoiRoiSegPopup();
                    % voiDefaultMenu(a);
                    % 
                    % roiDefaultMenu(a);
                    % 
                    % uimenu(a.UIContextMenu,'Label', 'Hide/View Face Alpha', 'UserData',a, 'Callback', @hideViewFaceAlhaCallback);
                    % 
                    % constraintMenu(a);
                    % 
                    % cropMenu(a);
                    % 
                    % uimenu(a.UIContextMenu,'Label', 'Display Statistics' , 'UserData',a, 'Callback',@figRoiDialogCallback, 'Separator', 'on');

%                    set(fiMainWindowPtr('get'), 'WindowScrollWheelFcn' , @wheelScroll  );
                    % refreshImages();

                    if size(dicomBuffer('get', [], dSeriesOffset), 3) ~= 1

                        plotRotatedRoiOnMip(axesMipPtr('get', [], dSeriesOffset), dicomBuffer('get', [], dSeriesOffset), mipAngle('get'));
                    end

                    if strcmpi(get(tContinuous, 'State'), 'off')

                        doWhileContinuous = false;
                    end

                    if strcmpi(get(tInterpolate, 'State'), 'on')

                        interpolateROIsByTag(a.Tag, lastRoiTag());                       
                    end                    
            %    end

                % roiSetAxeBorder(false);

                windowButton('set', 'up');
                mouseFcn('set');
                mainToolBarEnable('on');
            end
        end

        set(t5, 'State', 'off');

        setCrossVisibility(true);
    end

    function drawrectangleCallback(~,~)

        if switchTo3DMode('get')     == true || ...
           switchToIsoSurface('get') == true || ...
           switchToMIPMode('get')    == true || ...
           isVsplash('get')          == true
            set(t3, 'State', 'off');
            return;
        end

        dSeriesOffset = get(uiSeriesPtr('get'), 'Value');

%             releaseRoiAxeWait(t3);
        % robotReleaseKey();
        % axeClicked('set', true);
        % uiresume(fiMainWindowPtr('get'));

        if strcmpi(get(t3, 'State'), 'off')
%                    robotReleaseKey();

            set(t3, 'State', 'off');
            % roiSetAxeBorder(false);

            windowButton('set', 'up');
            mouseFcn('set');
            mainToolBarEnable('on');
            setCrossVisibility(true);

            return;
        end

        releaseRoiAxeWait(t3);

%          robotReleaseKey();

        setCrossVisibility(false);

        % triangulateCallback();

        doWhileContinuous = true;
        while doWhileContinuous == true

            if contourVisibilityRoiPanelValue('get') == false

                contourVisibilityRoiPanelValue('set', true);
                set(chkContourVisibilityPanelObject('get'), 'Value', true);

                % refreshImages();

                if size(dicomBuffer('get', [], dSeriesOffset), 3) ~= 1

                    plotRotatedRoiOnMip(axesMipPtr('get', [], dSeriesOffset), dicomBuffer('get', [], dSeriesOffset), mipAngle('get'));
                end
            end

            axeClicked('set', false);

            doWhile = true;
            while doWhile == true
                uiwait(fiMainWindowPtr('get'));
                if axeClicked('get') == true
                    doWhile = false;
                    if strcmpi(windowButton('get'), 'up')
                        doWhileContinuous = false;
                    end
                end
            end

            if ~isvalid(t3)
                return;
            end

            if strcmpi(get(t3, 'State'), 'off')
                return;
            end

    %        w = waitforbuttonpress;

    %        if w == 0
            if  strcmpi(windowButton('get'), 'down')

                robotClick();

                pAxe = getAxeFromMousePosition(dSeriesOffset);

                switch pAxe

                    case axePtr('get', [], dSeriesOffset)
                    case axes1Ptr('get', [], dSeriesOffset)
                    case axes2Ptr('get', [], dSeriesOffset)
                    case axes3Ptr('get', [], dSeriesOffset)

                    otherwise
                        return;
                end

                mainToolBarEnable('off');
                mouseFcn('reset');

                % roiSetAxeBorder(true, pAxe);

            %    while strcmpi(get(t3, 'State'), 'on')

                a = drawrectangle(pAxe, ...
                                  'Rotatable'     , false, ...
                                  'Color'         , 'cyan', ...
                                  'lineWidth'     , 1, ...
                                  'Label'         , roiLabelName(), ...
                                  'LabelVisible'  , 'off', ...
                                  'Tag'           , num2str(randi([-(2^52/2),(2^52/2)],1)), ...
                                  'FaceSelectable', 1, ...
                                  'FaceAlpha'     , 0 ...
                                  );
                a.FaceAlpha = roiFaceAlphaValue('get');

                if ~isvalid(t3)
                    return;
                end

                if strcmpi(get(t3, 'State'), 'off')
                    % roiSetAxeBorder(false);

%                            windowButton('set', 'up');
%                            mouseFcn('set');
%                            mainToolBarEnable('on');
%                            setCrossVisibility(1);

                    return;
                end

                addRoi(a, dSeriesOffset, 'Unspecified');

                addRoiMenu(a);

%                    setVoiRoiSegPopup();
                % voiDefaultMenu(a);
                % 
                % roiDefaultMenu(a);
                % 
                % uimenu(a.UIContextMenu,'Label', 'Hide/View Face Alpha', 'UserData',a, 'Callback', @hideViewFaceAlhaCallback);
                % 
                % constraintMenu(a);
                % 
                % cropMenu(a);
                % 
                % uimenu(a.UIContextMenu,'Label', 'Display Statistics' , 'UserData',a, 'Callback',@figRoiDialogCallback, 'Separator', 'on');

%                    set(fiMainWindowPtr('get'), 'WindowScrollWheelFcn' , @wheelScroll);
                % refreshImages();

                if size(dicomBuffer('get', [], dSeriesOffset), 3) ~= 1

                    plotRotatedRoiOnMip(axesMipPtr('get', [], dSeriesOffset), dicomBuffer('get', [], dSeriesOffset), mipAngle('get'));
                end

                if strcmpi(get(tContinuous, 'State'), 'off')

                    doWhileContinuous = false;
                end

                if strcmpi(get(tInterpolate, 'State'), 'on')

                    interpolateROIsByTag(a.Tag, lastRoiTag());                       
                end                
          %      end

                % roiSetAxeBorder(false);

                windowButton('set', 'up');
                mouseFcn('set');
                mainToolBarEnable('on');
            end
        end

        set(t3, 'State', 'off');

        setCrossVisibility(true);
    end

    function drawpolygonCallback(~, ~)

        if switchTo3DMode('get')     == true || ...
           switchToIsoSurface('get') == true || ...
           switchToMIPMode('get')    == true || ...
           isVsplash('get')          == true
            
            set(t6, 'State', 'off');
            return;
        end

        dSeriesOffset = get(uiSeriesPtr('get'), 'Value');

        % robotReleaseKey();
        % axeClicked('set', true);
        % uiresume(fiMainWindowPtr('get'));

        if strcmpi(get(t6, 'State'), 'off')
  %          robotReleaseKey();

            set(t6, 'State', 'off');
            % roiSetAxeBorder(false);

            windowButton('set', 'up');
            mouseFcn('set');
            mainToolBarEnable('on');
            setCrossVisibility(1);

            return;
        end

        releaseRoiAxeWait(t6);

%             robotReleaseKey();

        setCrossVisibility(false);

        % triangulateCallback();

        doWhileContinuous = true;
        while doWhileContinuous == true

            if contourVisibilityRoiPanelValue('get') == false

                contourVisibilityRoiPanelValue('set', true);
                set(chkContourVisibilityPanelObject('get'), 'Value', true);

                % refreshImages();

                if size(dicomBuffer('get', [], dSeriesOffset), 3) ~= 1

                    plotRotatedRoiOnMip(axesMipPtr('get', [], dSeriesOffset), dicomBuffer('get', [], dSeriesOffset), mipAngle('get'));
                end
            end

            axeClicked('set', false);

            doWhile = true;
            while doWhile == true
                uiwait(fiMainWindowPtr('get'));
                if axeClicked('get') == true
                    doWhile = false;
                    if strcmpi(windowButton('get'), 'up')
                        doWhileContinuous = false;
                    end
                end
            end

            if ~isvalid(t6)
                return;
            end

            if strcmpi(get(t6, 'State'), 'off')
                return;
            end

%               w = waitforbuttonpress;

%            if w == 0
            if  strcmpi(windowButton('get'), 'down')

                robotClick();
%                 gca = getAxeFromMousePosition(get(uiSeriesPtr('get'), 'Value'));

                pAxe = getAxeFromMousePosition(dSeriesOffset);

                switch pAxe

                    case axePtr('get', [], dSeriesOffset)
                    case axes1Ptr('get', [], dSeriesOffset)
                    case axes2Ptr('get', [], dSeriesOffset)
                    case axes3Ptr('get', [], dSeriesOffset)

                    otherwise
                        return;
                end

                mainToolBarEnable('off');
                mouseFcn('reset');

                % roiSetAxeBorder(true, pAxe);

            %    while strcmpi(get(t6, 'State'), 'on')

                a = drawpolygon(pAxe, ...
                                'Color'         , 'cyan', ...
                                'lineWidth'     , 1, ...
                                'Label'         , roiLabelName(), ...
                                'LabelVisible'  , 'off', ...
                                'Tag'           , num2str(randi([-(2^52/2),(2^52/2)],1)), ...
                                'FaceSelectable', 0, ...
                                'FaceAlpha'     , 0 ...
                                );

                if numel(a.Position) >2

                    a.FaceAlpha = roiFaceAlphaValue('get');

                    if ~isvalid(t6)
                        return;
                    end

                    if strcmpi(get(t6, 'State'), 'off')
                        % roiSetAxeBorder(false);

    %                            windowButton('set', 'up');
    %                            mouseFcn('set');
    %                            mainToolBarEnable('on');
    %                            setCrossVisibility(1);

                        return;
                    end

                    addRoi(a, dSeriesOffset, 'Unspecified');

                    addRoiMenu(a);

    %                    setVoiRoiSegPopup();
                    % voiDefaultMenu(a);
                    % 
                    % roiDefaultMenu(a);
                    % 
                    % uimenu(a.UIContextMenu,'Label', 'Hide/View Face Alpha', 'UserData',a, 'Callback', @hideViewFaceAlhaCallback);
                    % 
                    % constraintMenu(a);
                    % 
                    % cropMenu(a);
                    % 
                    % 
                    % uimenu(a.UIContextMenu,'Label', 'Display Statistics' , 'UserData',a, 'Callback',@figRoiDialogCallback, 'Separator', 'on');

    %                    set(fiMainWindowPtr('get'), 'WindowScrollWheelFcn' , @wheelScroll);
                    % refreshImages();

                    if size(dicomBuffer('get', [], dSeriesOffset), 3) ~= 1

                        plotRotatedRoiOnMip(axesMipPtr('get', [], dSeriesOffset), dicomBuffer('get', [], dSeriesOffset), mipAngle('get'));
                    end

                    if strcmpi(get(tContinuous, 'State'), 'off')

                        doWhileContinuous = false;
                    end

                    if strcmpi(get(tInterpolate, 'State'), 'on')

                        interpolateROIsByTag(a.Tag, lastRoiTag());                       
                    end

                 %   end
                else
                    delete(a);
                end

                % roiSetAxeBorder(false);

                windowButton('set', 'up');
                mouseFcn('set');
                mainToolBarEnable('on');
            end
        end

        set(t6, 'State', 'off');

        setCrossVisibility(true);

    end

    function drawsphereCallback(~, ~)

        if switchTo3DMode('get')     == true || ...
           switchToIsoSurface('get') == true || ...
           switchToMIPMode('get')    == true || ...
           isVsplash('get')          == true
            set(t11, 'State', 'off');
            return;
        end

        dSeriesOffset = get(uiSeriesPtr('get'), 'Value');

        % robotReleaseKey();
        % axeClicked('set', true);
        % uiresume(fiMainWindowPtr('get'));

        if strcmpi(get(t11, 'State'), 'off')
  %          robotReleaseKey();
            if ~isempty(voiTemplate('get', get(uiSeriesPtr('get'), 'Value')))
                set(uiLesionTypeVoiRoiPanelObject('get'), 'Enable', 'on');
                set(uiDeleteVoiRoiPanelObject    ('get'), 'Enable', 'on');
                set(uiAddVoiRoiPanelObject       ('get'), 'Enable', 'on');
                set(uiPrevVoiRoiPanelObject      ('get'), 'Enable', 'on');
                set(uiDelVoiRoiPanelObject       ('get'), 'Enable', 'on');
                set(uiNextVoiRoiPanelObject      ('get'), 'Enable', 'on');
            end

            set(fiMainWindowPtr('get'), 'Pointer', 'default');
            drawnow;

            set(t11, 'State', 'off');
            % roiSetAxeBorder(false);

            windowButton('set', 'up');
            mouseFcn('set');
            mainToolBarEnable('on');
            setCrossVisibility(true);

            return;
        end

        releaseRoiAxeWait(t11);

%             robotReleaseKey();

        setCrossVisibility(false);

        % triangulateCallback();

        try

        set(uiLesionTypeVoiRoiPanelObject('get'), 'Enable', 'off');
        set(uiDeleteVoiRoiPanelObject    ('get'), 'Enable', 'off');
        set(uiAddVoiRoiPanelObject       ('get'), 'Enable', 'off');
        set(uiPrevVoiRoiPanelObject      ('get'), 'Enable', 'off');
        set(uiDelVoiRoiPanelObject       ('get'), 'Enable', 'off');
        set(uiNextVoiRoiPanelObject      ('get'), 'Enable', 'off');

        set(fiMainWindowPtr('get'), 'Pointer', 'cross');
        drawnow;

        doWhileContinuous = true;
        while doWhileContinuous == true

            if contourVisibilityRoiPanelValue('get') == false

                contourVisibilityRoiPanelValue('set', true);
                set(chkContourVisibilityPanelObject('get'), 'Value', true);

                refreshImages();

                if size(dicomBuffer('get', [], dSeriesOffset), 3) ~= 1

                    plotRotatedRoiOnMip(axesMipPtr('get', [], dSeriesOffset), dicomBuffer('get', [], dSeriesOffset), mipAngle('get'));
                end
            end

            axeClicked('set', false);

            uiwait(fiMainWindowPtr('get'));

            if ~isvalid(t11)
                return;
            end

            if strcmpi(get(t11, 'State'), 'off')
                return;
            end


     %       doWhileContinuous = true;
     %       while doWhileContinuous == true
    %               w = waitforbuttonpress;

    %            if w == 0
            if  strcmpi(windowButton('get'), 'down')

        %        robotClick();
                set(fiMainWindowPtr('get'), 'Pointer', 'watch');
                drawnow;

                pAxe = getAxeFromMousePosition(dSeriesOffset);

                switch pAxe

                    case axePtr('get', [], dSeriesOffset)
                    case axes1Ptr('get', [], dSeriesOffset)
                    case axes2Ptr('get', [], dSeriesOffset)
                    case axes3Ptr('get', [], dSeriesOffset)

                    otherwise
                        return;
                end

                mainToolBarEnable('off');
                mouseFcn('reset');

                % roiSetAxeBorder(true, pAxe);

            %    while strcmpi(get(t11, 'State'), 'on')

                clickedPt = get(pAxe,'CurrentPoint');

                clickedPtX = clickedPt(1,1);
                clickedPtY = clickedPt(1,2);

                atMetaData = dicomMetaData('get');
                dSliceThickness = computeSliceSpacing(atMetaData);

                aDicomBuffer = dicomBuffer('get', [], dSeriesOffset);

                switch(pAxe)

                    case axes1Ptr('get', [], dSeriesOffset) % Coronal
                        xPixel = atMetaData{1}.PixelSpacing(2);
                        yPixel = dSliceThickness;
                        zPixel = atMetaData{1}.PixelSpacing(1);

                        dBufferSize = size(aDicomBuffer, 1);

                    case axes2Ptr('get', [], dSeriesOffset) % Sagittal
                        xPixel = atMetaData{1}.PixelSpacing(1);
                        yPixel = dSliceThickness;
                        zPixel = atMetaData{1}.PixelSpacing(2);

                        dBufferSize = size(aDicomBuffer, 2);

                    otherwise % Axial
                        xPixel = atMetaData{1}.PixelSpacing(1);
                        yPixel = atMetaData{1}.PixelSpacing(2);
                        zPixel = dSliceThickness;

                        dBufferSize = size(aDicomBuffer, 3);
                end

                dSphereDiameter = sphereDefaultDiameter('get'); % in mm

                if xPixel == 0
                    xPixel = 1;
                end

                if yPixel == 0
                    yPixel = 1;
                end

                if dSphereDiameter > 0
                    dSemiAxesX = dSphereDiameter/xPixel/2; % In pixel
                    dSemiAxesY = dSphereDiameter/yPixel/2; % In pixel
                else
                    dSemiAxesX = xPixel/2;
                    dSemiAxesY = yPixel/2;
                end

                asTag = cell(dBufferSize, 1);

                sTag = num2str(randi([-(2^52/2),(2^52/2)],1));

                a = images.roi.Ellipse(pAxe, ...
                                       'Center'          , [clickedPtX clickedPtY], ...
                                       'SemiAxes'        , [dSemiAxesX dSemiAxesY], ...
                                       'RotationAngle'   , 0, ...
                                       'Deletable'       , 0, ...
                                       'FixedAspectRatio', 1, ...
                                       'StripeColor'     , 'k', ...
                                       'Color'           , 'cyan', ...
                                       'lineWidth'       , 1, ...
                                       'Label'           , roiLabelName(), ...
                                       'LabelVisible'    , 'off', ...
                                       'Tag'             , sTag, ...
                                       'FaceSelectable'  , 1, ...
                                       'FaceAlpha'       , 0, ...
                                       'UserData'        , 'Sphere', ...
                                       'Visible'         , 'on' ...
                                       );
                 a.FaceAlpha = roiFaceAlphaValue('get');

                 asTag{1} = sTag;

                if ~isvalid(t11)
                    return;
                end

                if strcmpi(get(t11, 'State'), 'off')

                    % roiSetAxeBorder(false);

    %                            windowButton('set', 'up');
    %                            mouseFcn('set');
    %                            mainToolBarEnable('on');
    %                            setCrossVisibility(1);

                    return;
                end

                addRoi(a, dSeriesOffset, 'Unspecified');

                addRoiMenu(a);

    %                    setVoiRoiSegPopup();


                % voiDefaultMenu(a);
                % 
                % roiDefaultMenu(a);
                % 
                % uimenu(a.UIContextMenu,'Label', 'Hide/View Face Alpha', 'UserData',a, 'Callback', @hideViewFaceAlhaCallback);
                % 
                % constraintMenu(a);
                % 
                % cropMenu(a);
                % 
                % uimenu(a.UIContextMenu,'Label', 'Display Statistics' , 'UserData',a, 'Callback',@figRoiDialogCallback, 'Separator', 'on');

    %                    set(fiMainWindowPtr('get'), 'WindowScrollWheelFcn' , @wheelScroll);
                refreshImages();
             %   end

                % roiSetAxeBorder(false);

                windowButton('set', 'up');
                mouseFcn('set');
                mainToolBarEnable('on');

                dRadius = dSphereDiameter/xPixel/2; % In pixel

                switch pAxe

                    % Coronal axe

                    case axes1Ptr('get', [], dSeriesOffset)

                        sPlane = 'coronal';

                        dSliceNb = sliceNumber('get', 'coronal' );

                        xPixelOffset = clickedPtX;
                        yPixelOffset = dSliceNb;
                        zPixelOffset = clickedPtY;

                        dPixelRatio = xPixel/yPixel;


                    % Sagittal axe

                    case axes2Ptr('get', [], dSeriesOffset)

                        sPlane = 'sagittal';

                        dSliceNb = sliceNumber('get', 'sagittal');

                        xPixelOffset = dSliceNb;
                        yPixelOffset = clickedPtX;
                        zPixelOffset = clickedPtY;

                        dPixelRatio = xPixel/yPixel;

                     % Axial axe

                    otherwise
                        sPlane = 'axial';

                        dSliceNb = sliceNumber('get', 'axial');

                        xPixelOffset = clickedPtX;
                        yPixelOffset = clickedPtY;
                        zPixelOffset = dSliceNb;

                        dPixelRatio = xPixel/yPixel;
                end

                aSphereMask = getSphereMask(aDicomBuffer, xPixelOffset, yPixelOffset, zPixelOffset, dRadius, xPixel, yPixel, zPixel);

                for zz=1:dBufferSize

                    if zz==dSliceNb
                        continue;
                    end

                    switch sPlane

                        case 'coronal' % Coronal axe
                            aSlice = permute(aSphereMask(zz,:,:), [3 2 1]);

                        case 'sagittal' % Sagittal axe
                            aSlice = permute(aSphereMask(:,zz,:), [3 1 2]);

                        otherwise % Axial axe
                            aSlice = aSphereMask(:,:,zz);
                    end

                    if any(aSlice(:) == 1)

                        isRoiValid = false;

                        boundaries = bwboundaries(aSlice, 8, 'noholes');
                        if ~isempty(boundaries)
                            isRoiValid = true;
                            thisBoundary = boundaries{1};

                            x = thisBoundary(:, 2); % x = columns.
                            y = thisBoundary(:, 1); % y = rows.
                        end

                        if isRoiValid == true

                            % Find which two boundary points are farthest from each other.
                            maxDistance = -inf;
                            for k = 1 : length(x)
                                distances = sqrt( (x(k) - x) .^ 2 + (y(k) - y) .^ 2 );
                                [thisMaxDistance, ~] = max(distances);
                                if thisMaxDistance > maxDistance
                                    maxDistance = thisMaxDistance;
                                end
                            end
                        end

                        dSemiAxesX = maxDistance/2;
                        dSemiAxesY = maxDistance/2*dPixelRatio;

                        sliceNumber('set', sPlane, zz);

                        sTag = num2str(randi([-(2^52/2),(2^52/2)],1));

                        a = images.roi.Ellipse(pAxe, ...
                                               'Center'             , [clickedPtX clickedPtY], ...
                                               'SemiAxes'           , [dSemiAxesX dSemiAxesY], ...
                                               'RotationAngle'      , 0, ...
                                               'Deletable'          , 0, ...
                                               'FixedAspectRatio'   , 1, ...
                                               'InteractionsAllowed', 'none', ...
                                               'StripeColor'        , 'k', ...
                                               'Color'              , 'cyan', ...
                                               'lineWidth'          , 1, ...
                                               'Label'              , roiLabelName(), ...
                                               'LabelVisible'       , 'off', ...
                                               'Tag'                , sTag, ...
                                               'FaceSelectable'     , 1, ...
                                               'FaceAlpha'          , 0, ...
                                               'Visible'            , 'off', ...
                                               'UserData'           , 'SphereROI' ...
                                               );
                        a.FaceAlpha = roiFaceAlphaValue('get');

                        addRoi(a, dSeriesOffset, 'Unspecified');

                        asTag{zz+1} = sTag;

                    end
                end

                asTag = asTag(~cellfun(@isempty, asTag));

                if size(aDicomBuffer, 3) ~= 1
                    createVoiFromRois(dSeriesOffset, asTag, sprintf('Sphere %d mm', dSphereDiameter), [0 1 1], 'Unspecified');
    
                    setVoiRoiSegPopup();

                    uiDeleteVoiRoiPanel = uiDeleteVoiRoiPanelObject('get');
                    uiLesionTypeVoiRoiPanel = uiLesionTypeVoiRoiPanelObject('get');
    
                    if ~isempty(uiDeleteVoiRoiPanel) && ...
                       ~isempty(uiLesionTypeVoiRoiPanel)
    
                        atVoiInput = voiTemplate('get', dSeriesOffset);
                        dVoiOffset = numel(atVoiInput);
    
                        set(uiDeleteVoiRoiPanel, 'Value', dVoiOffset);
    
                        sLesionType = atVoiInput{dVoiOffset}.LesionType;
                        [bLesionOffset, ~, ~] = getLesionType(sLesionType);
                        set(uiLesionTypeVoiRoiPanel, 'Value', bLesionOffset);
                    end

                    plotRotatedRoiOnMip(axesMipPtr('get', [], dSeriesOffset), dicomBuffer('get', [], dSeriesOffset), mipAngle('get'));
                end

                clear aDicomBuffer;

                sliceNumber('set', sPlane, dSliceNb);

                if strcmpi(get(tContinuous, 'State'), 'off')
                    doWhileContinuous = false;
                end

                set(fiMainWindowPtr('get'), 'Pointer', 'cross');
                drawnow;
            end

        end

        catch
            progressBar(1, 'Error:drawsphereCallback()');
        end

        if ~isempty(voiTemplate('get', dSeriesOffset))

            set(uiLesionTypeVoiRoiPanelObject('get'), 'Enable', 'on');
            set(uiDeleteVoiRoiPanelObject    ('get'), 'Enable', 'on');
            set(uiAddVoiRoiPanelObject       ('get'), 'Enable', 'on');
            set(uiPrevVoiRoiPanelObject      ('get'), 'Enable', 'on');
            set(uiDelVoiRoiPanelObject       ('get'), 'Enable', 'on');
            set(uiNextVoiRoiPanelObject      ('get'), 'Enable', 'on');
        end

        set(t11, 'State', 'off');

        setCrossVisibility(true);

        set(fiMainWindowPtr('get'), 'Pointer', 'default');
        drawnow;
    end

    function drawClickVoiCallback(~, ~)

        if switchTo3DMode('get')     == true || ...
           switchToIsoSurface('get') == true || ...
           switchToMIPMode('get')    == true || ...
           isVsplash('get')          == true
            set(t12, 'State', 'off');
            return;
        end

        dSeriesOffset = get(uiSeriesPtr('get'), 'Value');

        % if isa(actionData, 'matlab.graphics.axis.Axes')
        % 
        %     bGetAxeFromMousePosition = false;
        % else
        %     bGetAxeFromMousePosition = true;
        % end

%               releaseRoiAxeWait(t);
        % robotReleaseKey();
        % axeClicked('set', true);
        % uiresume(fiMainWindowPtr('get'));

        if strcmpi(get(t12, 'State'), 'off')
%                   robotReleaseKey();
%             if ~isempty(voiTemplate('get', get(uiSeriesPtr('get'), 'Value')))
%                 set(uiLesionTypeVoiRoiPanelObject('get'), 'Enable', 'on');
%                 set(uiDeleteVoiRoiPanelObject    ('get'), 'Enable', 'on');
%                 set(uiAddVoiRoiPanelObject       ('get'), 'Enable', 'on');
%                 set(uiPrevVoiRoiPanelObject      ('get'), 'Enable', 'on');
%                 set(uiDelVoiRoiPanelObject       ('get'), 'Enable', 'on');
%                 set(uiNextVoiRoiPanelObject      ('get'), 'Enable', 'on');
%             end

            set(fiMainWindowPtr('get'), 'Pointer', 'default');
            drawnow;

            set(t12, 'State', 'off');
            % roiSetAxeBorder(false);

            windowButton('set', 'up');
            mouseFcn('set');
            mainToolBarEnable('on');
            setCrossVisibility(true);

            return;
        end

        releaseRoiAxeWait(t12);

%               robotReleaseKey();

        setCrossVisibility(false);

        % triangulateCallback();

        try

%         set(uiLesionTypeVoiRoiPanelObject('get'), 'Enable', 'off');
%         set(uiDeleteVoiRoiPanelObject    ('get'), 'Enable', 'off');
%         set(uiAddVoiRoiPanelObject       ('get'), 'Enable', 'off');
%         set(uiPrevVoiRoiPanelObject      ('get'), 'Enable', 'off');
%         set(uiDelVoiRoiPanelObject       ('get'), 'Enable', 'off');
%         set(uiNextVoiRoiPanelObject      ('get'), 'Enable', 'off');

        set(fiMainWindowPtr('get'), 'Pointer', 'cross');
        drawnow;

        doWhileContinuous = true;
        while doWhileContinuous == true

            if contourVisibilityRoiPanelValue('get') == false

                contourVisibilityRoiPanelValue('set', true);
                set(chkContourVisibilityPanelObject('get'), 'Value', true);

                refreshImages();

                if size(dicomBuffer('get', [], dSeriesOffset), 3) ~= 1

                    plotRotatedRoiOnMip(axesMipPtr('get', [], dSeriesOffset), dicomBuffer('get', [], dSeriesOffset), mipAngle('get'));
                end
            end


     %       w=waitforbuttonpress;
            axeClicked('set', false);

            % if bGetAxeFromMousePosition == true
            % 
                 doWhile = true;
            % else
            %     doWhile = false;
            % end

            while doWhile == true
                uiwait(fiMainWindowPtr('get'));
                if axeClicked('get') == true
                    doWhile = false;
                    if strcmpi(windowButton('get'), 'up')
                        doWhileContinuous = false;
                    end
                end
            end

            if ~isvalid(t12)
                return;
            end

            if strcmpi(get(t12, 'State'), 'off')
                return;
            end

%import java.awt.event.*;
%mouse = Robot;
%mouse.mouseRelease(InputEvent.BUTTON3_MASK);
% mouse.mousePress(InputEvent.BUTTON3_MASK);

     %       if w == 0
            if  strcmpi(windowButton('get'), 'down')
%
 %               robotClick();
                pAxe = getAxeFromMousePosition(get(uiSeriesPtr('get'), 'Value'));

                switch pAxe

                    case axePtr('get', [], get(uiSeriesPtr('get'), 'Value'))
                        aClickedPt = get(pAxe,'CurrentPoint');

                        clickedPtX = round(aClickedPt(1,1));
                        clickedPtY = round(aClickedPt(1,2));

                    case axes1Ptr('get', [], get(uiSeriesPtr('get'), 'Value'))
                        aClickedPt = get(pAxe,'CurrentPoint');

                        clickedPtX = round(aClickedPt(1,1));
                        clickedPtY = round(aClickedPt(1,2));

                    case axes2Ptr('get', [], get(uiSeriesPtr('get'), 'Value'))
                        aClickedPt = get(pAxe,'CurrentPoint');

                        clickedPtX = round(aClickedPt(1,1));
                        clickedPtY = round(aClickedPt(1,2));

                    case axes3Ptr('get', [], get(uiSeriesPtr('get'), 'Value'))
                        aClickedPt = get(pAxe,'CurrentPoint');

                        clickedPtX = round(aClickedPt(1,1));
                        clickedPtY = round(aClickedPt(1,2));

                    case axesMipPtr('get', [], get(uiSeriesPtr('get'), 'Value'))
                        triangulateImages();
                        pAxe = axes3Ptr('get', [], get(uiSeriesPtr('get'), 'Value'));
                        clickedPtX = sliceNumber('get', 'sagittal');
                        clickedPtY = sliceNumber('get', 'coronal');

                    otherwise

                        return;
                end


                mainToolBarEnable('off');
                mouseFcn('reset');

                % roiSetAxeBorder(true, pAxe);

                dSeriesOffset = get(uiSeriesPtr('get'), 'Value');

                % aBuffer = dicomBuffer('get', [], dSeriesOffset);


                % Set ROI pael Segment btn to Cancel

                uiCreateVoiRoiPanel = uiCreateVoiRoiPanelObject('get');

                set(uiCreateVoiRoiPanel, 'String', 'Cancel');

                set(uiCreateVoiRoiPanel, 'Background', [0.2 0.039 0.027]);

                set(uiCreateVoiRoiPanel, 'Foreground', [0.94 0.94 0.94]);

                cancelCreateVoiRoiPanel('set', false);

                % bRelativeToMax = relativeToMaxRoiPanelValue('get');
                % bInPercent     = inPercentRoiPanelValue('get');
                %
                % dSliderMin = minThresholdSliderRoiPanelValue('get');
                % dSliderMax = maxThresholdSliderRoiPanelValue('get');

                % Patch for when the user don't press enter on the edit box

                % if bInPercent == true

                    pUiRoiPanelPtr = uiRoiPanelPtr('get');

                    apChildren = pUiRoiPanelPtr.Children;

                    % uiEditMaxThresholdRoiPanel

                    uiEditMaxThresholdRoiPanel = apChildren(strcmp({apChildren.UserData}, 'edtClickVoiPercentOfMax'));

                    if ~isempty(uiEditMaxThresholdRoiPanel)

                        dPercentOfMax = str2double(get(uiEditMaxThresholdRoiPanel, 'String'));
                    else

                        dPercentOfMax = clickVoiPercentOfMaxValue('get');
                    end
                % end

                createVoiFromLocation(pAxe, clickedPtX, clickedPtY, dicomBuffer('get', [], dSeriesOffset), dPercentOfMax/100, dSeriesOffset,  pixelEdge('get'));

                cancelCreateVoiRoiPanel('set', false);

                set(uiCreateVoiRoiPanel, 'String', 'Segment');

                set(uiCreateVoiRoiPanel, 'Background', [0.6300 0.6300 0.4000]);
                set(uiCreateVoiRoiPanel, 'Foreground', [0.1 0.1 0.1]);

  %                  a.Waypoints(:) = false;
%test hf=a;
                    if ~isvalid(t12)
                        return;
                    end

                    if strcmpi(get(t12, 'State'), 'off')

                        % roiSetAxeBorder(false);

                 %       windowButton('set', 'up');
                 %       mouseFcn('set');
                 %       mainToolBarEnable('on');
                 %       setCrossVisibility(1);

                        return;
                    end


%                    set(fiMainWindowPtr('get'), 'WindowScrollWheelFcn' , @wheelScroll);
                    refreshImages();

                    if strcmpi(get(tContinuous, 'State'), 'off')

                        doWhileContinuous = false;
                    end

             %   end

                % roiSetAxeBorder(false);

                windowButton('set', 'up');
                mouseFcn('set');
                mainToolBarEnable('on');
            end
        end

        catch
            progressBar(1, 'Error:drawClickVoiCallback()');
        end

%         if ~isempty(voiTemplate('get', get(uiSeriesPtr('get'), 'Value')))
%
%             set(uiLesionTypeVoiRoiPanelObject('get'), 'Enable', 'on');
%             set(uiDeleteVoiRoiPanelObject    ('get'), 'Enable', 'on');
%             set(uiAddVoiRoiPanelObject       ('get'), 'Enable', 'on');
%             set(uiPrevVoiRoiPanelObject      ('get'), 'Enable', 'on');
%             set(uiDelVoiRoiPanelObject       ('get'), 'Enable', 'on');
%             set(uiNextVoiRoiPanelObject      ('get'), 'Enable', 'on');
%         end

        set(t12, 'State', 'off');

        setCrossVisibility(true);

        set(fiMainWindowPtr('get'), 'Pointer', 'default');
        drawnow;
    end

    function viewFarthestDistancesCallback(hObject, ~)

        if strcmpi(get(hObject, 'State'), 'on')

            viewFarthestDistances('set', true);
        else
            viewFarthestDistances('set', false);
        end

        if viewFarthestDistances('get') == false

            atRoiInput = roiTemplate('get', get(uiSeriesPtr('get'), 'Value'));

            if ~isempty(atRoiInput) && isVsplash('get') == false

                numRoiInputs = numel(atRoiInput);

                for bb = 1:numRoiInputs

                    currentRoi = atRoiInput{bb};

                    if roiHasMaxDistances(currentRoi) == true

                        currentRoi.MaxDistances.MaxXY.Line.Visible = 'off';
                        currentRoi.MaxDistances.MaxCY.Line.Visible = 'off';
                        currentRoi.MaxDistances.MaxXY.Text.Visible = 'off';
                        currentRoi.MaxDistances.MaxCY.Text.Visible = 'off';                           
                    end                   
                end
            end
        end

        if ~isempty(dicomBuffer('get'))

            refreshImages();
        end
    end

    function draw2Dbrush(pAxe)

        if isa(pAxe, 'matlab.graphics.axis.Axes')

            bGetAxeFromMousePosition = false;
        else
            bGetAxeFromMousePosition = true;
        end

        dSeriesOffset = get(uiSeriesPtr('get'), 'Value');

        % robotReleaseKey();
        % axeClicked('set', true);
        % uiresume(fiMainWindowPtr('get'));

        if strcmpi(get(t2Dbrush, 'State'), 'off')
  %          robotReleaseKey();

            set(t2Dbrush, 'State', 'off');
%            roiSetAxeBorder(false);

            windowButton('set', 'up');
            mouseFcn('set');
            mainToolBarEnable('on');
            setCrossVisibility(true);

            return;
        end

        % aImageSize = size(dicomBuffer('get', [], dSeriesOffset));

%             robotReleaseKey();

        setCrossVisibility(false);

        if bGetAxeFromMousePosition == true
            
            % triangulateCallback();


            axeClicked('set', false);

            uiwait(fiMainWindowPtr('get'));
        end

        if ~isvalid(t2Dbrush)

            return;
        end

        if strcmpi(get(t2Dbrush, 'State'), 'off')

            return;
        end

%               w = waitforbuttonpress;

%            if w == 0
        if  strcmpi(windowButton('get'), 'down')

    %        robotClick();
            if bGetAxeFromMousePosition == true

                pAxe = getAxeFromMousePosition(dSeriesOffset);
            end

            switch pAxe

                case axePtr('get', [], dSeriesOffset)
                case axes1Ptr('get', [], dSeriesOffset)
                case axes2Ptr('get', [], dSeriesOffset)
                case axes3Ptr('get', [], dSeriesOffset)

                otherwise
                    return;
            end

            mainToolBarEnable('off');
            mouseFcn('reset');

     %       roiSetAxeBorder(true, gca);

        %    while strcmpi(get(t11, 'State'), 'on')

            clickedPt  = get(pAxe,'CurrentPoint');
            clickedPtX = clickedPt(1,1);
            clickedPtY = clickedPt(1,2);

            atMetaData = dicomMetaData('get');
            dSliceThickness = computeSliceSpacing(atMetaData);

            switch(pAxe)

                case axes1Ptr('get', [], dSeriesOffset) % Coronal
                    xPixel = atMetaData{1}.PixelSpacing(1);
                    yPixel = dSliceThickness;

                    % xImageSize = aImageSize(1);
%                     yImageSize = aImageSize(3);

                case axes2Ptr('get', [], dSeriesOffset) % Sagittal
                    xPixel = atMetaData{1}.PixelSpacing(2);
                    yPixel = dSliceThickness;

                    % xImageSize = aImageSize(2);
%                     yImageSize = aImageSize(3);

                otherwise % Axial
                    xPixel = atMetaData{1}.PixelSpacing(1);
                    yPixel = atMetaData{1}.PixelSpacing(2);

                    % xImageSize = aImageSize(1);
%                     yImageSize = aImageSize(2);
            end

            if xPixel == 0
                xPixel = 1;
            end

            if yPixel == 0
                yPixel = 1;
            end
% if 1
            dSphereDiameter = brush2dDefaultDiameter('get'); % in mm
% else
%             dSphereDiameter = (xImageSize/10)*xPixel;
%             brush2dDefaultDiameter('set', dSphereDiameter);
% end

            if dSphereDiameter > 0
                dSemiAxesX = dSphereDiameter/xPixel/2; % In pixel
                dSemiAxesY = dSphereDiameter/yPixel/2; % In pixel
            else
                dSemiAxesX = xPixel/2;
                dSemiAxesY = yPixel/2;
            end

            pRoiPtr  = images.roi.Ellipse(pAxe, ...
                                          'Center'             , [clickedPtX clickedPtY], ...
                                          'SemiAxes'           , [dSemiAxesX dSemiAxesY], ...
                                          'RotationAngle'      , 0, ...
                                          'Deletable'          , 0, ...
                                          'FixedAspectRatio'   , 1, ...
                                          'StripeColor'        , 'k', ...
                                          'Color'              , 'red', ...
                                          'lineWidth'          , 1, ...
                                          'Label'              , '2Dbrush', ...
                                          'LabelVisible'       , 'off', ...
                                          'InteractionsAllowed', 'none', ...
                                          'FaceSelectable'     , 0, ...
                                          'FaceAlpha'          , 0.03, ...
                                          'UserData'           , '2Dbrush', ...
                                          'Visible'            , 'on' ...
                                          );

            brush2Dptr('set', pRoiPtr);

            if ~isvalid(t2Dbrush)
                return;
            end

            if strcmpi(get(t2Dbrush, 'State'), 'off')

                roiSetAxeBorder(false);

%                            windowButton('set', 'up');
%                            mouseFcn('set');
%                            mainToolBarEnable('on');
%                            setCrossVisibility(1);

                return;
            end

     %       refreshImages();
         %   end

  %          roiSetAxeBorder(false);

            windowButton('set', 'up');
            mouseFcn('set');
            mainToolBarEnable('on');


        end

    end

    function draw2Dscissor()

        if switchTo3DMode('get')     == true || ...
           switchToIsoSurface('get') == true || ...
           switchToMIPMode('get')    == true || ...
           isVsplash('get')          == true
            set(t2Dscissor, 'State', 'off');
            return;
        end

%               releaseRoiAxeWait(t8);
        % robotReleaseKey();
        % axeClicked('set', true);
        % uiresume(fiMainWindowPtr('get'));

        dSeriesOffset = get(uiSeriesPtr('get'), 'Value');

        if contourVisibilityRoiPanelValue('get') == false

            contourVisibilityRoiPanelValue('set', true);
            set(chkContourVisibilityPanelObject('get'), 'Value', true);

            refreshImages();

            if size(dicomBuffer('get', [], dSeriesOffset), 3) ~= 1

                plotRotatedRoiOnMip(axesMipPtr('get', [], dSeriesOffset), dicomBuffer('get', [], dSeriesOffset), mipAngle('get'));
            end
        end

        if strcmpi(get(t2Dscissor, 'State'), 'off')

 %           robotReleaseKey();

            set(t2Dscissor, 'State', 'off');
            % roiSetAxeBorder(false);

            windowButton('set', 'up');
            mouseFcn('set');
            mainToolBarEnable('on');
            setCrossVisibility(true);

            return;
        end

        % releaseRoiAxeWait(t2Dscissor);

%         robotReleaseKey();

        setCrossVisibility(false);

        % triangulateCallback();

        doWhileContinuous = true;
        while doWhileContinuous == true
     %       w=waitforbuttonpress;
            axeClicked('set', false);
            doWhile = true;
            while doWhile == true
                uiwait(fiMainWindowPtr('get'));
                if axeClicked('get') == true
                    doWhile = false;
                    if strcmpi(windowButton('get'), 'up')
                        doWhileContinuous = false;
                    end
        %            axeClicked('set', false);
                end
            end

            if ~isvalid(t2Dscissor)
                return;
            end

            if strcmpi(get(t2Dscissor, 'State'), 'off')
                return;
            end
     %       if w == 0
            if  strcmpi(windowButton('get'), 'down')

                robotClick();

                pAxe = getAxeFromMousePosition(get(uiSeriesPtr('get'), 'Value'));

                switch pAxe

                    case axePtr('get', [], get(uiSeriesPtr('get'), 'Value'))
                    case axes1Ptr('get', [], get(uiSeriesPtr('get'), 'Value'))
                    case axes2Ptr('get', [], get(uiSeriesPtr('get'), 'Value'))
                    case axes3Ptr('get', [], get(uiSeriesPtr('get'), 'Value'))

                    otherwise
                        return;
                end

                mainToolBarEnable('off');
                mouseFcn('reset');

                % roiSetAxeBorder(true, pAxe);

         %       while strcmpi(get(t8, 'State'), 'on')

                    pRoiPtr = drawline(pAxe, 'Color', 'red', 'lineWidth', 1, 'Tag', num2str(randi([-(2^52/2),(2^52/2)],1)), 'LabelVisible', 'off');
                    pRoiPtr.LabelVisible = 'off';

                    scissor2Dptr('set', pRoiPtr);

                    if ~isvalid(t2Dscissor)
                        return;
                    end

                    if strcmpi(get(t2Dscissor, 'State'), 'off')

                        % roiSetAxeBorder(false);

                        return;
                    end



%                     if strcmpi(get(tContinuous, 'State'), 'off')
                        doWhileContinuous = false;
%                     end

         %       end
                try

                sMainWindowPtrPointer = get(fiMainWindowPtr('get'), 'Pointer');
                set(fiMainWindowPtr('get'), 'Pointer', 'watch');
                drawnow;

                % roiSetAxeBorder(false);

                windowButton('set', 'up');
                mouseFcn('set');
                mainToolBarEnable('on');

                splitContour(pAxe, pRoiPtr);

                delete(pRoiPtr);

                catch
                    progressBar(1, 'Error:draw2Dscissor()');

                end

                set(fiMainWindowPtr('get'), 'Pointer', sMainWindowPtrPointer);
                drawnow;
            end
        end

        set(t2Dscissor, 'State', 'off');

        setCrossVisibility(true);
    end

    function setContinuousCallback(hObject, ~)

        axeClicked('set', true);
        uiresume(fiMainWindowPtr('get'));

        set(t  , 'State', 'off');
        set(t2 , 'State', 'off');
        set(t3 , 'State', 'off');
  %      set(t4, 'State', 'off');
        set(t5 , 'State', 'off');
        set(t6 , 'State', 'off');
      %  set(t7, 'State', 'off');
        set(t8 , 'State', 'off');
        set(t11, 'State', 'off');
        set(t12, 'State', 'off');

        if strcmpi(get(hObject, 'State'), 'off')
            setCrossVisibility(true);
        end

        set(fiMainWindowPtr('get'), 'Pointer', 'default');
        drawnow;
    end

    function setInterpolateCallback(~, ~)

       lastRoiTag('');
    end

    function set2DBrushCallback(hObject, actionData)

        if switchTo3DMode('get')     == true || ...
           switchToIsoSurface('get') == true || ...
           switchToMIPMode('get')    == true || ...
           isVsplash('get')          == true

           set(hObject, 'State', 'off');
           return;
        end

        dSeriesOffset = get(uiSeriesPtr('get'), 'Value');

        if isa(actionData, 'matlab.graphics.axis.Axes')

            bGetAxeFromMousePosition = false;
        else
            bGetAxeFromMousePosition = true;
        end

        try
        % 
        % set(fiMainWindowPtr('get'), 'Pointer', 'watch');
        % drawnow;

        % axeClicked('set', true);
        % uiresume(fiMainWindowPtr('get'));

        set(t  , 'State', 'off');
        set(t2 , 'State', 'off');
        set(t3 , 'State', 'off');
        set(t5 , 'State', 'off');
        set(t6 , 'State', 'off');
        set(t8 , 'State', 'off');
        set(t11, 'State', 'off');
        set(t12, 'State', 'off');
        set(t2Dscissor, 'State', 'off');

        % if strcmpi(get(hObject, 'State'), 'on')
        if viewFarthestDistances('get') == true

            set(tFarthest, 'State', 'off');

            viewFarthestDistances('set', false);

            atRoiInput = roiTemplate('get', get(uiSeriesPtr('get'), 'Value'));

            if ~isempty(atRoiInput)

                numRoiInputs = numel(atRoiInput);

                for bb = 1:numRoiInputs

                    currentRoi = atRoiInput{bb};
                       
                    if roiHasMaxDistances(currentRoi) == true

                        currentRoi.MaxDistances.MaxXY.Line.Visible = 'off';
                        currentRoi.MaxDistances.MaxCY.Line.Visible = 'off';
                        currentRoi.MaxDistances.MaxXY.Text.Visible = 'off';
                        currentRoi.MaxDistances.MaxCY.Text.Visible = 'off';                           
                     end

                end

            end
        end

        if is2DBrush('get') == false

            set(hObject, 'State', 'on');

            is2DBrush('set', true);

            setCrossVisibility(false);

            set(t  , 'Enable', 'off');
            set(t2 , 'Enable', 'off');
            set(t3 , 'Enable', 'off');
            set(t5 , 'Enable', 'off');
            set(t6 , 'Enable', 'off');
            set(t8 , 'Enable', 'off');
            set(t11, 'Enable', 'off');
            set(t12, 'Enable', 'off');
            set(tFarthest, 'Enable', 'off');
            set(t2Dscissor, 'Enable', 'off');

            atRoiInput = roiTemplate('get', dSeriesOffset);

            if ~isempty(atRoiInput)

                for rr=1:numel(atRoiInput)
                    set(atRoiInput{rr}.Object, 'InteractionsAllowed', 'none');
                end            
            end

            draw2Dbrush(actionData);

            if strcmpi(get(t2Dbrush, 'State'), 'on')

                if bGetAxeFromMousePosition == true

                    pAxe = getAxeFromMousePosition(get(uiSeriesPtr('get'), 'Value'));

                    switch pAxe

                        case axePtr('get', [], get(uiSeriesPtr('get'), 'Value'))
                        case axes1Ptr('get', [], get(uiSeriesPtr('get'), 'Value'))
                        case axes2Ptr('get', [], get(uiSeriesPtr('get'), 'Value'))
                        case axes3Ptr('get', [], get(uiSeriesPtr('get'), 'Value'))

                        otherwise
                            return;
                    end
                else
                    pAxe = actionData;
                end

                roiSetAxeBorder(true, pAxe);

                isAxe      = pAxe == axePtr  ('get', [], dSeriesOffset);
                isCoronal  = pAxe == axes1Ptr('get', [], dSeriesOffset);
                isSagittal = pAxe == axes2Ptr('get', [], dSeriesOffset);
                isAxial    = pAxe == axes3Ptr('get', [], dSeriesOffset);

                if isAxe
                    set(uiOneWindowPtr('get'), 'HighlightColor', [1 0 0]);
                    set(uiOneWindowPtr('get'), 'BorderType', 'line');
                elseif isCoronal
                    set(uiCorWindowPtr('get'), 'HighlightColor', [1 0 0]);
                    set(uiCorWindowPtr('get'), 'BorderType', 'line');
                elseif isSagittal
                    set(uiSagWindowPtr('get'), 'HighlightColor', [1 0 0]);
                    set(uiSagWindowPtr('get'), 'BorderType', 'line');
                elseif isAxial
                    set(uiTraWindowPtr('get'), 'HighlightColor', [1 0 0]);
                    set(uiTraWindowPtr('get'), 'BorderType', 'line');
                end
               
            end
        else
            set(hObject, 'State', 'off');

            is2DBrush('set', false);

            pRoiPtr = brush2Dptr('get');

            if ~isempty(pRoiPtr)
                delete(pRoiPtr);
                brush2Dptr('set', []);
            end

            atRoiInput = roiTemplate('get', dSeriesOffset);

            if ~isempty(atRoiInput)

                for rr=1:numel(atRoiInput)
                    if ~strcmpi(get(atRoiInput{rr}.Object, 'UserData'), 'SphereROI')

                        set(atRoiInput{rr}.Object, 'InteractionsAllowed', 'all');

                        if strcmpi(atRoiInput{rr}.Object.Type, 'images.roi.freehand') || ...
                           strcmpi(atRoiInput{rr}.Object.Type, 'images.roi.assistedfreehand')

                            if isempty(find(atRoiInput{rr}.Waypoints, 1))
                                
                                atRoiInput{rr}.Object.Waypoints(:) = false;
                                atRoiInput{rr}.Waypoints = atRoiInput{rr}.Object.Waypoints;
                            end
                        end

                    end
                end
            end

            roiTemplate('set', dSeriesOffset, atRoiInput);

            if size(dicomBuffer('get', [], dSeriesOffset), 3) ~= 1

                plotRotatedRoiOnMip(axesMipPtr('get', [], dSeriesOffset), dicomBuffer('get', [], dSeriesOffset), mipAngle('get'));
            end

            roiSetAxeBorder(false);

            setCrossVisibility(true);

            set(t  , 'Enable', 'on');
            set(t2 , 'Enable', 'on');
            set(t3 , 'Enable', 'on');
            set(t5 , 'Enable', 'on');
            set(t6 , 'Enable', 'on');
            set(t8 , 'Enable', 'on');
            set(t11, 'Enable', 'on');
            set(t12, 'Enable', 'on');
            set(tFarthest, 'Enable', 'on');
            set(t2Dscissor, 'Enable', 'on');
        end
        % 
        catch
            progressBar(1, 'Error:set2DBrushCallback()');
        end

        set(fiMainWindowPtr('get'), 'Pointer', 'default');
        drawnow;
    end

    function set2DScissorCallback(hObject, ~)

        if switchTo3DMode('get')     == true || ...
           switchToIsoSurface('get') == true || ...
           switchToMIPMode('get')    == true || ...
           isVsplash('get')          == true
           set(hObject, 'State', 'off');
           return;
        end

        try

        % set(fiMainWindowPtr('get'), 'Pointer', 'watch');
        % drawnow;

        % axeClicked('set', true);
        % uiresume(fiMainWindowPtr('get'));

        set(t  , 'State', 'off');
        set(t2 , 'State', 'off');
        set(t3 , 'State', 'off');
        set(t5 , 'State', 'off');
        set(t6 , 'State', 'off');
        set(t8 , 'State', 'off');
        set(t11, 'State', 'off');
        set(t12, 'State', 'off');
        set(t2Dbrush, 'State', 'off');

        if is2DScissor('get') == false

            is2DScissor('set', true);

            setCrossVisibility(false);

            set(t  , 'Enable', 'off');
            set(t2 , 'Enable', 'off');
            set(t3 , 'Enable', 'off');
            set(t5 , 'Enable', 'off');
            set(t6 , 'Enable', 'off');
            set(t8 , 'Enable', 'off');
            set(t11, 'Enable', 'off');
            set(t12, 'Enable', 'off');
            set(tFarthest, 'Enable', 'off');
            set(t2Dbrush, 'Enable', 'off');

            draw2Dscissor();

            is2DScissor('set', false);

        end
        catch
            progressBar(1, 'Error:set2DScissorCallback()');
        end

        pRoiPtr = scissor2Dptr('get');

        if ~isempty(pRoiPtr)
            delete(pRoiPtr);
            scissor2Dptr('set', []);
        end

        roiSetAxeBorder(false);

        setCrossVisibility(true);

        is2DScissor('set', false);

        set(t  , 'Enable', 'on');
        set(t2 , 'Enable', 'on');
        set(t3 , 'Enable', 'on');
        set(t5 , 'Enable', 'on');
        set(t6 , 'Enable', 'on');
        set(t8 , 'Enable', 'on');
        set(t11, 'Enable', 'on');
        set(t12, 'Enable', 'on');
        set(tFarthest, 'Enable', 'on');
        set(t2Dbrush, 'Enable', 'on');

        set(fiMainWindowPtr('get'), 'Pointer', 'default');
        drawnow;
    end

    % function checkWaitStatus(src)
    %     a=1
    %     f = fiMainWindowPtr('get');
    %     if strcmp(f.WaitStatus, 'waiting')
    %         % Reset WaitStatus to 'inactive'
    %         set(f, 'WaitStatus', 'inactive');
    %     end
    % end

    function interpolateROIsByTag(sTag1, sTag2)

        lastRoiTag(sTag1);

        if isempty(sTag2)
            return;
        end

        % try
        % 
        % set(fiMainWindowPtr('get'), 'Pointer', 'watch');
        % drawnow;

        dSeriesOffset = get(uiSeriesPtr('get'), 'Value');

        if size(dicomBuffer('get', [], dSeriesOffset), 3) ~= 1

            atRoiInput = roiTemplate('get', dSeriesOffset);
            atVoiInput = voiTemplate('get', dSeriesOffset);
    
            dTagOffset1 = find(strcmp( cellfun( @(atRoiInput) atRoiInput.Tag, atRoiInput, 'uni', false ), {sTag1} ), 1);
            dTagOffset2 = find(strcmp( cellfun( @(atRoiInput) atRoiInput.Tag, atRoiInput, 'uni', false ), {sTag2} ), 1);
    
            if ~isempty(dTagOffset1)&&~isempty(dTagOffset2) 
    
                if strcmpi(atRoiInput{dTagOffset2}.ObjectType, 'voi-roi')
    
                    for vv=1:numel(atVoiInput)
    
                        dVoiTagOffset = find(contains(atVoiInput{vv}.RoisTag, atRoiInput{dTagOffset2}.Tag), 1);
    
                        if ~isempty(dVoiTagOffset)
                            
                            dNbTags = numel(atVoiInput{vv}.RoisTag);
    
                            adSliceNb = cell(2, dNbTags);
                            for rr=1:numel(atVoiInput{vv}.RoisTag)
                                
                                dTagOffset = find(strcmp( cellfun( @(atRoiInput) atRoiInput.Tag, atRoiInput, 'uni', false ), atVoiInput{vv}.RoisTag{rr} ), 1);
    
                                if ~isempty(dTagOffset)
    
                                    adSliceNb{1, rr} = atRoiInput{dTagOffset}.SliceNb;
                                    adSliceNb{2, rr} = dTagOffset;
     
                                end
                            end
    
                            numericValues = cell2mat(adSliceNb);
    
                            [minValue, minOffset] = min(numericValues(1,:));
                            [~, maxOffset]        = max(numericValues(1,:));
    
                            if atRoiInput{dTagOffset1}.SliceNb < minValue
                                dTagOffset2 = numericValues(2,minOffset);
                            else
                                dTagOffset2 = numericValues(2,maxOffset);
                            end
    
                            break;
                        end
                    end
                end
                
                interpolateBetweenROIs(atRoiInput{dTagOffset1}, atRoiInput{dTagOffset2}, dSeriesOffset, true); 

            end
        end

        % catch
        %     progressBar(1, 'Error:interpolateROIsByTag()');
        % end

        set(fiMainWindowPtr('get'), 'Pointer', 'default');
        drawnow;
    end

    function sLastTag = lastRoiTag(sTag)

        persistent psLastTag;

        if exist('sTag', 'var')
            psLastTag = sTag;
        end

        sLastTag = psLastTag;
    end
end
