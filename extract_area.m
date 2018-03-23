% 提取玉米叶片上的液滴，并计算面积
close all;
clear;clc;
name = {'a', 'b', 'c'};
for group=3:-1:1 %第几组图片
    figure;
    for i=1:3 %组中第几张图片
        img_ori = imread(strcat(name{i}, num2str(group), '.png'));
        img_ori = imresize(img_ori, [137,183]);
        
        % 去除图片红色边框避免多个域连通
        cut = 3; %裁剪的边缘宽
        [h, w, ~] = size(img_ori);
        rect = [cut, cut, w-2*cut, h-2*cut];
        img = imcrop(img_ori, rect);
        
        % 增强并二值
        img_hsi = rgb2hsi(img);
        tt = 3*img_hsi(:,:,2) - img_hsi(:,:,3);
        img_bw = imbinarize(tt,graythresh(tt));
        
        % 保留最大连通域
        L = bwlabel(img_bw);
        stats = regionprops(L);
        Ar = cat(1, stats.Area);
        ind = find(Ar==max(Ar));
        img_maxarea = zeros(size(img_bw));
        img_maxarea(L==ind) = 1;
        
        if (group==2) %针对第二组特殊处理
            img_nohole = fillsmallholes(img_maxarea,300); %填充小孔洞
        else
            img_nohole = img_maxarea;
        end
        
        % 开闭处理
        se = strel('disk',5); %圆盘特征
        img_open = imopen(img_nohole, se);
        se1 = strel('disk',7); %圆盘特征
        img_oc = imclose(img_open, se1);
        img_oc = bwareaopen(img_oc, 500); %删除图像中小面积区域
        img_res = img .* uint8(img_oc);
        
        % 计算面积
        area(group, i) = sum(sum(img_oc));
        
        % 已知条件，液滴面积是逐渐变大的，若发现变小则异常处理
        if (i>1 && area(group, i)<area(group, i-1))
            img_maxarea = img_maxarea | img_oc_last; %在上次基础上处理
            se = strel('disk',5); %圆盘特征
            img_open = imopen(img_maxarea, se);
            se1 = strel('disk',7); %圆盘特征
            img_oc = imclose(img_open, se1);
            img_oc = bwareaopen(img_oc, 500); %删除图像中小面积区域
            img_res = img .* uint8(img_oc);
            area(group, i) = sum(sum(img_oc));
        end
        
        img_oc_last = img_oc; %保存上次处理结果
        
        [m, n] = size(img_oc);
        area_all(group, i) = m * n;
        area_percent(group, i) = area(group, i) / area_all(group, i) * 100;
        
        subplot(3,3,3*i-2);imshow(img);title(strcat('第', num2str(group), '组图',  name{i}));
        subplot(3,3,3*i-1);imshow(img_oc);title('提取后区域');
        subplot(3,3,3*i);imshow(img_res);title('结果图');
    end
end

figure;
for j=1:3
    subplot(3,2,2*j-1);plot(1:3,area(j,:),'-o','LineWidth',1.5,'MarkerFaceColor','b');
    ylabel('像素面积');
    subplot(3,2,2*j);plot(1:3,area_percent(j,:),'-o','LineWidth',1.5,'MarkerFaceColor','b');
    ylabel('百分比面积');
end
