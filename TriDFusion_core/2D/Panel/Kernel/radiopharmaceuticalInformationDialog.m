function tInformation = radiopharmaceuticalInformationDialog()
%function tInformation = radiopharmaceuticalInformationDialog()
%Create a dialog and return a structure of the radiopharmaceutical information.
%See TriDFuison.doc (or pdf) for more information about options.
%
%Note: option settings must fit on one line and can contain one semicolon at most.
%Options can be strings, cell arrays of strings, or numerical arrays.
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

    tInformation = [];

    dlgInformation = ...
        dialog('Position', [(getMainWindowPosition('xpos')+(getMainWindowSize('xsize')/2)-380/2) ...
                            (getMainWindowPosition('ypos')+(getMainWindowSize('ysize')/2)-605/2) ...
                            380 ...
                            605 ...
                            ],...
               'MenuBar', 'none',...
               'Resize', 'off', ...    
               'NumberTitle','off',...
               'MenuBar', 'none',...
               'Color', viewerBackgroundColor('get'), ...
               'Name', 'Microsphere In Specimen',...
               'Toolbar','none'...               
               );           

        axes(dlgInformation, ...
             'Units'   , 'pixels', ...
             'Position', get(dlgInformation, 'Position'), ...
             'Color'   , viewerBackgroundColor('get'),...
             'XColor'  , viewerForegroundColor('get'),...
             'YColor'  , viewerForegroundColor('get'),...
             'ZColor'  , viewerForegroundColor('get'),...             
             'Visible' , 'off'...             
             ); 

    atMetaData = dicomMetaData('get');

    sPixelSpacingX = num2str(atMetaData{1}.PixelSpacing(1));         
    sPixelSpacingY = num2str(atMetaData{1}.PixelSpacing(2));     
    sPixelSpacingZ = num2str(computeSliceSpacing(atMetaData));     

    if isSameSpacingDoseInformationDialog('get') == false
        sYZPixelSpacingEditEnable = 'on';
    else
        sYZPixelSpacingEditEnable = 'off';
    end

    sSeriesTime = atMetaData{1}.SeriesTime;
    sSeriesDate = atMetaData{1}.SeriesDate;

    if isfield(atMetaData{1}, 'RadiopharmaceuticalInformationSequence')

        sRadiopharmaceuticalStartDateTime = atMetaData{1}.RadiopharmaceuticalInformationSequence.Item_1.RadiopharmaceuticalStartDateTime;

        if numel(sRadiopharmaceuticalStartDateTime) >= 14
            sRadiopharmaceuticalStartDate = sRadiopharmaceuticalStartDateTime(1:8);
            sRadiopharmaceuticalStartTime = sRadiopharmaceuticalStartDateTime(9:14);                
        else                
            sRadiopharmaceuticalStartDate = [];
            sRadiopharmaceuticalStartTime = [];            
        end

        sRadionuclideHalfLife = atMetaData{1}.RadiopharmaceuticalInformationSequence.Item_1.RadionuclideHalfLife;
    else
        sRadiopharmaceuticalStartDate = [];
        sRadiopharmaceuticalStartTime = [];

        sRadionuclideHalfLife = '230400'; %Y90               
    end

    chkIsSamePixelSpacing = ...
        uicontrol(dlgInformation,...
                  'style'   , 'checkbox',...
                  'enable'  , 'on',...
                  'value'   , isSameSpacingDoseInformationDialog('get'),...
                  'position', [20 565 20 20],...
                  'BackgroundColor', viewerBackgroundColor('get'), ...
                  'ForegroundColor', viewerForegroundColor('get'), ...                    
                  'Callback', @isSameSpacingDoseInformationCallback...
                  );

         uicontrol(dlgInformation,...
                  'style'   , 'text',...
                  'string'  , 'Square X-Y-Z Voxel Size',...
                  'horizontalalignment', 'left',...
                  'position', [40 562 200 20],...
                  'Enable', 'Inactive',...
                  'BackgroundColor', viewerBackgroundColor('get'), ...
                  'ForegroundColor', viewerForegroundColor('get'), ...                    
                  'ButtonDownFcn', @isSameSpacingDoseInformationCallback...
                  );      

    % Image size

        uicontrol(dlgInformation,...
                  'style'   , 'text',...
                  'string'  , 'X - Pixel Spacing (mm)',...
                  'horizontalalignment', 'left',...
                  'BackgroundColor', viewerBackgroundColor('get'), ...
                  'ForegroundColor', viewerForegroundColor('get'), ...                   
                  'position', [40 537 150 20]...
                  );   

    edtPixelSpacingX = ...
      uicontrol(dlgInformation,...
                'style'     , 'edit',...
                'Background', 'white',...
                'string'    , sPixelSpacingX,...
                'BackgroundColor', viewerBackgroundColor('get'), ...
                'ForegroundColor', viewerForegroundColor('get'), ...                 
                'position'  , [200 540 160 20], ...
                'Callback', @edtPixelSpacingDoseInformationCallback...
                );             


        uicontrol(dlgInformation,...
                  'style'   , 'text',...
                  'string'  , 'Y - Pixel Spacing (mm)',...
                  'horizontalalignment', 'left',...
                  'BackgroundColor', viewerBackgroundColor('get'), ...
                  'ForegroundColor', viewerForegroundColor('get'), ...                   
                  'position', [40 512 150 20]...
                  );   

    edtPixelSpacingY = ...
      uicontrol(dlgInformation,...
                'style'     , 'edit',...
                'enable'  , sYZPixelSpacingEditEnable, ...
                'Background', 'white',...
                'string'    , sPixelSpacingY,...
                'BackgroundColor', viewerBackgroundColor('get'), ...
                'ForegroundColor', viewerForegroundColor('get'), ...                 
                'position'  , [200 515 160 20]...
                );  

        uicontrol(dlgInformation,...
                  'style'   , 'text',...
                  'string'  , 'Z - Slice Thickness (mm)',...
                  'horizontalalignment', 'left',...
                  'BackgroundColor', viewerBackgroundColor('get'), ...
                  'ForegroundColor', viewerForegroundColor('get'), ...                   
                  'position', [40 487 150 20]...
                  );   

    edtPixelSpacingZ = ...
      uicontrol(dlgInformation,...
                'style'     , 'edit',...
                'enable'  , sYZPixelSpacingEditEnable, ...
                'Background', 'white',...
                'string'    , sPixelSpacingZ,...
                'BackgroundColor', viewerBackgroundColor('get'), ...
                'ForegroundColor', viewerForegroundColor('get'), ...                 
                'position'  , [200 490 160 20]...
                );  

    % Resize image 

    if resizePixelSizeDoseInformationDialog('get') == false           

        sXResizePixelSpacingEditEnable  = 'off';            
        sYZResizePixelSpacingEditEnable = 'off';              

        sResizePixelSpacingX = num2str(resizeVoxelDoseInformationDialog('get', 'x'));
        sResizePixelSpacingY = num2str(resizeVoxelDoseInformationDialog('get', 'y'));
        sResizePixelSpacingZ = num2str(resizeVoxelDoseInformationDialog('get', 'z'));            
    else
        if isSameSpacingDoseInformationDialog('get') == false
            sXResizePixelSpacingEditEnable  = 'on';            
            sYZResizePixelSpacingEditEnable = 'on';         
        else
            sXResizePixelSpacingEditEnable  = 'on';            
            sYZResizePixelSpacingEditEnable = 'off';                        
        end

        sResizePixelSpacingX = num2str(resizeVoxelDoseInformationDialog('get', 'x'));
        sResizePixelSpacingY = num2str(resizeVoxelDoseInformationDialog('get', 'x'));
        sResizePixelSpacingZ = num2str(resizeVoxelDoseInformationDialog('get', 'x'));             
    end

    chkResizePixelSize = ...
        uicontrol(dlgInformation,...
                  'style'   , 'checkbox',...
                  'enable'  , 'on',...
                  'value'   , resizePixelSizeDoseInformationDialog('get'),...
                  'position', [20 440 20 20],...
                  'BackgroundColor', viewerBackgroundColor('get'), ...
                  'ForegroundColor', viewerForegroundColor('get'), ...                    
                  'Callback', @resizePixelSizeDoseInformationCallback...
                  );

         uicontrol(dlgInformation,...
                  'style'   , 'text',...
                  'string'  , 'Resize X-Y-Z Voxel Size',...
                  'horizontalalignment', 'left',...
                  'position', [40 437 200 20],...
                  'Enable', 'Inactive',...
                  'BackgroundColor', viewerBackgroundColor('get'), ...
                  'ForegroundColor', viewerForegroundColor('get'), ...                    
                  'ButtonDownFcn', @resizePixelSizeDoseInformationCallback...
                  );      

        uicontrol(dlgInformation,...
                  'style'   , 'text',...
                  'string'  , 'X - Pixel Spacing (mm)',...
                  'horizontalalignment', 'left',...
                  'BackgroundColor', viewerBackgroundColor('get'), ...
                  'ForegroundColor', viewerForegroundColor('get'), ...                   
                  'position', [40 412 150 20]...
                  );   

    edtResizePixelSpacingX = ...
      uicontrol(dlgInformation,...
                'style'     , 'edit',...
                'enable'  , sXResizePixelSpacingEditEnable, ...
                'Background', 'white',...
                'string'    , sResizePixelSpacingX,...
                'BackgroundColor', viewerBackgroundColor('get'), ...
                'ForegroundColor', viewerForegroundColor('get'), ...                 
                'position'  , [200 415 160 20], ...
                'Callback', @edtResizePixelSpacingDoseInformationCallback...
                );             


        uicontrol(dlgInformation,...
                  'style'   , 'text',...
                  'string'  , 'Y - Pixel Spacing (mm)',...
                  'horizontalalignment', 'left',...
                  'BackgroundColor', viewerBackgroundColor('get'), ...
                  'ForegroundColor', viewerForegroundColor('get'), ...                   
                  'position', [40 387 150 20]...
                  );   

    edtResizePixelSpacingY = ...
      uicontrol(dlgInformation,...
                'style'     , 'edit',...
                'enable'  , sYZResizePixelSpacingEditEnable, ...
                'Background', 'white',...
                'string'    , sResizePixelSpacingY,...
                'BackgroundColor', viewerBackgroundColor('get'), ...
                'ForegroundColor', viewerForegroundColor('get'), ...                 
                'position'  , [200 390 160 20]...
                );  

        uicontrol(dlgInformation,...
                  'style'   , 'text',...
                  'string'  , 'Z - Slice Thickness (mm)',...
                  'horizontalalignment', 'left',...
                  'BackgroundColor', viewerBackgroundColor('get'), ...
                  'ForegroundColor', viewerForegroundColor('get'), ...                   
                  'position', [40 362 150 20]...
                  );   

    edtResizePixelSpacingZ = ...
      uicontrol(dlgInformation,...
                'style'     , 'edit',...
                'enable'  , sYZResizePixelSpacingEditEnable, ...
                'Background', 'white',...
                'string'    , sResizePixelSpacingZ,...
                'BackgroundColor', viewerBackgroundColor('get'), ...
                'ForegroundColor', viewerForegroundColor('get'), ...                 
                'position'  , [200 365 160 20]...
                );  

    % Microsphere Volume 

        uicontrol(dlgInformation,...
                  'style'   , 'text',...
                  'string'  , 'Microsphere Volume (cm3)',...
                  'horizontalalignment', 'left',...
                  'BackgroundColor', viewerBackgroundColor('get'), ...
                  'ForegroundColor', viewerForegroundColor('get'), ...                   
                  'position', [20 312 150 20]...
                  );   

    edtMicrosphereVolume = ...
      uicontrol(dlgInformation,...
                'style'     , 'edit',...
                'Background', 'white',...
                'string'    , num2str(microspereVolumeDoseInformationDialog('get')),...
                'BackgroundColor', viewerBackgroundColor('get'), ...
                'ForegroundColor', viewerForegroundColor('get'), ...                 
                'position'  , [200 315 160 20]...
                );  

    % Series Date \ Time

        uicontrol(dlgInformation,...
                  'style'   , 'text',...
                  'string'  , 'Callibration Date (yyyyMMdd)',...
                  'horizontalalignment', 'left',...
                  'BackgroundColor', viewerBackgroundColor('get'), ...
                  'ForegroundColor', viewerForegroundColor('get'), ...                   
                  'position', [20 262 150 20]...
                  );   

    edtSeriesDate = ...
      uicontrol(dlgInformation,...
                'style'     , 'edit',...
                'Background', 'white',...
                'string'    , sSeriesDate,...
                'BackgroundColor', viewerBackgroundColor('get'), ...
                'ForegroundColor', viewerForegroundColor('get'), ...                 
                'position'  , [200 265 160 20]...
                );              

        uicontrol(dlgInformation,...
                  'style'   , 'text',...
                  'string'  , 'Callibration Time (hhMMss)',...
                  'horizontalalignment', 'left',...
                  'BackgroundColor', viewerBackgroundColor('get'), ...
                  'ForegroundColor', viewerForegroundColor('get'), ...                   
                  'position', [20 237 150 20]...
                  );   

    edtSeriesTime = ...
      uicontrol(dlgInformation,...
                'style'     , 'edit',...
                'Background', 'white',...
                'string'    , sSeriesTime,...
                'BackgroundColor', viewerBackgroundColor('get'), ...
                'ForegroundColor', viewerForegroundColor('get'), ...                 
                'position'  , [200 240 160 20]...
                ); 

        uicontrol(dlgInformation,...
                  'style'   , 'text',...
                  'string'  , 'Infusion Date (yyyyMMdd)',...
                  'horizontalalignment', 'left',...
                  'BackgroundColor', viewerBackgroundColor('get'), ...
                  'ForegroundColor', viewerForegroundColor('get'), ...                   
                  'position', [20 187 150 20]...
                  );   

    % Radiopharmaceutical Date \ Time

    edtRadiopharmaceuticalStartDate = ...
      uicontrol(dlgInformation,...
                'style'     , 'edit',...
                'Background', 'white',...
                'string'    , sRadiopharmaceuticalStartDate,...
                'BackgroundColor', viewerBackgroundColor('get'), ...
                'ForegroundColor', viewerForegroundColor('get'), ...                 
                'position'  , [200 190 160 20]...
                );              

        uicontrol(dlgInformation,...
                  'style'   , 'text',...
                  'string'  , 'Infusion Time (hhMMss)',...
                  'horizontalalignment', 'left',...
                  'BackgroundColor', viewerBackgroundColor('get'), ...
                  'ForegroundColor', viewerForegroundColor('get'), ...                   
                  'position', [20 162 150 20]...
                  );   

    edtRadiopharmaceuticalStartTime = ...
      uicontrol(dlgInformation,...
                'style'     , 'edit',...
                'Background', 'white',...
                'string'    , sRadiopharmaceuticalStartTime,...
                'BackgroundColor', viewerBackgroundColor('get'), ...
                'ForegroundColor', viewerForegroundColor('get'), ...                 
                'position'  , [200 165 160 20]...
                );

        uicontrol(dlgInformation,...
                  'style'   , 'text',...
                  'string'  , 'Radionuclide Half Life',...
                  'horizontalalignment', 'left',...
                  'BackgroundColor', viewerBackgroundColor('get'), ...
                  'ForegroundColor', viewerForegroundColor('get'), ...                   
                  'position', [20 112 150 20]...
                  );   

    % Radiopharmaceutical Half Life

    edtRadionuclideHalfLife = ...
      uicontrol(dlgInformation,...
                'style'     , 'edit',...
                'Background', 'white',...
                'string'    , sRadionuclideHalfLife,...
                'BackgroundColor', viewerBackgroundColor('get'), ...
                'ForegroundColor', viewerForegroundColor('get'), ...                 
                'position'  , [200 115 160 20]...
                );


        uicontrol(dlgInformation,...
                  'style'   , 'text',...
                  'string'  , 'Radiopharmaceutical',...
                  'horizontalalignment', 'left',...
                  'BackgroundColor', viewerBackgroundColor('get'), ...
                  'ForegroundColor', viewerForegroundColor('get'), ...                   
                  'position', [20 62 150 20]...
                  );    

    % Radiopharmaceutical Type

    popTreatmentType = ...
        uicontrol(dlgInformation, ...
                  'enable'  , 'on',...
                  'Style'   , 'popup', ...
                  'position', [200 65 160 20],...
                  'String'  , {'TheraSphere', 'SIRshpere'}, ...
                  'BackgroundColor', viewerBackgroundColor('get'), ...
                  'ForegroundColor', viewerForegroundColor('get'), ...                    
                  'Value'   , treatmentTypeDoseInformationDialog('get') ...
                  );

    % Continue or Apply

    uiCancelSetRadiopharmaceuticalInformation = ...
      uicontrol(dlgInformation,...
               'String','Cancel',...
               'Position',[285 7 75 25],...
               'BackgroundColor', viewerBackgroundColor('get'), ...
               'ForegroundColor', viewerForegroundColor('get'), ...                
               'Callback', @cancelSetRadiopharmaceuticalInformationCallback...
               );

     uicontrol(dlgInformation,...
              'String','Continue',...
              'Position',[200 7 75 25],...
              'BackgroundColor', viewerBackgroundColor('get'), ...
              'ForegroundColor', viewerForegroundColor('get'), ...               
              'Callback', @continueSetRadiopharmaceuticalInformationCallback...
              );             

    waitfor(uiCancelSetRadiopharmaceuticalInformation); 

    function isSameSpacingDoseInformationCallback(hObject, ~)      

        if get(chkIsSamePixelSpacing, 'Value') == 1
           if strcmpi(hObject.Style, 'checkbox')
                set(chkIsSamePixelSpacing, 'Value', 1);
            else
                set(chkIsSamePixelSpacing, 'Value', 0);
           end            
        else
           if strcmpi(hObject.Style, 'checkbox')
                set(chkIsSamePixelSpacing, 'Value', 0);
            else
                set(chkIsSamePixelSpacing, 'Value', 1);
           end  
        end                               

        if get(chkIsSamePixelSpacing, 'Value') == false

            atMetaData = dicomMetaData('get');

            set(edtPixelSpacingY, 'enable', 'on');
            set(edtPixelSpacingZ, 'enable', 'on');

            set(edtPixelSpacingY, 'String', num2str(atMetaData{1}.PixelSpacing(2)) );
            set(edtPixelSpacingZ, 'String', num2str(computeSliceSpacing(atMetaData)) );     

            if get(chkResizePixelSize, 'Value') == 1
                set(edtResizePixelSpacingX, 'enable', 'on');                
                set(edtResizePixelSpacingY, 'enable', 'on');
                set(edtResizePixelSpacingZ, 'enable', 'on');                 
            else
                set(edtResizePixelSpacingX, 'enable', 'off');                
                set(edtResizePixelSpacingY, 'enable', 'off');
                set(edtResizePixelSpacingZ, 'enable', 'off');                     
            end

            if get(chkResizePixelSize, 'Value') == true

                set(edtResizePixelSpacingY, 'String', num2str(resizeVoxelDoseInformationDialog('get', 'y')) );
                set(edtResizePixelSpacingZ, 'String', num2str(resizeVoxelDoseInformationDialog('get', 'Z')) );                 
            end
        else                  

            set(edtPixelSpacingY, 'enable', 'off');
            set(edtPixelSpacingZ, 'enable', 'off');

            set(edtPixelSpacingY, 'String', get(edtPixelSpacingX, 'String'));
            set(edtPixelSpacingZ, 'String', get(edtPixelSpacingX, 'String')); 

            set(edtResizePixelSpacingY, 'enable', 'off');
            set(edtResizePixelSpacingZ, 'enable', 'off');   

            if get(chkResizePixelSize, 'Value') == true

                set(edtResizePixelSpacingY, 'String', get(edtResizePixelSpacingX, 'String'));
                set(edtResizePixelSpacingZ, 'String', get(edtResizePixelSpacingX, 'String'));                 
            end
        end       

    end % isSameSpacingDoseInformationCallback()

    function edtPixelSpacingDoseInformationCallback(hObject, ~)

        if get(chkIsSamePixelSpacing, 'Value') == true

            sXPixelValue = get(hObject, 'String');
            set(edtPixelSpacingY, 'String', sXPixelValue);
            set(edtPixelSpacingZ, 'String', sXPixelValue);
        end

    end % edtPixelSpacingDoseInformationCallback()

    function edtResizePixelSpacingDoseInformationCallback(hObject, ~)

        if get(chkIsSamePixelSpacing, 'Value') == true

            sXPixelValue = get(hObject, 'String');
            set(edtResizePixelSpacingY, 'String', sXPixelValue);
            set(edtResizePixelSpacingZ, 'String', sXPixelValue);
        end            
    end % edtResizePixelSpacingDoseInformationCallback()

    function resizePixelSizeDoseInformationCallback(hObject, ~)      

        if get(chkResizePixelSize, 'Value') == 1
           if strcmpi(hObject.Style, 'checkbox')
                set(chkResizePixelSize, 'Value', 1);
            else
                set(chkResizePixelSize, 'Value', 0);
           end            
        else
           if strcmpi(hObject.Style, 'checkbox')
                set(chkResizePixelSize, 'Value', 0);
            else
                set(chkResizePixelSize, 'Value', 1);
           end  
        end       

        if get(chkResizePixelSize, 'Value') == false
             set(edtResizePixelSpacingX, 'enable', 'off');                
             set(edtResizePixelSpacingY, 'enable', 'off');
             set(edtResizePixelSpacingZ, 'enable', 'off');                 
        else
            if get(chkIsSamePixelSpacing, 'Value') == false
                set(edtResizePixelSpacingX, 'enable', 'on');                
                set(edtResizePixelSpacingY, 'enable', 'on');
                set(edtResizePixelSpacingZ, 'enable', 'on');    
            else
                set(edtResizePixelSpacingX, 'enable', 'on');                
                set(edtResizePixelSpacingY, 'enable', 'off');
                set(edtResizePixelSpacingZ, 'enable', 'off')                    
            end
        end

    end % resizePixelSizeDoseInformationCallback()                       

    function cancelSetRadiopharmaceuticalInformationCallback(~, ~)

        delete(dlgInformation);

    end % cancelSetRadiopharmaceuticalInformationCallback()

    function continueSetRadiopharmaceuticalInformationCallback(~, ~)

        isSameSpacingDoseInformationDialog('set', get(chkIsSamePixelSpacing, 'Value'));

        resizePixelSizeDoseInformationDialog('set', get(chkResizePixelSize, 'Value'));            

        treatmentTypeDoseInformationDialog('set', get(popTreatmentType, 'Value'));

        resizeVoxelDoseInformationDialog('set', 'x', str2double(get(edtResizePixelSpacingX, 'String')) );
        resizeVoxelDoseInformationDialog('set', 'y', str2double(get(edtResizePixelSpacingY, 'String')) );
        resizeVoxelDoseInformationDialog('set', 'z', str2double(get(edtResizePixelSpacingZ, 'String')) );

        microspereVolumeDoseInformationDialog('set', str2double(get(edtMicrosphereVolume, 'String')) );

        % Set Series Date\Time

        sSeriesDate = get(edtSeriesDate, 'String');
        sSeriesTime = get(edtSeriesTime, 'String');

        % Set Radiopharmaceutical Date\Time

        sRadiopharmaceuticalStartDate = get(edtRadiopharmaceuticalStartDate, 'String');
        sRadiopharmaceuticalStartTime = get(edtRadiopharmaceuticalStartTime, 'String');            

        % Set Radionuclide Half Life

        sRadionuclideHalfLife = get(edtRadionuclideHalfLife, 'String');

        % Set Treatment Type

        asTreatmentType = get(popTreatmentType, 'String');
        dTreatmentType  = get(popTreatmentType, 'Value');            

        sRadiopharmaceutical = asTreatmentType{dTreatmentType};

        % Set X-Y-Z Pixel Size

        if get(chkIsSamePixelSpacing, 'Value') == true
            dPixelSpacingX = str2double(get(edtPixelSpacingX, 'String'));
            dPixelSpacingY = dPixelSpacingX;
            dPixelSpacingZ = dPixelSpacingX;                    
        else
            dPixelSpacingX = str2double(get(edtPixelSpacingX, 'String'));
            dPixelSpacingY = str2double(get(edtPixelSpacingY, 'String'));
            dPixelSpacingZ = str2double(get(edtPixelSpacingZ, 'String'));                      
        end

        if get(chkIsSamePixelSpacing, 'Value') == true
            dResizePixelSpacingX = str2double(get(edtResizePixelSpacingX, 'String'));
            dResizePixelSpacingY = dResizePixelSpacingX;
            dResizePixelSpacingZ = dResizePixelSpacingX;                    
        else
            dResizePixelSpacingX = str2double(get(edtResizePixelSpacingX, 'String'));
            dResizePixelSpacingY = str2double(get(edtResizePixelSpacingY, 'String'));
            dResizePixelSpacingZ = str2double(get(edtResizePixelSpacingZ, 'String'));                      
        end        
        
%            aspectRatioValue('set', 'x', dPixelSpacingX);
%            aspectRatioValue('set', 'y', dPixelSpacingY);
%            aspectRatioValue('set', 'z', dPixelSpacingZ);

        tInformation.dPixelSpacingX       = dPixelSpacingX;     
        tInformation.dPixelSpacingY       = dPixelSpacingY;          
        tInformation.dPixelSpacingZ       = dPixelSpacingZ;      
        tInformation.bResizePixelSize     = get(chkResizePixelSize, 'Value');            
        tInformation.dResizePixelSpacingX = dResizePixelSpacingX;            
        tInformation.dResizePixelSpacingY = dResizePixelSpacingY;            
        tInformation.dResizePixelSpacingZ = dResizePixelSpacingZ;            
        tInformation.dMicrosphereVolume   = str2double(get(edtMicrosphereVolume, 'String'));            
        tInformation.sCallibrationDate    = sSeriesDate;
        tInformation.sCallibrationTime    = sSeriesTime;
        tInformation.sInfusionDate        = sRadiopharmaceuticalStartDate;
        tInformation.sInfusionTime        = sRadiopharmaceuticalStartTime;            
        tInformation.sHalfLife            = sRadionuclideHalfLife;            
        tInformation.sTreatmentType       = sRadiopharmaceutical;                        

        % Close and exit dialog function

        cancelSetRadiopharmaceuticalInformationCallback(); 

    end

end