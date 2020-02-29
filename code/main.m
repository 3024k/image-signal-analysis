
clear;
close all;
clc;

a = imread('1.jpg','jpg');% read image #1
aa= imresize(a,[128,128]); % resize image 'a' into 'aa' of size 128x128

aa = round((double(aa(:,:,1))+double(aa(:,:,2))+double(aa(:,:,3)))/3); % convert 'aa' image into double type
[tx, ty] = size(aa); % assign the size of 'aa' into 'tx' and 'ty'

% Convert  Uint8 to double array
%Ia = double(aa);

sz = (tx*ty); 
s1 = reshape(aa,1,sz); %original signal#1

b = imread('p2.jpg','jpg');
bb = imresize(b,[128,128]);
bb = round((double(bb(:,:,1))+double(bb(:,:,2))+double(bb(:,:,3)))/3);
[tx, ty] = size(bb);

% Convert Uint8 to double array
%Ib = double(bb);
sz = (tx*ty);
s2 = reshape(bb,1,sz);%original signal#2

% View the original image
figure;
subplot(1,2,1); imagesc(aa); title('Image original 1');axis square; 
subplot(1,2,2); imagesc(bb); title('Image original 2');axis square; 
colormap gray;

s = [s1; s2]; % Original Signal sources


figure; plot(s1,s2, '.');                        % plot the variables
set(gca, 'xlim', [-10 200], 'ylim', [-10 200]);  % redefines limits of the graph

% define the two random variables
A = rand(2);

% Mix original sources with unknown mixing matrics 'A'
x = A * s;

 
x1 = reshape(x(1,:),tx,ty);
x2 = reshape(x(2,:),tx,ty);


figure; plot(x1,x2, '.');                        % plot the variables
set(gca, 'xlim', [-5 300], 'ylim', [-5 300]);  % redefines limits of the graph

% View mixed image 
figure;
subplot(1,2,1); imagesc(x1); title('Mix 1');axis square; 
subplot(1,2,2); imagesc(x2); title('Mix 2');axis square;
colormap gray;

% Preprocessing ica using pca
RX = cov(x');
[E LAM] = eig(RX);  % Decomposition covariance matrix
lam = diag(LAM);    % Extract eigenvalues
lam = sqrt(1./lam); % the inverse square root
LAM = diag(lam);    % Back to form the matrix
Z = LAM * E' * x;   % PCA transformation

theta(1) = 3;
theta(2) = 3;
gain = 0.1;
it = 0;
ITMAX = 100;        % Max iteration
fi = zeros(2,sz);

I = eye(2);
W = I;              % Initial value of the mixture matrix
% Estimated independent components
y = W * x;

y = whitening(y); % Apply whitening

y1 = reshape(y(1,:),tx,ty);

y2 = reshape(y(2,:),tx,ty);



figure; plot(y1,y2, '.');                        % plot the variables
set(gca, 'xlim', [-5 7], 'ylim', [-5 7]);  % redefines limits of the graph



while(it < ITMAX)
    it = it + 1;
    y = W * Z;      % ICA transformation
    
    for i = 1 : 2
        fi(i,:) = sign(y(i,:)) .* power(abs(y(i,:)), theta(i) - 1);
    end
    F = I - fi * y' * W;
    %figure(4);plot(y(1,:),y(2,:),'x');

end

%y1 = reshape(y(1,:),tx,ty);

%y2 = reshape(y(2,:),tx,ty);
figure; 
axes('position', [0.2 0.2 0.8 0.8]); plot(y(1,:), y(2,:), '.'); hold on;
axes('position', [0   0.2 0.2 0.8]); hist(y(1,:));  set(gca, 'view', [90 90]);
axes('position', [0.2 0   0.8 0.2]); hist(y(2,:));


figure;
subplot(1,2,1); imagesc(y1); title('Image 1 estimated');axis square; 
subplot(1,2,2); imagesc(y2); title('Image 2 estimated');axis square;
colormap gray;

figure; 
axes('position', [0.2 0.2 0.8 0.8]); plot(s1,s2, '.'); hold on;
axes('position', [0   0.2 0.2 0.8]); hist(s2);
set(gca, 'xdir', 'reverse'); set(gca, 'view', [90 90]);
axes('position', [0.2 0   0.8 0.2]); hist(s1);