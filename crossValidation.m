clear;
clc;
tic;
numSp = 500; %超像素个数
compac = 20; %超像素紧密度
eval(strcat('load', ' data_verify_', num2str(numSp), '_', num2str(compac)));
train_label = label_verify;
train_fea = fea_verify;
bestcv = 0;
for log2c = -10 : 5
    for log2g = -10 : 5
        cmd = ['-v 10 -c ', num2str(2^log2c), ' -g ', num2str(2^log2g) ,' -q'];
        cv = svmtrain(train_label, train_fea, cmd);
        if (cv > bestcv)
            bestcv = cv;
            bestc = 2^log2c;
            bestg = 2^log2g;
        end
        fprintf('%g %g %g (best c=%g, g=%g, rate=%g)\n', log2c, log2g, cv, bestc, bestg, bestcv);
    end
end
toc;

cmd = ['-c ', num2str(bestc), ' -g ', num2str(bestg) ,' -q'];
model = svmtrain(train_label, train_fea, cmd);%核函数采用RBF
preTrainLabel = svmpredict(train_label, train_fea, model);%准确率
