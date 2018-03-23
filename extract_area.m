% ��ȡ����ҶƬ�ϵ�Һ�Σ����������
close all;
clear;clc;
name = {'a', 'b', 'c'};
for group=3:-1:1 %�ڼ���ͼƬ
    figure;
    for i=1:3 %���еڼ���ͼƬ
        img_ori = imread(strcat(name{i}, num2str(group), '.png'));
        img_ori = imresize(img_ori, [137,183]);
        
        % ȥ��ͼƬ��ɫ�߿����������ͨ
        cut = 3; %�ü��ı�Ե��
        [h, w, ~] = size(img_ori);
        rect = [cut, cut, w-2*cut, h-2*cut];
        img = imcrop(img_ori, rect);
        
        % ��ǿ����ֵ
        img_hsi = rgb2hsi(img);
        tt = 3*img_hsi(:,:,2) - img_hsi(:,:,3);
        img_bw = imbinarize(tt,graythresh(tt));
        
        % ���������ͨ��
        L = bwlabel(img_bw);
        stats = regionprops(L);
        Ar = cat(1, stats.Area);
        ind = find(Ar==max(Ar));
        img_maxarea = zeros(size(img_bw));
        img_maxarea(L==ind) = 1;
        
        if (group==2) %��Եڶ������⴦��
            img_nohole = fillsmallholes(img_maxarea,300); %���С�׶�
        else
            img_nohole = img_maxarea;
        end
        
        % ���մ���
        se = strel('disk',5); %Բ������
        img_open = imopen(img_nohole, se);
        se1 = strel('disk',7); %Բ������
        img_oc = imclose(img_open, se1);
        img_oc = bwareaopen(img_oc, 500); %ɾ��ͼ����С�������
        img_res = img .* uint8(img_oc);
        
        % �������
        area(group, i) = sum(sum(img_oc));
        
        % ��֪������Һ��������𽥱��ģ������ֱ�С���쳣����
        if (i>1 && area(group, i)<area(group, i-1))
            img_maxarea = img_maxarea | img_oc_last; %���ϴλ����ϴ���
            se = strel('disk',5); %Բ������
            img_open = imopen(img_maxarea, se);
            se1 = strel('disk',7); %Բ������
            img_oc = imclose(img_open, se1);
            img_oc = bwareaopen(img_oc, 500); %ɾ��ͼ����С�������
            img_res = img .* uint8(img_oc);
            area(group, i) = sum(sum(img_oc));
        end
        
        img_oc_last = img_oc; %�����ϴδ�����
        
        [m, n] = size(img_oc);
        area_all(group, i) = m * n;
        area_percent(group, i) = area(group, i) / area_all(group, i) * 100;
        
        subplot(3,3,3*i-2);imshow(img);title(strcat('��', num2str(group), '��ͼ',  name{i}));
        subplot(3,3,3*i-1);imshow(img_oc);title('��ȡ������');
        subplot(3,3,3*i);imshow(img_res);title('���ͼ');
    end
end

figure;
for j=1:3
    subplot(3,2,2*j-1);plot(1:3,area(j,:),'-o','LineWidth',1.5,'MarkerFaceColor','b');
    ylabel('�������');
    subplot(3,2,2*j);plot(1:3,area_percent(j,:),'-o','LineWidth',1.5,'MarkerFaceColor','b');
    ylabel('�ٷֱ����');
end
