function [allFeature, SpImg, SpLabel, numSpLabel] = getSpAllFeature(img, numSp, compactness)
% 获取图像的超像素特征矩阵

hsi = rgb2hsi(img);
lab = rgb2lab(img);

img_r = img(:,:,1);
img_g = img(:,:,2);
img_b = img(:,:,3);
img_h = hsi(:,:,1);
img_s = hsi(:,:,2);
img_i = hsi(:,:,3);
% img_l = img(:,:,1);
% img_a = img(:,:,2);
% img_b = img(:,:,3);

tic;
hwait=waitbar(0,'请等待...'); %进度条
[SpImg, SpLabel, numSpLabel] = slic_process(img, numSp, compactness);
for i=numSpLabel:-1:1
    nst = (double(numSpLabel-i)/double(numSpLabel)*100);
    str = ['正在运行中',num2str(nst),'%'];
    waitbar(double(numSpLabel-i)/double(numSpLabel), hwait, str);
    
%     r_tmp = img_r;
%     r_tmp(SpLabel ~= i-1) = 0;
%     idx = find(r_tmp~=0);
    idx = find(SpLabel == i-1);
    r_mean(i) = mean(img_r(idx));
    r_var(i) = var(double(img_r(idx)));
    %     r_mean(i) = sum(sum(r_tmp)) ./ sum(sum(r_tmp~=0));
%     g_tmp = img_g;
%     g_tmp(SpLabel ~= i-1) = 0;
%     idx = find(g_tmp~=0);
    g_mean(i) = mean(img_g(idx));
    g_var(i) = var(double(img_g(idx)));
    %     g_mean(i) = sum(sum(g_tmp)) ./ sum(sum(g_tmp~=0));
%     b_tmp = img_b;
%     b_tmp(SpLabel ~= i-1) = 0;
%     idx = find(b_tmp~=0);
    b_mean(i) = mean(img_b(idx));
    b_var(i) = var(double(img_b(idx)));
    %     b_mean(i) = sum(sum(b_tmp)) ./ sum(sum(b_tmp~=0));
%     h_tmp = hsi(:,:,1);
%     h_tmp(SpLabel ~= i-1) = 0;
%     idx = find(h_tmp~=0);
    h_mean(i) = mean(img_h(idx));
    h_var(i) = var(double(img_h(idx)));
    %     h_mean(i) = sum(sum(h_tmp)) ./ sum(sum(h_tmp~=0));
%     s_tmp = hsi(:,:,2);
%     s_tmp(SpLabel ~= i-1) = 0;
%     idx = find(s_tmp~=0);
    s_mean(i) = mean(img_s(idx));
    s_var(i) = var(double(img_s(idx)));
    %     s_mean(i) = sum(sum(s_tmp)) ./ sum(sum(s_tmp~=0));
%     i_tmp = hsi(:,:,3);
%     i_tmp(SpLabel ~= i-1) = 0;
%     idx = find(i_tmp~=0);
    i_mean(i) = mean(img_i(idx));
    i_var(i) = var(double(img_i(idx)));
    %     i_mean(i) = sum(sum(i_tmp)) ./ sum(sum(i_tmp~=0));
end
close(hwait); %关闭进度条，注意必须添加close函数

allFeature = [r_mean'/255, g_mean'/255, b_mean'/255, h_mean', s_mean', i_mean',...
    r_var', g_var', b_var', h_var', s_var', i_var'];
toc;
end

