clear,clc;
numSp = 2000; %超像素个数
compac = 20; %超像素紧密度
eval(strcat('load', ' data_verify_', num2str(numSp), '_', num2str(compac)));
train_label = label_verify;
train_fea = fea_verify;
high = zeros(1,12);
for k=5:8   %近邻个数
    %weights为原序特征分别所占权重，ranked为权重降序排列下在原来向量中的位置
    [ranked,weights] = relieff(train_fea, train_label, k);
    for j=1:12  %对各特征权重降序排列下的位置相加，获得多次近邻个数优选下的总排列
        high(ranked(j)) = high(ranked(j)) + j;
    end
end
bar(weights(ranked));xlabel('排列');ylabel('权重');
%% 
% [high_sort,high_num] = sort(high);%排序，最小的即为影响最大的
% high_f = [];
% for i=1:12  %从原数据中挑选出前12个影响大的特征列组成新数据
%     high_f = [high_f,train_fea(:,high_num(1,i))];
% end

attr = {'r ','g ','b ','h ','s ','i ','r_v ','g_v ','b_v ','h_v ','s_v ','i_v '};
out = '';
for i=1:size(ranked,2)
    out = strcat(out,attr(1,ranked(i)));
end
disp(out);

% save highDataNoScale1 high_f label