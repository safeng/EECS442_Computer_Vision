function [F,dist1,dist2] = FMatNorm(pathdata1,pathdata2,pathimg1,pathimg2) 
% fundenmantal matrix with normalization
[X1,X2]=readTextFiles(pathdata1,pathdata2); % load feature points from two images. column wise data

% normalization
% centroid
X1Trans = -mean(X1,2);
X2Trans = -mean(X2,2);
X1Scale = sqrt(2)./std(X1,1,2);
X2Scale = sqrt(2)./std(X2,1,2);
% transform matrix
T1 = [X1Scale(1),0,X1Scale(1)*X1Trans(1);
           0,X1Scale(2),X1Scale(2)*X1Trans(2);
           0,0,1];
T2 = [X2Scale(1),0,X2Scale(1)*X2Trans(1);
           0,X2Scale(2),X2Scale(2)*X2Trans(2);
           0,0,1];
% perform transformation
X1org=X1;
X2org=X2;

X1 = T1*X1;
X2 = T2*X2;
% construction of A
A=ones(9,size(X1,2)); 
A(1,:) = X1(1,:).*X2(1,:);
A(2,:) = X1(1,:).*X2(2,:);
A(3,:) = X1(1,:);
A(4,:) = X1(2,:).*X2(1,:);
A(5,:) = X1(2,:).*X2(2,:);
A(6,:) = X1(2,:);
A(7,:) = X2(1,:);
A(8,:) = X2(2,:);
% calculate SVD of A
A=A';
[U, S, V] = svd (A);
f=V(:,end); % f is the last column of V
F=reshape(f,3,3);
F=F';
[U, S, V] = svd(F);
S(:,3:end)=0; % only use the first two columns
F=U*S*V';

% restore
F=T1'*F*T2;
X1=X1org;
X2=X2org;

% calculate distances
% epipolar lines for X1
l1=F*X2; % 3-3 * 3-n
% epipolar lines for X2
l2 = F'*X1;
% distance between X1 and l1
temp = abs(l1(1,:).*X1(1,:)+l1(2,:).*X1(2,:)+l1(3,:));
dist1 = temp./(l1(1,:).^2+l1(2,:).^2).^.5;
dist1 = mean(dist1(:));
% distance between X2 and l2
temp = abs(l2(1,:).*X2(1,:)+l2(2,:).*X2(2,:)+l2(3,:));
dist2 = temp./(l2(1,:).^2+l2(2,:).^2).^.5;
dist2 = mean(dist2(:));

% draw feature points and epipolar lines
figure;
img1 = imread(pathimg1);
imshow(img1);
hold on;
plot(X1(1,:),X1(2,:),'r*');
for i=1:size(X1,2)
	x = X1(1,i)-20:X1(1,i)+20;
	y = -(l1(1,i).*x+l1(3,i))./l1(2,i);
	plot(x,y,'b');
end
hold off;
figure;
img2 = imread(pathimg2);
imshow(img2);
hold on;
plot(X2(1,:),X2(2,:),'ro');
for i=1:size(X2,2)
	x = X2(1,i)-20:X2(1,i)+20;
	y = -(l2(1,i).*x+l2(3,i))./l2(2,i);
	plot(x,y,'b');
end
hold off;