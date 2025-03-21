function pasteRoiCallback(~, ~)
%function pasteRoiCallback(~, ~)
%Paste ROI Default Right Click menu.
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

    windowButton('set', 'up'); % Patch for Linux

    ptrRoi = copyRoiPtr('get');

    dSeriesOffset = get(uiSeriesPtr('get'), 'Value');

    if isempty(ptrRoi)
        return;
    end

    if ~isvalid(ptrRoi)
        return;
    end
    
    pAxe = getAxeFromMousePosition(dSeriesOffset);

    if isempty(pAxe)
        return;
    end

    if ptrRoi.Parent ~= pAxe
        return;
    end

    sTag = num2str(randi([-(2^52/2),(2^52/2)],1));
    
    clickedPt = get(pAxe,'CurrentPoint');
    
    clickedPtX = clickedPt(1,1);
    clickedPtY = clickedPt(1,2);
            
    switch lower(ptrRoi.Type)

        case lower('images.roi.line')

            xOffset = ptrRoi.Position(1,1)-clickedPtX;
            yOffset = ptrRoi.Position(1,2)-clickedPtY;
            
            aLinePosition = zeros(2,2);
            aLinePosition(:,1) = ptrRoi.Position(:,1) - xOffset;
            aLinePosition(:,2) = ptrRoi.Position(:,2) - yOffset;
            
            pRoi = images.roi.Line(ptrRoi.Parent, ...
                                   'Position'           , aLinePosition, ...
                                   'Color'              , ptrRoi.Color, ...
                                   'LineWidth'          , ptrRoi.LineWidth, ...
                                   'Label'              , ptrRoi.Label, ...
                                   'LabelVisible'       , 'on', ...
                                   'Tag'                , sTag, ...
                                   'StripeColor'        , ptrRoi.StripeColor, ...                                                                             
                                   'InteractionsAllowed', ptrRoi.InteractionsAllowed, ...                                      
                                   'UserData'           , ptrRoi.UserData, ...
                                   'Visible'            , 'on' ...
                                   );

            uimenu(pRoi.UIContextMenu, 'Label', 'Copy Contour' , 'UserData', pRoi, 'Callback', @copyRoiCallback, 'Separator', 'on');
            uimenu(pRoi.UIContextMenu, 'Label', 'Paste Contour', 'UserData', pRoi, 'Callback', @pasteRoiCallback);

            uimenu(pRoi.UIContextMenu,'Label', 'Snap To Circles'   , 'UserData',pRoi, 'Callback',@snapLinesToCirclesCallback, 'Separator', 'on');
            uimenu(pRoi.UIContextMenu,'Label', 'Snap To Rectangles', 'UserData',pRoi, 'Callback',@snapLinesToRectanglesCallback);

            uimenu(pRoi.UIContextMenu,'Label', 'Edit Label'     , 'UserData',pRoi, 'Callback',@editLabelCallback, 'Separator', 'on');
            uimenu(pRoi.UIContextMenu,'Label', 'Hide/View Label', 'UserData',pRoi, 'Callback',@hideViewLabelCallback);
            uimenu(pRoi.UIContextMenu,'Label', 'Edit Color'     , 'UserData',pRoi, 'Callback',@editColorCallback);

            constraintMenu(pRoi);

            cropMenu(pRoi);

            uimenu(pRoi.UIContextMenu,'Label', 'Display Statistics ' , 'UserData',pRoi, 'Callback',@figRoiDialogCallback, 'Separator', 'on');

            addRoi(pRoi, dSeriesOffset, 'Unspecified');


        case lower('images.roi.freehand')
            
            atRoiInput = roiTemplate('get', dSeriesOffset);

            dRoiTagOffset = find(strcmp( cellfun( @(atRoiInput) atRoiInput.Tag, atRoiInput, 'uni', false ), ptrRoi.Tag ), 1);

            dSliceNb = 0;

            if ~isempty(dRoiTagOffset) % Found the Tag
                dSliceNb = atRoiInput{dRoiTagOffset}.SliceNb;
            end

            bUseMousePosition = false;
            
            switch ptrRoi.Parent

                case axePtr('get', [], dSeriesOffset)

                    bUseMousePosition = true;

                case axes1Ptr('get', [], dSeriesOffset)

                    if sliceNumber('get', 'coronal') == dSliceNb

                        bUseMousePosition = true;
                    end

                case axes2Ptr('get', [], dSeriesOffset)

                    if sliceNumber('get', 'sagittal') == dSliceNb

                        bUseMousePosition = true;
                    end

                case axes3Ptr('get', [], dSeriesOffset)

                    if sliceNumber('get', 'axial') == dSliceNb

                        bUseMousePosition = true;
                    end
            end

            if bUseMousePosition == true

                xOffset = ptrRoi.Position(1,1)-clickedPtX;
                yOffset = ptrRoi.Position(1,2)-clickedPtY;
    
                aFreehandPosition = zeros(numel(ptrRoi.Position(:,1)),2);
                aFreehandPosition(:,1) = ptrRoi.Position(:,1) - xOffset;
                aFreehandPosition(:,2) = ptrRoi.Position(:,2) - yOffset;
            else
                aFreehandPosition = ptrRoi.Position;
            end

            pRoi = images.roi.Freehand(ptrRoi.Parent, ...
                                       'Position'           , aFreehandPosition, ...
                                       'Smoothing'          , ptrRoi.Smoothing, ...
                                       'Color'              , ptrRoi.Color, ...
                                       'LineWidth'          , ptrRoi.LineWidth, ...
                                       'Label'              , roiLabelName(), ...
                                       'LabelVisible'       , ptrRoi.LabelVisible, ...
                                       'FaceSelectable'     , ptrRoi.FaceSelectable, ...
                                       'FaceAlpha'          , ptrRoi.FaceAlpha, ...
                                       'Tag'                , sTag, ...
                                       'StripeColor'        , ptrRoi.StripeColor, ...                                                                              
                                       'InteractionsAllowed', ptrRoi.InteractionsAllowed, ...                                          
                                       'UserData'           , ptrRoi.UserData, ...
                                       'Visible'            , 'on' ...
                                       );
                                   
            pRoi.Waypoints(:) = ptrRoi.Waypoints(:);

            addRoi(pRoi, dSeriesOffset, 'Unspecified');

            addRoiMenu(pRoi);

            % addlistener(pRoi, 'WaypointAdded'  , @waypointEvents);
            % addlistener(pRoi, 'WaypointRemoved', @waypointEvents); 

            % voiDefaultMenu(pRoi);
            % 
            % roiDefaultMenu(pRoi);
            % 
            % uimenu(pRoi.UIContextMenu, 'Label', 'Hide/View Face Alpha', 'UserData', pRoi, 'Callback', @hideViewFaceAlhaCallback);
            % uimenu(pRoi.UIContextMenu, 'Label', 'Clear Waypoints', 'UserData', pRoi, 'Callback', @clearWaypointsCallback);
            % 
            % constraintMenu(pRoi);
            % 
            % cropMenu(pRoi);
            % 
            % uimenu(pRoi.UIContextMenu, 'Label', 'Display Statistics ' , 'UserData', pRoi, 'Callback', @figRoiDialogCallback, 'Separator', 'on');
            
        case lower('images.roi.polygon')
            
            atRoiInput = roiTemplate('get', dSeriesOffset);

            dRoiTagOffset = find(strcmp( cellfun( @(atRoiInput) atRoiInput.Tag, atRoiInput, 'uni', false ), ptrRoi.Tag ), 1);

            dSliceNb = 0;

            if ~isempty(dRoiTagOffset) % Found the Tag
                dSliceNb = atRoiInput{dRoiTagOffset}.SliceNb;
            end

            bUseMousePosition = false;
            
            switch ptrRoi.Parent

                case axePtr('get', [], dSeriesOffset)

                    bUseMousePosition = true;

                case axes1Ptr('get', [], dSeriesOffset)

                    if sliceNumber('get', 'coronal') == dSliceNb

                        bUseMousePosition = true;
                    end

                case axes2Ptr('get', [], dSeriesOffset)

                    if sliceNumber('get', 'sagittal') == dSliceNb

                        bUseMousePosition = true;
                    end

                case axes3Ptr('get', [], dSeriesOffset)

                    if sliceNumber('get', 'axial') == dSliceNb

                        bUseMousePosition = true;
                    end
            end

            if bUseMousePosition == true

                xOffset = ptrRoi.Position(1,1)-clickedPtX;
                yOffset = ptrRoi.Position(1,2)-clickedPtY;
    
                aPolygonPosition = zeros(numel(ptrRoi.Position(:,1)),2);
                aPolygonPosition(:,1) = ptrRoi.Position(:,1) - xOffset;
                aPolygonPosition(:,2) = ptrRoi.Position(:,2) - yOffset;
            else
                aPolygonPosition = ptrRoi.Position;
            end

            pRoi = images.roi.Polygon(ptrRoi.Parent, ...
                                      'Position'           , aPolygonPosition, ...
                                      'Color'              , ptrRoi.Color, ...
                                      'FaceAlpha'          , ptrRoi.FaceAlpha, ...
                                      'LineWidth'          , ptrRoi.LineWidth, ...
                                      'Label'              , roiLabelName(), ...
                                      'LabelVisible'       , ptrRoi.LabelVisible, ...
                                      'FaceSelectable'     , ptrRoi.FaceSelectable, ...
                                      'FaceAlpha'          , ptrRoi.FaceAlpha, ...
                                      'Tag'                , sTag, ...
                                      'StripeColor'        , ptrRoi.StripeColor, ...                                                                             
                                      'InteractionsAllowed', ptrRoi.InteractionsAllowed, ...                                         
                                      'UserData'           , ptrRoi.UserData, ...
                                      'Visible'            , 'on' ...
                                      );
                                  
            addRoi(pRoi, dSeriesOffset, 'Unspecified');

            addRoiMenu(pRoi);

            % voiDefaultMenu(pRoi);
            % 
            % roiDefaultMenu(pRoi);
            % 
            % uimenu(pRoi.UIContextMenu,'Label', 'Hide/View Face Alpha', 'UserData', pRoi, 'Callback', @hideViewFaceAlhaCallback);
            % 
            % constraintMenu(pRoi);
            % 
            % cropMenu(pRoi);
            % 
            % uimenu(pRoi.UIContextMenu, 'Label', 'Display Statistics ' , 'UserData', pRoi, 'Callback', @figRoiDialogCallback, 'Separator', 'on');

           
        case lower('images.roi.circle')

            pRoi = images.roi.Circle(ptrRoi.Parent, ...
                                     'Position'           , [clickedPtX clickedPtY], ...
                                     'Radius'             , ptrRoi.Radius, ...
                                     'Color'              , ptrRoi.Color, ...
                                     'FaceAlpha'          , ptrRoi.FaceAlpha, ...
                                     'LineWidth'          , ptrRoi.LineWidth, ...
                                     'Label'              , roiLabelName(), ...
                                     'LabelVisible'       , ptrRoi.LabelVisible, ...
                                     'FaceSelectable'     , ptrRoi.FaceSelectable, ...
                                     'FaceAlpha'          , ptrRoi.FaceAlpha, ...
                                     'Tag'                , sTag, ...
                                     'StripeColor'        , ptrRoi.StripeColor, ...                                                                             
                                     'InteractionsAllowed', ptrRoi.InteractionsAllowed, ...                                           
                                     'UserData'           , ptrRoi.UserData, ...
                                     'Visible'            , 'on' ...
                                     );

            addRoi(pRoi, dSeriesOffset, 'Unspecified');

            addRoiMenu(pRoi);

            % voiDefaultMenu(pRoi);
            % 
            % roiDefaultMenu(pRoi);
            % 
            % constraintMenu(pRoi);
            % 
            % cropMenu(pRoi);
            % 
            % uimenu(pRoi.UIContextMenu, 'Label', 'Display Statistics ' , 'UserData', pRoi, 'Callback', @figRoiDialogCallback, 'Separator', 'on');
            % 
            
        case lower('images.roi.ellipse')

            pRoi = images.roi.Ellipse(ptrRoi.Parent, ...
                                      'Position'           , [clickedPtX clickedPtY], ...
                                      'SemiAxes'           , ptrRoi.SemiAxes, ...
                                      'RotationAngle'      , ptrRoi.RotationAngle, ...
                                      'Color'              , ptrRoi.Color, ...
                                      'FaceAlpha'          , ptrRoi.FaceAlpha, ...
                                      'LineWidth'          , ptrRoi.LineWidth, ...
                                      'Label'              , roiLabelName(), ...
                                      'LabelVisible'       , ptrRoi.LabelVisible, ...
                                      'FaceSelectable'     , ptrRoi.FaceSelectable, ...
                                      'FaceAlpha'          , ptrRoi.FaceAlpha, ...
                                      'Tag'                , sTag, ...
                                      'StripeColor'        , ptrRoi.StripeColor, ...
                                      'InteractionsAllowed', ptrRoi.InteractionsAllowed, ...                                      
                                      'FixedAspectRatio'   , ptrRoi.FixedAspectRatio, ...
                                      'UserData'           , ptrRoi.UserData, ...
                                      'Visible'            , 'on' ...
                                      );

            addRoi(pRoi, dSeriesOffset, 'Unspecified');

            addRoiMenu(pRoi);

            % voiDefaultMenu(pRoi);
            % 
            % roiDefaultMenu(pRoi);
            % 
            % uimenu(pRoi.UIContextMenu,'Label', 'Hide/View Face Alpha', 'UserData', pRoi, 'Callback', @hideViewFaceAlhaCallback);
            % 
            % constraintMenu(pRoi);
            % 
            % cropMenu(pRoi);
            % 
            % uimenu(pRoi.UIContextMenu, 'Label', 'Display Statistics ' , 'UserData', pRoi, 'Callback', @figRoiDialogCallback, 'Separator', 'on');
            % 
            
            if strcmpi(pRoi.UserData, 'Sphere')

                atRoi = roiTemplate('get', dSeriesOffset);
                atVoi = voiTemplate('get', dSeriesOffset);
                
                dFirstRoiOffset = find(strcmp( cellfun( @(atRoi) atRoi.Tag, atRoi, 'uni', false ), {ptrRoi.Tag} ), 1);
                
                if ~isempty(dFirstRoiOffset)
                    
                    for vv=1:numel(atVoi)

                        pRoisTag   = atVoi{vv}.RoisTag;
                        dTagOffset = find(strcmp( cellfun( @(pRoisTag) pRoisTag, pRoisTag, 'uni', false ), ptrRoi.Tag ), 1);

                        if ~isempty(dTagOffset) % Found sphere

                            asTag{1} = sTag;
                            
                            switch lower(atRoi{dFirstRoiOffset}.Axe)

                                case 'axes1'
                                    sPlane = 'coronal';
                                    dLastSlice = size(dicomBuffer('get'), 1);

                                case 'axes2'
                                    dLastSlice = size(dicomBuffer('get'), 2);
                                    sPlane = 'sagittal';

                                case 'axes3'
                                    sPlane = 'axial';
                                    dLastSlice = size(dicomBuffer('get'), 3);
                            end
                            
                            dInitalRoiOffset = sliceNumber('get', sPlane);
                            
                            for rr=1:numel(pRoisTag)

                                if strcmp(pRoisTag{rr}, ptrRoi.Tag)
                                    continue;
                                end

                                dVoiRoiTagOffset = find(strcmp( cellfun( @(atRoi) atRoi.Tag, atRoi, 'uni', false ), pRoisTag(rr) ), 1);

                                if ~isempty(dVoiRoiTagOffset)

                                    dSliceOffset =   atRoi{dFirstRoiOffset}.SliceNb - atRoi{dVoiRoiTagOffset}.SliceNb;
                                    
                                    dSliceNumber = dInitalRoiOffset-dSliceOffset;
                                    
                                    if dSliceNumber > dLastSlice || ...
                                       dSliceNumber < 1 
                                        continue;
                                    end
                                    
                                    sliceNumber('set', sPlane, dSliceNumber);                

                                    sTag = num2str(randi([-(2^52/2),(2^52/2)],1));

                                    a = images.roi.Ellipse(pAxe, ...
                                                           'Center'             , pRoi.Center, ...
                                                           'SemiAxes'           , atRoi{dVoiRoiTagOffset}.SemiAxes, ...
                                                           'RotationAngle'      , atRoi{dVoiRoiTagOffset}.RotationAngle, ...
                                                           'Deletable'          , 0, ...
                                                           'FixedAspectRatio'   , atRoi{dVoiRoiTagOffset}.FixedAspectRatio, ...
                                                           'InteractionsAllowed', atRoi{dVoiRoiTagOffset}.InteractionsAllowed, ...
                                                           'StripeColor'        , atRoi{dVoiRoiTagOffset}.StripeColor, ...
                                                           'Color'              , atRoi{dVoiRoiTagOffset}.Color, ...
                                                           'LineWidth'          , atRoi{dVoiRoiTagOffset}.LineWidth, ...
                                                           'Label'              , roiLabelName(), ...
                                                           'LabelVisible'       , 'off', ...
                                                           'Tag'                , sTag, ...
                                                           'FaceSelectable'     , atRoi{dVoiRoiTagOffset}.FaceSelectable, ...
                                                           'FaceAlpha'          , atRoi{dVoiRoiTagOffset}.FaceAlpha, ...
                                                           'UserData'           , atRoi{dVoiRoiTagOffset}.UserData, ...
                                                           'Visible'            , 'off' ...
                                                           );

                                    addRoi(a, dSeriesOffset, 'Unspecified');

                                    asTag{numel(asTag)+1} = sTag;    

                                end   

                            end
                        end
                        
                        createVoiFromRois(dSeriesOffset, asTag, sprintf('Sphere %s mm', num2str(atRoi{dFirstRoiOffset}.MaxDistances.MaxXY.Length)), ptrRoi.Color, 'Unspecified');

                        setVoiRoiSegPopup();

                        sliceNumber('set', sPlane, dInitalRoiOffset);
                        
                        break;
                    end   
                end
            end
                

        case lower('images.roi.rectangle')
                        
            aRectanglePosition = zeros(1,4);
            aRectanglePosition(1) = clickedPtX;
            aRectanglePosition(2) = clickedPtY;
            aRectanglePosition(3) = ptrRoi.Position(3);
            aRectanglePosition(4) = ptrRoi.Position(4);
            
            pRoi = images.roi.Rectangle(ptrRoi.Parent, ...
                                        'Position'           ,aRectanglePosition, ...
                                        'Rotatable'          , ptrRoi.Rotatable, ...
                                        'RotationAngle'      , ptrRoi.RotationAngle, ...
                                        'Color'              , ptrRoi.Color, ...
                                        'FaceAlpha'          , ptrRoi.FaceAlpha, ...
                                        'LineWidth'          , ptrRoi.LineWidth, ...
                                        'Label'              , roiLabelName(), ...
                                        'LabelVisible'       , ptrRoi.LabelVisible, ...
                                        'FaceSelectable'     , ptrRoi.FaceSelectable, ...
                                        'FaceAlpha'          , ptrRoi.FaceAlpha, ...
                                        'Tag'                , sTag, ...
                                        'StripeColor'        , ptrRoi.StripeColor, ...                                                                             
                                        'InteractionsAllowed', ptrRoi.InteractionsAllowed, ...                                           
                                        'FixedAspectRatio'   , ptrRoi.FixedAspectRatio, ...
                                        'UserData'           , ptrRoi.UserData, ...
                                        'Visible'            , 'on' ...
                                        );

            addRoi(pRoi, dSeriesOffset, 'Unspecified');
            
            addRoiMenu(pRoi);

            % voiDefaultMenu(pRoi);
            % 
            % roiDefaultMenu(pRoi);
            % 
            % uimenu(pRoi.UIContextMenu,'Label', 'Hide/View Face Alpha', 'UserData', pRoi, 'Callback', @hideViewFaceAlhaCallback);
            % 
            % constraintMenu(pRoi);
            % 
            % cropMenu(pRoi);
            % 
            % uimenu(pRoi.UIContextMenu, 'Label', 'Display Statistics ' , 'UserData', pRoi, 'Callback', @figRoiDialogCallback, 'Separator', 'on');
            % 
        otherwise
            return;
    end

    if size(dicomBuffer('get', [], dSeriesOffset), 3) ~= 1

        plotRotatedRoiOnMip(axesMipPtr('get', [], dSeriesOffset), dicomBuffer('get', [], dSeriesOffset), mipAngle('get'));       
    end
              
%    setVoiRoiSegPopup();


end
