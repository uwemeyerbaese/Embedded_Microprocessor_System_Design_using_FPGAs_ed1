%% Script Name: h2v.m
%% Date: 5/2/2019 
%% About this project: This MatLab script converts the pixel font *.h file
%%                    it to Verilog HDL code (MIF tables) for FPGAs
%%                    Char 0x05 (R); Char 0x06 (C); and Char 0x7F (u) have 
%%                    been changed compared to the original font
%% (c) 2019 by Uwe Meyer-Baese 

clear all; close all;
fin='myAPEAUS.h'
fout='char_table_myAPEAUS.mif'
disp('Pick up the first 128x8=1024 hex values from a file')
fin=fopen(fin,'r');
fout=fopen(fout,'w');
line=upper(fgets(fin));
num=0;
while ischar(line) & num < 1024
    L=length(line);
    for k=1:L-4
      if (line(k)=='0') & line(k+1)=='X'
       str=sprintf('%s',dec2bin(hex2dec(line(k+2)),4));
       str=sprintf('%s%s',str,dec2bin(hex2dec(line(k+3)),4));
       %disp(str);
       fprintf(fout,'%s\n',str);
       num = num + 1;
      end
    end
    line=upper(fgets(fin));
end
fclose(fin);fclose(fout);
str=sprintf('Saving = %d x8 binary ',num)

clear all; close all;
fin='myHERCITAL.h'
fout='char_table_myHERCITAL.mif'
disp('Pick up the first 128x8=1024 hex values from a file')
fin=fopen(fin,'r');
fout=fopen(fout,'w');
line=upper(fgets(fin));
num=0;
while ischar(line) & num < 1024
    L=length(line);
    for k=1:L-4
      if (line(k)=='0') & line(k+1)=='X'
       str=sprintf('%s',dec2bin(hex2dec(line(k+2)),4));
       str=sprintf('%s%s',str,dec2bin(hex2dec(line(k+3)),4));
       %disp(str);
       fprintf(fout,'%s\n',str);
       num = num + 1;
      end
    end
    line=upper(fgets(fin));
end
fclose(fin);fclose(fout);
str=sprintf('Saving = %d x8 binary ',num)

clear all; close all;
fin='myHERCULES.h'
fout='char_table_myHERCULES.mif'
disp('Pick up the first 128x8=1024 hex values from a file')
fin=fopen(fin,'r');
fout=fopen(fout,'w');
line=upper(fgets(fin));
num=0;
while ischar(line) & num < 1024
    L=length(line);
    for k=1:L-4
      if (line(k)=='0') & line(k+1)=='X'
       str=sprintf('%s',dec2bin(hex2dec(line(k+2)),4));
       str=sprintf('%s%s',str,dec2bin(hex2dec(line(k+3)),4));
       %disp(str);
       fprintf(fout,'%s\n',str);
       num = num + 1;
      end
    end
    line=upper(fgets(fin));
end
fclose(fin);fclose(fout);
str=sprintf('Saving = %d x8 binary ',num)

clear all; close all;
fin='mySPACE8.h'
fout='char_table_mySPACE8.mif'
disp('Pick up the first 128x8=1024 hex values from a file')
fin=fopen(fin,'r');
fout=fopen(fout,'w');
line=upper(fgets(fin));
num=0;
while ischar(line) & num < 1024
    L=length(line);
    for k=1:L-4
      if (line(k)=='0') & line(k+1)=='X'
       str=sprintf('%s',dec2bin(hex2dec(line(k+2)),4));
       str=sprintf('%s%s',str,dec2bin(hex2dec(line(k+3)),4));
       %disp(str);
       fprintf(fout,'%s\n',str);
       num = num + 1;
      end
    end
    line=upper(fgets(fin));
end
fclose(fin);fclose(fout);
str=sprintf('Saving = %d x8 binary ',num)



