function create_help_menu(figure_handle)


%	Check if a help file exists
path=fileparts(which('volume_browser'));
if ~exist(path,'dir')
   alert('Help-file directory has not been found. No help button created.')
   return
end

callback=@help4BV;
menuid = uimenu(figure_handle,'Label',' Need help? ','ForegroundColor','red');

uimenu(menuid,'Label','General','Callback', ...
              {callback,path,figure_handle,'help4VB_general'})
uimenu(menuid,'Label','Explore volume','Callback', ...
              {callback,path,figure_handle,'help4VB_explore'})

uimenu(menuid,'Label',' &About ','Separator','on','enable','on', ...
    'CallBack',{@about_callback,figure_handle});


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function help4BV(varargin)

% path=fileparts(which('volume_browser'));
path=varargin{3};
figure_handle=varargin{4};
funct=varargin{5};

%	Check if a help file exists
hfile=[funct,'.txt'];
filename=fullfile(path,'HelpFiles',hfile);

%	Read help file
try
   help_info=textread(filename,'%s','delimiter','\n');
catch
   alert(['Help file "',hfile,'" has not been found.'])
   return
end

handle=helpdlg(help_info,'Volume Browser Help');

add_handle2delete1(handle,figure_handle)


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function about_callback(varargin)

% global V3D_HANDLES

createmode.Interpreter='tex';
createmode.WindowStyle='modal';
handle=msgbox({...
'Matlab function to vizualize 3D Data; release 1.02';
'Copyright \copyright 2006 2007  Eike Rietsch';
' ';
'This program is free software; you can redistribute it and/or modify it under the terms of the BSD License.'
},createmode);

%	Store handle of message box so that it can be deleted (if it 
%       still exists) upon closing of the browser 

add_handle2delete1(handle,varargin{3})
