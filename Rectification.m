function [H,H_prime,err] = Rectification(pathdata1,pathdata2,pathimg1,pathimg2)
% get fundamental matrix
F = FMatNorm(pathdata1,pathdata2,pathimg1,pathimg2);
img1 = imread(pathimg1);
img2 = imread(pathimg2);

% calculate epipoles
[U, D, V] = svd (F);
epi = V(:,end); % last column of V
epi = epi/epi(3);
[U, D, V] = svd(F');
epi_prime = V(:,end);
epi_prime = epi_prime/epi_prime(3);

% map epi_prime to [1,0,1]
% x0 is center of the image
TH=[1,0,size(img2,2)/2;
    0,1,size(img2,1)/2;
    0,0,1];
e11=TH*epi_prime;
len=sqrt(e11(1)^2+e11(2)^2);
sine=e11(2)/len;
cose=e11(1)/len;
RH=[cose,-sine,0;
    sine,cose,0;
    0,0,1];
H1=RH*TH;   % map e_prime to the x-axis at location [length,0,1]'
H2 = [1 0 0; 0 1 0; -1/len 0 1];% send epipole to infinity
% transform of M
H_prime = H2*H1;

% find H to align epipolar lines
% calculate M
M = pinv([0, -epi_prime(3), epi_prime(2); epi_prime(3),0,-epi_prime(1);-epi_prime(2),epi_prime(1),0])*F;
H0 = H_prime*M;
% find a,b,c for HA
[X1,X2] =  readTextFiles(pathdata1,pathdata2); 
X2_hat_prime = H_prime*X2;
X1_hat = H0*X1;
X1_hat = X1_hat./repmat(X1_hat(3,:),3,1);
X2_hat_prime = X2_hat_prime./repmat(X2_hat_prime(3,:),3,1);
A = X1_hat';
b = X2_hat_prime(1,:)';
res = pinv(A)*b;
Ha = [res(1),res(2),res(3);0 1 0;0 0 1];
% get H
H = Ha*H0;

% apply transform and find errors
X1H = H*X1;
X1H = X1H./repmat(X1H(3,:),3,1);
X2H = H_prime*X2;
X2H = X2H./repmat(X2H(3,:),3,1);
err = sum((X1H(1:2,:)-X2H(1:2,:)).^2);
err = mean(sqrt(err));