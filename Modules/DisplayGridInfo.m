function handles = DisplayGridInfo(handles)

% Help for the Display Grid Information module:
% Category: Other
%
% SHORT DESCRIPTION:
% Displays text info on grid (i.e. gene names)
% *************************************************************************
%
% This module will display text information in a grid pattern.  It requires
% that you define a grid in an earlier module using the DefineGrid module
% and also load text data using the AddTextData module.  The data need to
% have the same number of entries as there are grid locations (grid
% squares).
%
%
% See also DefineGrid.

% CellProfiler is distributed under the GNU General Public License.
% See the accompanying file LICENSE for details.
%
% Developed by the Whitehead Institute for Biomedical Research.
% Copyright 2003,2004,2005.
%
% Authors:
%   Anne Carpenter
%   Thouis Jones
%   In Han Kang
%   Ola Friman
%   Steve Lowe
%   Joo Han Chang
%   Colin Clarke
%   Mike Lamprecht
%   Susan Ma
%   Wyman Li
%
% Website: http://www.cellprofiler.org
%
% $Revision$

%%%%%%%%%%%%%%%%%
%%% VARIABLES %%%
%%%%%%%%%%%%%%%%%
drawnow

%%% Reads the current module number, because this is needed to find
%%% the variable values that the user entered.
CurrentModule = handles.Current.CurrentModuleNumber;
CurrentModuleNum = str2double(CurrentModule);
ModuleName = char(handles.Settings.ModuleNames(CurrentModuleNum));

%textVAR01 = What is the already defined grid?
%infotypeVAR01 = gridgroup
GridName = char(handles.Settings.VariableValues{CurrentModuleNum,1});
%inputtypeVAR01 = popupmenu

%textVAR02 = What is the first image you would like to display?
%infotypeVAR02 = imagegroup
ImageName = char(handles.Settings.VariableValues{CurrentModuleNum,2});
%inputtypeVAR02 = popupmenu

%textVAR03 = What is the first data set that you would like to display?
%infotypeVAR03 = datagroup
DataName1 = char(handles.Settings.VariableValues{CurrentModuleNum,3});
%inputtypeVAR03 = popupmenu

%textVAR04 = What is the second data set that you would like to display?
%choiceVAR04 = /
%infotypeVAR04 = datagroup
DataName2 = char(handles.Settings.VariableValues{CurrentModuleNum,4});
%inputtypeVAR04 = popupmenu

%textVAR05 = What is the third data set that you would like to display?
%choiceVAR05 = /
%infotypeVAR05 = datagroup
DataName3 = char(handles.Settings.VariableValues{CurrentModuleNum,5});
%inputtypeVAR05 = popupmenu

%%%VariableRevisionNumber = 1

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% PRELIMINARY CALCULATIONS & FILE HANDLING %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
drawnow

%%% Retrieve grid info from previously run module.
GridInfo = handles.Pipeline.(['Grid_' GridName]);
Rows = GridInfo.Rows;
Columns = GridInfo.Columns;
YSpacing = GridInfo.YSpacing;
XSpacing = GridInfo.XSpacing;
VertLinesX = GridInfo.VertLinesX;
VertLinesY = GridInfo.VertLinesY;
HorizLinesX = GridInfo.HorizLinesX;
HorizLinesY = GridInfo.HorizLinesY;
SpotTable = GridInfo.SpotTable;
GridXLocations = GridInfo.GridXLocations;
GridYLocations = GridInfo.GridYLocations;
YLocations = GridInfo.YLocations;
XLocations = GridInfo.XLocations;
LeftOrRight = GridInfo.LeftOrRight;
TopOrBottom = GridInfo.TopOrBottom;

%%%%%%%%%%%%%%%%%%%%%%%
%%% DISPLAY RESULTS %%%
%%%%%%%%%%%%%%%%%%%%%%%
drawnow

fieldname = ['FigureNumberForModule',CurrentModule];
ThisModuleFigureNumber = handles.Current.(fieldname);
%%% Opens a new window. Because the whole purpose of this module is to
%%% display info, the user probably doesn't want to overwrite the
%%% figure after each cycle.
FigHandle = CPfigure(handles,ThisModuleFigureNumber);
ImageHandle = imagesc(handles.Pipeline.(ImageName));
set(ImageHandle,'ButtonDownFcn','ImageTool(gco)');
colormap(handles.Preferences.IntensityColorMap);
title(['Image #', num2str(handles.Current.SetBeingAnalyzed),', with grid info displayed'])
line(VertLinesX,VertLinesY);
line(HorizLinesX,HorizLinesY);
%%% Puts the standard Matlab tool bar back on.
set(FigHandle,'Toolbar','figure');
title(['Image set #', num2str(handles.Current.SetBeingAnalyzed), ' with grid info displayed'],'fontsize',8);
set(findobj(FigHandle,'type','line'),'color',[.15 1 .15])

%%% Sets the location of Tick marks.
set(gca, 'XTick', GridXLocations(1,:)+floor(XSpacing/2))
set(gca, 'YTick', GridYLocations(:,1)+floor(YSpacing/2))

%%% Sets the Tick Labels.
if strcmp(LeftOrRight,'Right')
    set(gca, 'XTickLabel',fliplr(1:Columns))
else
    set(gca, 'XTickLabel',{1:Columns})
end
if strcmp(TopOrBottom,'Bottom')
    set(gca, 'YTickLabel',{fliplr(1:Rows)})
else
    set(gca, 'YTickLabel',{1:Rows})
end

GridLineCallback = [...
    'button = gco;'...
    'if strcmp(get(button,''String''),''Hide Grid''),'...
    'set(button,''String'',''Show Grid'');'...
    'set(get(button,''UserData''),''visible'',''off'');'...
    'else,'...
    'set(button,''String'',''Hide Grid'');'...
    'set(get(button,''UserData''),''visible'',''on'');'...
    'end;'];

uicontrol(FigHandle,...
    'Units','normalized',...
    'Position',[.05 .02 .1 .04],...
    'String','Hide Grid',...
    'BackgroundColor',[.7 .7 .9],...
    'FontSize',10,...
    'UserData',findobj(FigHandle,'type','line'),...
    'Callback',GridLineCallback);

Colors = {'Yellow' 'Magenta' 'Cyan' 'Red' 'Green' 'Blue' 'White' 'Black'};

GridLineColorCallback = [...
    'Colors = get(gcbo,''string'');'...
    'Value = get(gcbo,''value'');'...
    'set(get(gcbo,''UserData''),''color'',Colors{Value});'];

uicontrol(FigHandle,...
    'Units','normalized',...
    'Style','popupmenu',...
    'Position',[.16 .02 .1 .04],...
    'String',Colors,...
    'BackgroundColor',[.7 .7 .9],...
    'FontSize',10,...
    'Value',1,...
    'UserData',findobj(FigHandle,'type','line'),...
    'Callback',GridLineColorCallback);

if ~strcmp(DataName1,'/')
    Text1 = handles.Measurements.(DataName1);
    Description1 = handles.Measurements.([DataName1 'Text']);

    temp=reshape(SpotTable,1,[]);
    tempText = Text1;
    for i=1:length(temp)
        Text1{i} = tempText{temp(i)};
    end

    TextHandles1 = text(XLocations,YLocations+floor(YSpacing/3),Text1,'Color','red');

    ButtonCallback = [...
        'button = gco;'...
        'if strcmp(get(button,''String''),''Hide Text1''),'...
        'set(button,''String'',''Show Text1'');'...
        'set(get(button,''UserData''),''visible'',''off'');'...
        'else,'...
        'set(button,''String'',''Hide Text1'');'...
        'set(get(button,''UserData''),''visible'',''on'');'...
        'end;'];

    uicontrol(FigHandle,...
        'Units','normalized',...
        'Position',[.27 .02 .1 .04],...
        'String','Hide Text1',...
        'BackgroundColor',[.7 .7 .9],...
        'FontSize',10,...
        'UserData',TextHandles1,...
        'Callback',ButtonCallback);

    Text1ColorCallback = [...
        'Colors = get(gcbo,''string'');'...
        'Value = get(gcbo,''value'');'...
        'set(get(gcbo,''UserData''),''color'',Colors{Value});'];

    uicontrol(FigHandle,...
        'Units','normalized',...
        'Style','popupmenu',...
        'Position',[.38 .02 .1 .04],...
        'String',Colors,...
        'BackgroundColor',[.7 .7 .9],...
        'FontSize',10,...
        'Value',4,...
        'UserData',TextHandles1,...
        'Callback',GridLineColorCallback);
end

if ~strcmp(DataName2,'/')
    Text2 = handles.Measurements.(DataName2);
    Description2 = handles.Measurements.([DataName2 'Text']);

    temp=reshape(SpotTable,1,[]);
    tempText = Text2;
    for i=1:length(temp)
        Text2{i} = tempText{temp(i)};
    end

    TextHandles2 = text(XLocations,YLocations+2*floor(YSpacing/3),Text2,'Color','green');

    ButtonCallback = [...
        'button = gco;'...
        'if strcmp(get(button,''String''),''Hide Text2''),'...
        'set(button,''String'',''Show Text2'');'...
        'set(get(button,''UserData''),''visible'',''off'');'...
        'else,'...
        'set(button,''String'',''Hide Text2'');'...
        'set(get(button,''UserData''),''visible'',''on'');'...
        'end;'];


    uicontrol(FigHandle,...
        'Units','normalized',...
        'Position',[.49 .02 .1 .04],...
        'String','Hide Text2',...
        'BackgroundColor',[.7 .7 .9],...
        'FontSize',10,...
        'UserData',TextHandles2,...
        'Callback',ButtonCallback);

    Text2ColorCallback = [...
        'Colors = get(gcbo,''string'');'...
        'Value = get(gcbo,''value'');'...
        'set(get(gcbo,''UserData''),''color'',Colors{Value});'];

    uicontrol(FigHandle,...
        'Units','normalized',...
        'Style','popupmenu',...
        'Position',[.6 .02 .1 .04],...
        'String',Colors,...
        'BackgroundColor',[.7 .7 .9],...
        'FontSize',10,...
        'Value',5,...
        'UserData',TextHandles2,...
        'Callback',GridLineColorCallback);
end

if ~strcmp(DataName3,'/')
    Text3 = handles.Measurements.(DataName3);
    Description3 = handles.Measurements.([DataName3 'Text']);

    temp=reshape(SpotTable,1,[]);
    tempText = Text3;
    for i=1:length(temp)
        Text3{i} = tempText{temp(i)};
    end

    TextHandles3 = text(XLocations,YLocations+YSpacing,Text3,'Color','blue');

    ButtonCallback = [...
        'button = gco;'...
        'if strcmp(get(button,''String''),''Hide Text3''),'...
        'set(button,''String'',''Show Text3'');'...
        'set(get(button,''UserData''),''visible'',''off'');'...
        'else,'...
        'set(button,''String'',''Hide Text3'');'...
        'set(get(button,''UserData''),''visible'',''on'');'...
        'end;'];

    uicontrol(FigHandle,...
        'Units','normalized',...
        'Position',[.71 .02 .1 .04],...
        'String','Hide Text3',...
        'BackgroundColor',[.7 .7 .9],...
        'FontSize',10,...
        'UserData',TextHandles3,...
        'Callback',ButtonCallback);

    Text1ColorCallback = [...
        'Colors = get(gcbo,''string'');'...
        'Value = get(gcbo,''value'');'...
        'set(get(gcbo,''UserData''),''color'',Colors{Value});'];

    uicontrol(FigHandle,...
        'Units','normalized',...
        'Style','popupmenu',...
        'Position',[.82 .02 .1 .04],...
        'String',Colors,...
        'BackgroundColor',[.7 .7 .9],...
        'FontSize',10,...
        'Value',6,...
        'UserData',TextHandles3,...
        'Callback',GridLineColorCallback);
end