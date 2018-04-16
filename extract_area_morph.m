close all;
clear;clc;

img = imread('D:\pic\ÒºµÎ\6-2-rename\1.jpg');
img = imresize(img, 0.25);
img_gray = rgb2gray(img);%»Ò¶È»¯

hsi = rgb2hsi(img);
lab = rgb2lab(img);

% img = imadjust(img, [], [], 1.5);

se_big = strel('disk',10);%¸²¸ÇÇ°¾°ÌØÕ÷
img = imsubtract(imadd(img_gray,imtophat(img_gray,se_big)),imbothat(img_gray,se_big));%¶¥µ×Ã±ÁªºÏ±ä»»

hy = fspecial('sobel');
hx = hy';
Iy = imfilter(double(img), hy, 'replicate');
Ix = imfilter(double(img), hx, 'replicate');
gradmag = sqrt(Ix.^2 + Iy.^2);

figure,imshow(img, []);

%% 
se = strel('disk', 15);
img_o = imopen(img_gray, se);
img_or = imreconstruct(img_o, img_gray);
img_orc = imclose(img_or, se);
img_orcr = imreconstruct(img_orc, img_or);

img_ord = imdilate(img_or, se);
img_ordr = imreconstruct(imcomplement(img_ord), imcomplement(img_or));
img_ordr = imcomplement(img_ordr);

fgm = imregionalmin(img_ordr);

% bw1 = imbinarize(img_orcr, 0.2);
% bw2 = imbinarize(img_ordr, graythresh(img_ordr));
% 
% figure,imshow(bw1);
% figure,imshow(bw2);

figure,imshow(img_orcr);
figure,imshow(img_ordr);
figure,imshow(fgm);
% Ie = imerode(I, se);
% Iobr = imreconstruct(Ie, I);
% Ioc = imclose(Io, se);
% Iobrd = imdilate(Iobr, se);
% Iobrcbr = imreconstruct(imcomplement(Iobrd), imcomplement(Iobr));
% Iobrcbr = imcomplement(Iobrcbr);
% fgm = imregionalmax(Iobrcbr);

%% 
figure,imshow(img);
figure,imshow(hsi);
figure,imshow(lab);
figure,imshow(img_ordr);
figure,imshow(3*hsi(:,:,2) - hsi(:,:,3), []);




