clear,clc;
numSp = 2000; %�����ظ���
compac = 20; %�����ؽ��ܶ�
eval(strcat('load', ' data_verify_', num2str(numSp), '_', num2str(compac)));
train_label = label_verify;
train_fea = fea_verify;
high = zeros(1,12);
for k=5:8   %���ڸ���
    %weightsΪԭ�������ֱ���ռȨ�أ�rankedΪȨ�ؽ�����������ԭ�������е�λ��
    [ranked,weights] = relieff(train_fea, train_label, k);
    for j=1:12  %�Ը�����Ȩ�ؽ��������µ�λ����ӣ���ö�ν��ڸ�����ѡ�µ�������
        high(ranked(j)) = high(ranked(j)) + j;
    end
end
bar(weights(ranked));xlabel('����');ylabel('Ȩ��');
%% 
% [high_sort,high_num] = sort(high);%������С�ļ�ΪӰ������
% high_f = [];
% for i=1:12  %��ԭ��������ѡ��ǰ12��Ӱ�������������������
%     high_f = [high_f,train_fea(:,high_num(1,i))];
% end

attr = {'r ','g ','b ','h ','s ','i ','r_v ','g_v ','b_v ','h_v ','s_v ','i_v '};
out = '';
for i=1:size(ranked,2)
    out = strcat(out,attr(1,ranked(i)));
end
disp(out);

% save highDataNoScale1 high_f label