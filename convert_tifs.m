
%This script converts files with names in the format
%"untitled000.tif" into another form of .tif that this computer can read
%and puts them in a folder called 'resaved using matlab' inside the same folder the images are in. 

filepath1 = input('Enter the file path for the folder where the images are\n i.e. C:\\Documents and Settings\\chansen3.HISPEEDCASTER\\Desktop\\01202009\\\n', 's');

totalimagenumber= input('What is the highest number in the filename? For example in the file "untitled025.tif?" you would type "25"');

%makes folders
    file_path4=strcat(filepath1,'\resaved using matlab');
    mkdir(file_path4);
file_path5=strcat(filepath1,'\extraneous images');
    mkdir(file_path5);


imagenumber=0;

while imagenumber<=totalimagenumber;
    xx=0;
    while xx==0;
        str_imagenumber=num2str(imagenumber,'%03d');
        file=strcat('untitled',str_imagenumber,'.tif');
        file_path=strcat(filepath1,'\',file);

        % Verify that the file exists.
        fid = fopen(file_path, 'r');
        if (fid == -1)
            if ~isempty(dir(file_path))
                error('MATLAB:imread:fileOpen', ['Can''t open file "%s" for reading;\nyou' ...
                    ' may not have read permission.'], ...
                    file_path);
            else
                imagenumber=imagenumber+1;
            end
        else
            file_path = fopen(fid);
            fclose(fid);
            xx=1;
        end

    end
    I=imread(file_path,'tif');
    I16=immultiply(I,16);
   

    str_newimage=num2str(imagenumber,'%03d');
    file3=strcat('untitled',str_newimage,'.tif');
    file_path3=strcat(file_path4,'\',file3);
    imwrite(I16,file_path3);
    'added image written'
    imagenumber
    imagenumber=imagenumber+1;
end

