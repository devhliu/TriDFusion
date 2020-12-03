function resize = dicomViewer()
%function resize = dicomViewer()
%Dicom Viewer Main Function.
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

    resize = @resizeFigure;

    aspectRatio     ('set', true);
    isShading       ('set', true); 
    gateUseSeriesUID('set', true);
    gateLookupTable ('set', true);
    gateLookupType  ('set', 'Relative');
    vSplahView      ('set', 'Axial');

    imageOrientation('set', 'axial'); 

    fusionWindowLevel('set', 'max', 0);
    fusionWindowLevel('set', 'min', 0);

    fusionSliderLevel('set', 'max', 0);
    fusionSliderLevel('set', 'min', 0);

    windowLevel('set', 'max', 0);
    windowLevel('set', 'min', 0);

    flipHeadFeet ('set', false);
    flipAntPost  ('set', false);
    flipLeftRight('set', false);

    imageSegTreshValue('set', 'lower', 0);
    imageSegTreshValue('set', 'upper', 1);
    lungSegTreshValue ('set', 0.5       );

    crossSize       ('set', 10      );
    crossColor      ('set', 'Cyan'  );
    crossActivate   ('set',  true   );
    overlayActivate ('set',  true   );
    overlayColor    ('set', 'black' );
    windowButton    ('set', 'up'    );
    invertColor     ('set', true    );    
    backgroundColor ('set', 'white' );
    background3DOffset('set', 7     ); % white
    colorMapOffset  ('set', 10      );  
    fusionColorMapOffset('set', 19  );         
    volLinearAlphaValue('set', 1    );
    volLinearFusionAlphaValue('set', 1);
    getVolAlphaMap      ('set', '', 'auto');
    getVolFusionAlphaMap('set', '', 'auto');
    colorMapVolOffset('set', 21     ); % angio
    colorMapVolFusionOffset('set', 21);% angio
    colorMapMipOffset('set', 10     ); % gray
    colorMapMipFusionOffset('set', 10);% gray
    mipLinearAlphaValue('set', 1    );
    mipLinearFuisonAlphaValue('set', 1);
    getMipAlphaMap      ('set', '', 'auto');
    getMipFusionAlphaMap('set', '', 'auto');
    
    isoColorOffset        ('set', 4  ); % red
    isoSurfaceValue       ('set', 0.1);
    isoColorFusionOffset  ('set', 4  ); % red
    isoSurfaceFusionValue ('set', 1  );
        
    volLighting           ('set', true);
    volFusionLighting     ('set', true);
    
    %       surfaceAlpha    ('set', 1       );  
    sliderWindowLevelValue('set', 'max', 0.5);
    sliderWindowLevelValue('set', 'min', 0.5);  
    sliderFusionWindowLevelValue('set', 'max', 0.5);
    sliderFusionWindowLevelValue('set', 'min', 0.5);  
    sliderAlphaValue('set', 0.5);

    vSplashLayout('set', 'x', 5     );  
    vSplashLayout('set', 'y', 3     );  

    addOnWidth       ('set', 0       );        
    zoomTool         ('set', false   );
    rotate3DTool     ('set', false   );        
    dataCursorTool   ('set', false   );        
    panTool          ('set', false   );
    editPlot         ('set', false   );
    editToolbar      ('set', false   ); 
    camToolbar       ('set', false   ); 
    playback3DToolbar('set', false  );
    roiToolbar       ('set', false   );

    multiFrameSpeed   ('set', 0.1   );
    multiFramePlayback('set', false );
    multiFrameRecord  ('set', false );
    multiFrameZoom    ('set', 'in' , 1);
    multiFrameZoom    ('set', 'out', 1);
    multiFrameZoom    ('set', 'axe', []);

    multiFrame3DSpeed   ('set', 0.05 );
    multiFrame3DIndex   ('set', 1    );
    multiFrame3DPlayback('set', false);
    multiFrame3DRecord  ('set', false);
    multiFrame3DZoom    ('set', 0    );

    gaussFilterValue('set', 'x', 0.1 );
    gaussFilterValue('set', 'y', 0.1 );
    gaussFilterValue('set', 'z', 1   );

    displayVoi('set', false);

    displayVolColorMap('set', false  );
    displayMIPColorMap('set', false  );

    switchTo3DMode    ('set', false  );
    switchToIsoSurface('set', false  );
    switchToMIPMode   ('set', false  );

    initWindowLevel ('set', true     );        
    initFusionWindowLevel('set', true); 

    suvMenuUnitOption('set', true);
    segMenuOption    ('set', true);  

    registrationTemplate('init');
    registrationReport('set', '');

    updateDescription('set', true);

    clearDisplay();

    uiTopWindow = ...
        uipanel(fiMainWindowPtr('get'),...
                'Units'   , 'pixels',...
                'position', [0 ...
                             getMainWindowSize('ysize')-40 ...
                             getMainWindowSize('xsize') ...
                             40 ...
                             ]...
               );           
     uiTopWindowPtr('set', uiTopWindow);

     uiSegMainPanel = ...
        uipanel(fiMainWindowPtr('get'),...
                'Units'   , 'pixels',...
                'position', [0 ...
                             addOnWidth('get')+30 ...
                            300 ...
                            getMainWindowSize('ysize')-getTopWindowSize('ysize')-addOnWidth('get')-30 ...
                            ],...
                'Visible', 'off'...
                ); 
     uiSegMainPanelPtr('set', uiSegMainPanel);

     uiSegPanel = ...
         uipanel(uiSegMainPanelPtr('get'),...
                 'Units'   , 'pixels',...
                 'position', [0 ...
                              0 ...
                              280 ...
                              2000 ...
                              ],...
                'Visible', 'off'...
                ); 
    uiSegPanelPtr('set', uiSegPanel);

    aSegMainPanelPosition = get(uiSegMainPanelPtr('get'), 'position');   
    uiSegPanelSlider = ...
        uicontrol('Style'   , 'Slider', ...
                  'Parent'  , uiSegMainPanelPtr('get'),...
                  'Units'   , 'pixels',...
                  'position', [280 ...
                               0 ...
                               20 ...
                               aSegMainPanelPosition(4) ...
                               ],...
                  'Value', 0, ...
                  'Callback',@uiSegPanelSliderCallback ...
                  );
    uiSegPanelSliderPtr('set', uiSegPanelSlider);
    addlistener(uiSegPanelSlider, 'Value', 'PreSet', @uiSegPanelSliderCallback);  

    initSegPanel(); 

    uiKernelMainPanel = ...
        uipanel(fiMainWindowPtr('get'),...
                'Units'   , 'pixels',...
                'position', [0 ...
                             addOnWidth('get')+30 ...
                             300 ...
                             getMainWindowSize('ysize')-getTopWindowSize('ysize')-addOnWidth('get')-30 ...
                             ],...
                'Visible', 'off'...
                );    
    uiKernelMainPanelPtr('set', uiKernelMainPanel);

    uiKernelPanel = ...
        uipanel(uiKernelMainPanelPtr('get'),...
                'Units'   , 'pixels',...
                'position', [0 ...
                             0 ...
                             280 ...
                             2000 ...
                             ],...
                'Visible', 'on'...
                ); 
    uiKernelPanelPtr('set', uiKernelPanel);

    aKernelMainPanelPosition = get(uiKernelMainPanelPtr('get'), 'position');   
    uiKernelPanelSlider = ...
        uicontrol('Style'   , 'Slider', ...
                  'Parent'  , uiKernelMainPanelPtr('get'),...
                  'Units'   , 'pixels',...
                  'position', [280 ...
                               0 ...
                               20 ...
                               aKernelMainPanelPosition(4) ...
                               ],...
                  'Value'   , 0, ...
                  'Callback',@uiKernelPanelSliderCallback ...
                  );
    uiKernelPanelSliderPtr('set', uiKernelPanelSlider);                                             
    addlistener(uiKernelPanelSlider, 'Value', 'PreSet', @uiKernelPanelSliderCallback);  

    initKernelPanel();        

    if size(dicomBuffer('get'), 3) == 1
        if switchTo3DMode('get')     == true || ...
           switchToIsoSurface('get') == true || ...
           switchToMIPMode('get')    == true

                uiOneWindow = ...
                    uipanel(fiMainWindowPtr('get'),...
                            'Units'   , 'pixels',...
                            'BorderWidth', showBorder('get'),...
                            'HighlightColor', [0 1 1],...
                            'BackgroundColor', surfaceColor('get', background3DOffset('get')),...
                            'position', [680 ...
                                         addOnWidth('get')+30 ...
                                         getMainWindowSize('xsize')-680 ...
                                         getMainWindowSize('ysize')-getTopWindowSize('ysize')-addOnWidth('get')-30 ...
                                         ]...
                            );      
                  uiOneWindowPtr('set', uiOneWindow);

                  uiMain3DPanel = ...
                      uipanel(fiMainWindowPtr('get'),...
                              'Units'   , 'pixels',...
                              'position', [0 ...
                                           addOnWidth('get')+30 ...
                                           680 ...
                                           getMainWindowSize('ysize')-getTopWindowSize('ysize')-addOnWidth('get')-30 ...
                                           ]...
                              ); 
                  uiMain3DPanelPtr('set', uiMain3DPanel);

                  ui3DPanel = ...
                      uipanel(uiMain3DPanelPtr('get'),...
                              'Units'   , 'pixels',...
                              'position', [0 ...
                                           0 ...
                                           660 ...
                                           2000 ...
                                           ]...
                              );
                   ui3DPanelPtr('set', ui3DPanel);

                  aMain3DPanelPosition = get(uiMain3DPanelPtr('get'), 'position');
                  ui3DPanelSlider = ...
                      uicontrol('Style'   , 'Slider', ...
                                'Parent'  , uiMain3DPanelPtr('get'),...
                                'Units'   , 'pixels',...
                                'position', [660 ...
                                             0 ...
                                             20 ...
                                             aMain3DPanelPosition(4) ...
                                             ],...
                                'Value', 0, ...
                                'Callback', @ui3DPanelSliderCallback ...
                                );
                  ui3DPanelSliderPtr('set', ui3DPanelSlider);          
                  addlistener(ui3DPanelSlider,'Value','PreSet', @ui3DPanelSliderCallback);                     
         else                
            uiOneWindow = ...
                uipanel(fiMainWindowPtr('get'),...
                        'Units'          , 'pixels',...
                        'BorderWidth'    , showBorder('get'),...
                        'HighlightColor' , [0 1 1],...
                        'BackgroundColor', backgroundColor('get'),...
                        'position'       , [0 ...
                                            addOnWidth('get')+30 ...
                                            getMainWindowSize('xsize') ...
                                            getMainWindowSize('ysize')-getTopWindowSize('ysize')-addOnWidth('get')-30 ...
                                            ]...
                        );    
            uiOneWindowPtr('set', uiOneWindow);

        end               
    else        

        uiCorWindow = ...
            uipanel(fiMainWindowPtr('get'),...
                    'Units'          , 'pixels',...
                    'BorderWidth'    , showBorder('get'),...
                    'HighlightColor' , [0 1 1],...
                    'BackgroundColor', backgroundColor('get'),...
                    'position'       , [0 ...
                                        addOnWidth('get')+30 ...
                                        getMainWindowSize('xsize')/4 ...
                                        getMainWindowSize('ysize')-getTopWindowSize('ysize')-addOnWidth('get')-30-15 ...
                                        ]...
                    );                       
          uiCorWindowPtr('set', uiCorWindow);

          uiSliderCor = ...
              uicontrol(fiMainWindowPtr('get'), ...
                        'Style'   , 'Slider', ...
                        'Position', [0 ...
                                     addOnWidth('get')+30 ...
                                     getMainWindowSize('xsize')/4 ...
                                     15 ...
                                     ], ...
                        'Value'   , 0.5, ...
                        'Enable'  , 'on', ...
                        'CallBack', @sliderCorCallback ...
                        );   
          uiSliderCorPtr('set', uiSliderCor);
          addlistener(uiSliderCor, 'Value', 'PreSet', @sliderCorCallback);                 

          uiSagWindow = ...
              uipanel(fiMainWindowPtr('get'),...
                      'Units'          , 'pixels',...
                      'BorderWidth'    , showBorder('get'),...
                      'HighlightColor' , [0 1 1],...
                      'BackgroundColor', backgroundColor('get'),...
                      'position', [getMainWindowSize('xsize')/4 ...
                                   addOnWidth('get')+30+15 ...
                                   getMainWindowSize('xsize')/4 ... 
                                   getMainWindowSize('ysize')-getTopWindowSize('ysize')-addOnWidth('get')-30-15 ...
                                   ]...
                      );  
         uiSagWindowPtr('set', uiSagWindow);

         uiSliderSag = ...
             uicontrol(fiMainWindowPtr('get'), ...
                       'Style'   , 'Slider', ...
                       'Position', [(getMainWindowSize('xsize')/4) ...
                                    addOnWidth('get')+30 ...
                                    getMainWindowSize('xsize')/4 ...
                                    15 ...
                                    ], ...
                       'Value'   , 0.5, ...
                       'Enable'  , 'on', ...
                       'CallBack', @sliderSagCallback ...
                       );    
         uiSliderSagPtr('set', uiSliderSag);
         addlistener(uiSliderSag,'Value','PreSet',@sliderSagCallback);                 

         uiTraWindow = ...
             uipanel(fiMainWindowPtr('get'),...
                     'Units'          , 'pixels',...
                     'BorderWidth'    , showBorder('get'),...
                     'HighlightColor' , [0 1 1],...
                     'BackgroundColor', backgroundColor('get'),...
                     'position'       , [(getMainWindowSize('xsize')/2) ...
                                         addOnWidth('get')+30+15 ...
                                         getMainWindowSize('xsize')/2 ...
                                         getMainWindowSize('ysize')-getTopWindowSize('ysize')-addOnWidth('get')-30-15 ...
                                         ]...
                     );     
        uiTraWindowPtr('set', uiTraWindow);

        uiSliderTra = ...
            uicontrol(fiMainWindowPtr('get'), ...
                      'Style'   , 'Slider', ...
                      'Position', [(getMainWindowSize('xsize')/2) ...
                                   addOnWidth('get')+30 ...
                                   getMainWindowSize('xsize')/2 ...
                                   15 ...
                                   ], ...
                      'Value'   , 0.5, ...
                      'Enable'  , 'on', ...
                      'CallBack', @sliderTraCallback ...
                      );  
        uiSliderTraPtr('set', uiSliderTra);
        addlistener(uiSliderTra, 'Value', 'PreSet', @sliderTraCallback);                 
    end       

    %        uiAddOnWindow =  uipanel(fiMainWindowPtr('get'),...
    %                              'Units'   , 'pixels',...
    %                              'position', [0 ...
    %                                           30 ...
    %                                           getMainWindowSize('xsize') ...
    %                                           addOnWidth('get')]...
    %                               );                      

     mainWindowMenu();

     if numel(inputTemplate('get'))
        sSeriesEnable = 'on';
     else
        sSeriesEnable = 'off';
     end

     uiSeries = ...
         uicontrol(uiTopWindowPtr('get'), ...
                   'Style'   , 'popup', ...
                   'Position', [5 7 270 25], ...
                   'String'  , seriesDescription('get'), ...
                   'Value'   , 1,...
                   'Enable'  , sSeriesEnable, ...
                   'Callback', @setSeriesCallback ...  
                   );   
     uiSeriesPtr('set', uiSeries);

     btn3D = ...
         uicontrol(uiTopWindowPtr('get'),...
                   'Position', [285 8 65 25],...
                   'String'  , 'Volume',...
                   'Callback', @set3DCallback...
                   );   
     btn3DPtr('set', btn3D);    

     btnIsoSurface = ...
         uicontrol(uiTopWindowPtr('get'),...
                   'Position', [351 8 65 25],...
                   'String'  , 'ISO',...
                   'Callback', @setIsoSurfaceCallback...
                   );  
     btnIsoSurfacePtr('set', btnIsoSurface);

     btnMIP = ...
         uicontrol(uiTopWindowPtr('get'),...
                   'Position', [417 8 65 25],...
                   'String'  , 'MIP',...
                   'Callback', @setMIPCallback...
                   ); 
     btnMIPPtr('set', btnMIP);

     if numel(inputTemplate('get')) 
        sBackgroundColor = 'white';
     else
        sBackgroundColor = 'default';
     end

     btnTriangulate = ...
         uicontrol(uiTopWindowPtr('get'), ...
                   'Position'       , [492 8 65 25], ...
                   'String'         , 'Triangul...',...
                   'BackgroundColor', sBackgroundColor, ...
                   'Callback'       , @triangulateCallback...
                   ); 
     btnTriangulatePtr('set', btnTriangulate);

     btnPan = ...
         uicontrol(uiTopWindowPtr('get'), ...
                   'Position', [558 8 65 25], ...
                   'String'  , 'Pan',...
                   'Callback', @setPanCallback...
                   ); 
     btnPanPtr('set', btnPan);

     btnZoom = uicontrol(uiTopWindowPtr('get'), ...
                          'Position', [624 8 65 25], ...
                          'String'  , 'Zoom',...
                          'Callback', @setZoomCallback...
                          ); 
    btnZoomPtr('set', btnZoom);

    if numel(seriesDescription('get')) > 1               
        sRegisterEnable = 'on';
    else
        sRegisterEnable = 'off';
    end

    btnRegister = uicontrol(uiTopWindowPtr('get'), ...
                          'Position', [699 8 75 25], ...
                          'Enable'  , sRegisterEnable, ...
                          'String'  , 'Register',...
                          'Callback', @setRegistrationCallback...
                          );      
    btnRegisterPtr('set', btnRegister);

    if size(dicomBuffer('get'), 3) == 1 || ...
       ~numel(dicomBuffer('get')) 
        sVsplashEnable = 'off';
    else
        sVsplashEnable = 'on';
    end

     btnVsplash = uicontrol(uiTopWindowPtr('get'), ...
                          'Position', [784 8 65 25], ...
                          'Enable'  , sVsplashEnable, ...
                          'String'  , 'V-Splash',...
                          'Callback', @setVsplashCallback...
                          ); 
    btnVsplashPtr('set', btnVsplash);

    uiEditVsplahX = ...
        uicontrol(uiTopWindowPtr('get'), ...
                  'Style'   , 'Edit', ...
                  'Position', [851 8 25 25], ...
                  'String'  , num2str(vSplashLayout('get', 'x')), ...
                  'Enable'  , sVsplashEnable, ...
                  'CallBack', @setVsplashLayoutCallback ...
                  );
    uiEditVsplahXPtr('set', uiEditVsplahX);

    uiEditVsplahY = ...
        uicontrol(uiTopWindowPtr('get'), ...
                  'Style'   , 'Edit', ...
                  'Position', [877 8 25 25], ...
                  'String'  , num2str(vSplashLayout('get', 'y')), ...
                  'Enable'  , sVsplashEnable, ...
                  'CallBack', @setVsplashLayoutCallback ...
                  );
    uiEditVsplahYPtr('set', uiEditVsplahY);

    if numel(seriesDescription('get')) > 1               
        sFusionEnable      = 'on';
        sFusionDescription = seriesDescription('get');
        dFusionValue       = 2;
    else
        sFusionEnable      = 'off';
        sFusionDescription = ' ';
        dFusionValue       = 1;
    end

     btnFusion = ...
         uicontrol(uiTopWindowPtr('get'), ...
                   'Position', [912 8 65 25], ...
                   'Enable'  , sFusionEnable, ...
                   'String'  , 'Fusion',...
                   'Callback', @setFusionCallback...
                   ); 
     btnFusionPtr('set', btnFusion);

     uiFusedSeries = ...
         uicontrol(uiTopWindowPtr('get'), ...
                  'Style'   , 'popup', ...
                  'Position', [978 7 270 25], ...
                  'String'  , sFusionDescription, ...
                  'Value'   , dFusionValue,...
                  'Enable'  , sFusionEnable, ...
                  'Callback', @setFusionSeriesCallback...
                  );                           
     uiFusedSeriesPtr('set', uiFusedSeries);

    if size(dicomBuffer('get'), 3) == 1
        axef = ...
            axes(uiOneWindowPtr('get'), ...
                 'Units'   , 'normalized', ...
                 'Position', [0 0 1 1], ... 
                 'Visible' , 'off'...
                 );  
        axefPtr('set', axef);

        axe = ...
            axes(uiOneWindowPtr('get'), ...
                 'Units'   , 'normalized', ...
                 'Position', [0 0 1 1], ... 
                 'Visible' , 'off'...
                 );  
        axePtr('set', axe);
    else    
       axes1f = ...
           axes(uiCorWindowPtr('get'), ...
                'Units'   , 'normalized', ...
                'xlimmode','manual',...
                'ylimmode','manual',...
                'zlimmode','manual',...
                'climmode','manual',...
                'alimmode','manual',...                              
                'Position', [0 0 1 1], ...
                'color','none',...
                'Visible' , 'off'...
                );  
       axes1fPtr('set', axes1f);         

       axes1 = ...
           axes(uiCorWindowPtr('get'), ...
                'Units'   , 'normalized', ...
                'xlimmode', 'manual',...
                'ylimmode', 'manual',...
                'zlimmode', 'manual',...
                'climmode', 'manual',...
                'alimmode', 'manual',...                           
                'Position', [0 0 1 1], ... 
                'Visible' , 'off'...
                );  
       axes1Ptr('set', axes1);         

       axes2f = ...
           axes(uiSagWindowPtr('get'), ...
                'Units'   , 'normalized', ...
                'xlimmode','manual',...
                'ylimmode','manual',...
                'zlimmode','manual',...
                'climmode','manual',...
                'alimmode','manual',...                              
                'Position', [0 0 1 1], ...
                'color','none',...
                'Visible' , 'off'...
                );  
       axes2fPtr('set', axes2f);         

       axes2 = ...
           axes(uiSagWindowPtr('get'), ...
                'Units'   , 'normalized', ...
                'xlimmode', 'manual',...
                'ylimmode', 'manual',...
                'zlimmode', 'manual',...
                'climmode', 'manual',...
                'alimmode', 'manual',...   
                'Position', [0 0 1 1], ...
                'Visible' , 'off'...
               );
       axes2Ptr('set', axes2);         

       axes3f = ...
           axes(uiTraWindowPtr('get'), ...
                'Units'   , 'normalized', ...
                'xlimmode','manual',...
                'ylimmode','manual',...
                'zlimmode','manual',...
                'climmode','manual',...
                'alimmode','manual',...                              
                'Position', [0 0 1 1], ...
                'color','none',...
                'Visible' , 'off'...
                );  
       axes3fPtr('set', axes3f);         

       axes3 = ...
           axes(uiTraWindowPtr('get'), ...
                'Units'   , 'normalized', ...
                'xlimmode', 'manual',...
                'ylimmode', 'manual',...
                'zlimmode', 'manual',...
                'climmode', 'manual',...
                'alimmode', 'manual',...                           
                'Position', [0 0 1 1], ...
                'Visible' , 'off'...
               );               
       axes3Ptr('set', axes3);         
    end

    if(numel(dicomBuffer('get')))

        clearDisplay();                    
        initDisplay(3); 

        dicomViewerCore();

        setViewerDefaultColor(true, dicomMetaData('get'));

        refreshImages();

        if size(dicomBuffer('get'), 3) ~= 1
            setPlaybackToolbar('on');
        end

        setRoiToolbar('on');

    end
end