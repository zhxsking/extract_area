close all;
clear;clc;
img = imread('D:\pic\ÒºµÎ\6-2-rename\1.jpg');
[m, n, k] = size(img);

numSp = 500; %³¬ÏñËØ¸öÊı
compac = 20; %³¬ÏñËØ½ôÃÜ¶È

eval(strcat('load', ' SpAllFea_', num2str(numSp), '_', num2str(compac)));

tic;
res_r = zeros(m, n);
res_b = zeros(m, n);
res_g = zeros(m, n);
for i=1:numSpLabel
    ind = SpLabel == i-1;
    ind_r = ind .* allFeature(i, 1) .* 255;
    res_r = res_r + ind_r;
    ind_g = ind .* allFeature(i, 2) .* 255;
    res_g = res_g + ind_g;
    ind_b = ind .* allFeature(i, 3) .* 255;
    res_b = res_b + ind_b;
end
toc;
res = uint8(cat(3, res_r, res_g, res_b));
res_lab = rgb2hsi(res);
lab = rgb2hsi(img);

figure;imshow(res, []);
figure;imshow(res_lab, []);

imwrite(res, 'res_sp_500_20.jpg');


