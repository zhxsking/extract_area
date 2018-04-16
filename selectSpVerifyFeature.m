close all;
clear;clc;
img = imread('D:\pic\液滴\6-2-rename\1.jpg');

% 处理并保存全图超像素特征数据
numSp = 500; %超像素个数**************
compac = 20; %超像素紧密度**************
fileName = strcat(' SpAllFea_', num2str(numSp), '_', num2str(compac));
[allFeature, SpImg, SpLabel, numSpLabel] = getSpAllFeature(img, numSp, compac);
eval(strcat('save', fileName, ' allFeature SpImg SpLabel numSpLabel'));

eval(strcat('load', fileName));
% 手选目标超像素
% figure;imshow(SpImg);
% % 添加一个结束按键
% btn = uicontrol('Style', 'pushbutton', 'String', '结束',...
%     'Position', [20 20 50 20], 'Callback', @btn_down);
% times_p = 0; %目标超像素个数
% global flag
% flag = 0;
% msgbox('取前景点','前景','help');
% pause;
% while ~flag
%     times_p = times_p + 1;
%     disp(times_p);
%     [x,y] = ginput(1);
%     hold on;
%     plot(x,y,'yo');
%     x = floor(x);
%     y = floor(y);
%     point(times_p, 1) = x;
%     point(times_p, 2) = y;
%     pause;
% end
% eval(strcat('save', ' point_', num2str(numSp), '_', num2str(compac), ' point times_p'));

eval(strcat('load', ' point_', num2str(numSp), '_', num2str(compac)));

% 读取标注点看是否正确
figure;imshow(SpImg);
for i=times_p:-1:1
    x = point(i, 1);
    y = point(i, 2);
    hold on;
    plot(x,y,'yo');
end

% 根据标注点获取正样本
tmp_SpLabel = 0:numSpLabel-1;
for i=times_p:-1:1
    x = point(i, 1);
    y = point(i, 2);
    fea_pos(i, :) = allFeature(SpLabel(y,x)+1, :);
    tmp_SpLabel(tmp_SpLabel==SpLabel(y,x)) = -1;
end
% 根据标注点获取负样本
fea_neg = [];
for i=1:numSpLabel
    if tmp_SpLabel(i) == -1
        continue;
    end
    fea_neg = [fea_neg; allFeature(tmp_SpLabel(i)+1, :)];
end

fea_verify = [fea_pos; fea_neg];
label_verify = [zeros(times_p,1); zeros(numSpLabel-times_p,1)+1];

eval(strcat('save', ' data_verify_', num2str(numSp), '_', num2str(compac), ' fea_verify label_verify'));

% 按键响应函数
function btn_down(source,event)
    global flag
    flag = source.Value;
    disp('准备结束');
end
