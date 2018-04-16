function [train_fea, train_label] = selectSpFeature(SpImg, allFeature, SpLabel, times_p, times_n)
% 选择训练用超像素特征
% 

figure;imshow(SpImg);
% 前景采样
msgbox('取前景点','前景','help');
pause;
for run = times_p:-1:1
    [x,y] = ginput(1);
    hold on;
    plot(x,y,'yo');
    x = floor(x);
    y = floor(y);
    fea_pos(run, :) = allFeature(SpLabel(y,x)+1, :);
end
% 背景采样
msgbox('取背景点','背景','help');
pause;
for run = times_n:-1:1
    [x,y] = ginput(1);
    hold on;
    plot(x,y,'y*');
    x = floor(x);
    y = floor(y);
    fea_neg(run, :) = allFeature(SpLabel(y,x)+1, :);
end 

train_fea = [fea_pos; fea_neg];
train_label = [zeros(times_p,1); zeros(times_n,1)+1];

end

