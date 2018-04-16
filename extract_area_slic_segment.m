close all;
clear;clc;

img = imread('D:\pic\Һ��\6-2-rename\1.jpg');
[m, n, k] = size(img);
numSp = 500;
compac = 20;
eval(strcat('load', ' SpAllFea_', num2str(numSp), '_', num2str(compac)));

%% ��ѡѵ������
% [train_fea, train_label] = selectSpFeature(SpImg, allFeature, SpLabel, 10, 10);
% eval(strcat('save', ' SpTrainData_', num2str(numSp), '_', num2str(compac), ' train_fea train_label'));

%% ѵ��
clc;
% eval(strcat('load', ' SpTrainData_', num2str(numSp), '_', num2str(compac)));
eval(strcat('load', ' data_verify_', num2str(numSp), '_', num2str(compac)));
train_label = label_verify;
train_fea = fea_verify;
% model = svmtrain(train_label, train_fea, '-t 1 -d 1 -h 0');%�˺������ö���ʽ
model = svmtrain(train_label, train_fea, '-c 2 -g 1 -q');%�˺�������RBF
preTrainLabel = svmpredict(train_label, train_fea, model);%׼ȷ��

%% 
testlabel = svmpredict(ones(length(allFeature),1), allFeature, model, '-q');

% ��testlabel��ǵ�ʵ��ͼ���ϵ�����
idx = find(testlabel);
ind = zeros(m, n);
for i=1:size(idx,1)
    tmp = SpLabel == idx(i)-1;
    ind = tmp | ind;
end

img_seg = img .* uint8(~ind);
figure;imshow(img_seg);
