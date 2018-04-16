close all;
clear;clc;
img = imread('D:\pic\Һ��\6-2-rename\1.jpg');

% ��������ȫͼ��������������
numSp = 500; %�����ظ���**************
compac = 20; %�����ؽ��ܶ�**************
fileName = strcat(' SpAllFea_', num2str(numSp), '_', num2str(compac));
[allFeature, SpImg, SpLabel, numSpLabel] = getSpAllFeature(img, numSp, compac);
eval(strcat('save', fileName, ' allFeature SpImg SpLabel numSpLabel'));

eval(strcat('load', fileName));
% ��ѡĿ�곬����
% figure;imshow(SpImg);
% % ���һ����������
% btn = uicontrol('Style', 'pushbutton', 'String', '����',...
%     'Position', [20 20 50 20], 'Callback', @btn_down);
% times_p = 0; %Ŀ�곬���ظ���
% global flag
% flag = 0;
% msgbox('ȡǰ����','ǰ��','help');
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

% ��ȡ��ע�㿴�Ƿ���ȷ
figure;imshow(SpImg);
for i=times_p:-1:1
    x = point(i, 1);
    y = point(i, 2);
    hold on;
    plot(x,y,'yo');
end

% ���ݱ�ע���ȡ������
tmp_SpLabel = 0:numSpLabel-1;
for i=times_p:-1:1
    x = point(i, 1);
    y = point(i, 2);
    fea_pos(i, :) = allFeature(SpLabel(y,x)+1, :);
    tmp_SpLabel(tmp_SpLabel==SpLabel(y,x)) = -1;
end
% ���ݱ�ע���ȡ������
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

% ������Ӧ����
function btn_down(source,event)
    global flag
    flag = source.Value;
    disp('׼������');
end
