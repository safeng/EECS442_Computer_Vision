function [x1, x2] = readTextFiles(path1, path2)

% use this function to read in data from 2D files.
% make sure to change the path depending which set 
% you are using

fileid = fopen(path1,'r');
PointNo = str2num(fgets(fileid));
temp = fscanf(fileid,'%f');
Points1 = zeros(PointNo, 2);
for i = 1 : PointNo
    Points1(i,2) = temp(i*2-1);
    Points1(i,1) = temp(i*2);
end
fclose(fileid);
fileid = fopen(path2,'r');
PointNo = str2num(fgets(fileid));
temp = fscanf(fileid,'%f');
Points2 = zeros(PointNo, 2);
for i = 1 : PointNo
    Points2(i,2) = temp(i*2-1);
    Points2(i,1) = temp(i*2);
end
fclose(fileid);
x1 = Points1';
x2 = Points2';
n = size( x1, 2 );
x1 = [ x1 ; ones(1,n) ];
x2 = [ x2 ; ones(1,n) ];
end