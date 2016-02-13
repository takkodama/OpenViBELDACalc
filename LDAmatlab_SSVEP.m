function [z_AllDuration, d_AllDuration, b, b_0] = LDAmatlab_SSVEP(TrainTargetCSV, TrainNonTargetCSV, InputCSV) 

[TrainNonTarget] = fileProcessor(TrainNonTargetCSV);
[TrainTarget] = fileProcessor(TrainTargetCSV);
[Input] = fileProcessor(InputCSV);

% ===  % ===  % ===  1. Train classifier  % ===  % ===  % === 

% === Caution!
% At first Non-Target then Target in order to make [0,0,0,....1,1,1,....]
Train = vertcat(TrainNonTarget(:, 2:3), TrainTarget(:, 2:3));
aveNonTarget = mean(TrainNonTarget(:, 2:3));
aveTarget = mean(TrainTarget(:, 2:3));
aveAll = mean(Train);

Label = vertcat(zeros(length(TrainNonTarget(:, 1)), 1), ones(length(TrainTarget(:, 1)), 1));

% ===  % ===  Matlab generetad hyperplane LDA % ===  %===  
cls = fitcdiscr(Train, Label, 'discrimType', 'Linear');

%between class 0 and 1
b_0 = cls.Coeffs(1,2).Const;
b = cls.Coeffs(1,2).Linear;

f = @(x1,x2) b_0 + b(1)*x1 + b(2)*x2;

% === Hyperplane 
% b(1) * x1 + b(2) + *x2 + b_0 = 0
b = [b(1) b(2) b_0];

% ===  % ===  % ===  2. Check classifier  % ===  % ===  % === 

% Classifier input
X = Input(:, 2:3);

% Calculate z and d
% z ... result is discriminated by whether this value is plus or minus? 
% d ... distance between discriminant line to plot
for i = 1:length(X(:,1));
    z(i, 1) = b(1) * X(i,1) + b(2) * X(i,2) + b_0;
    d(i, 1) = abs(z(i, 1))/hypot(b(1),b(2));
end

durationRange = length(X(:,1)) * 1/4;

z_Duration1 = mean(z(1:durationRange));
z_Duration2 = mean(z(durationRange+1:durationRange*2));
z_Duration3 = mean(z(durationRange*2+1:durationRange*3));
z_Duration4 = mean(z(durationRange*3+1:durationRange*4));
z_AllDuration = [z_Duration1;z_Duration2;z_Duration3;z_Duration4];

d_Duration1 = mean(d(1:durationRange));
d_Duration2 = mean(d(durationRange+1:durationRange*2));
d_Duration3 = mean(d(durationRange*2+1:durationRange*3));
d_Duration4 = mean(d(durationRange*3+1:durationRange*4));
d_AllDuration = [d_Duration1;d_Duration2;d_Duration3;d_Duration4];

% ===  % ===  % ===  Graph 1  % ===  % ===  % ===  
% scatter: Training DATA
% LDA plane: by Training DATA

figure
% X(1:111, :) = NonTarget / X(112:148, :) = Target
h1 = gscatter(Train(:, 1), Train(:, 2), Label(:,1), 'rb','xo',[],'off');
h1(1).LineWidth = 2;
axis([-0.5 0.5 -0.5 0.5]);
hold on

%{
scatter(Train(1:durationRange,1), Train(1:durationRange,2),'*');
hold on
scatter(Train(durationRange+1:durationRange*2,1), Train(durationRange+1:durationRange*2,2),'o');
hold on
scatter(Train(durationRange*2+1:durationRange*3,1), Train(durationRange*2+1:durationRange*3,2), 'x');
hold on
scatter(Train(durationRange*3+1:durationRange*4,1), Train(durationRange*3+1:durationRange*4,2), '+');
legend('duration1', 'duration2', 'duration3', 'duration4')
hold on
%}
%Average points of acquired datas
hold on
plot(aveAll(1,1), aveAll(1,2), 's', 'MarkerSize',15, 'MarkerEdgeColor','c', 'MarkerFaceColor',[0.5,0.5,0.5]);
hold on
plot(aveNonTarget(1,1), aveNonTarget(1,2), 's', 'MarkerSize',15, 'MarkerEdgeColor','r', 'MarkerFaceColor',[0.5,0.5,0.5]);
hold on
plot(aveTarget(1,1), aveTarget(1,2), 's', 'MarkerSize',15, 'MarkerEdgeColor','b', 'MarkerFaceColor',[0.5,0.5,0.5]);
%legend('NonTarget', 'Target', 'AllAverage', 'NonTargetAverage', 'TargetAverage')

% == LDA Plane
hold on
h2 = ezplot(f, [-0.5 0.5 -0.5 0.5]); % Plot the relevant portion of the curve.
h2.Color = 'b';
h2.LineWidth = 2;

% == Diagonal line for LDA
hold on
a_cross = (1 / (b(1)/b(2)));
b_cross = aveAll(2) - a_cross * aveAll(1);
f_cross = @(x1) a_cross * x1  + b_cross;
h3 = ezplot(f_cross, [-0.5 0.5 -0.5 0.5]); % Plot the relevant portion of the curve.
h3.Color = 'magenta';

% == Reference lines

hold on
vline = line([0,0],[-0.5 0.5]);
vline.Color = 'r';
hold on
hline = refline([0 0]);
hline.Color = 'r';
title('LDA plane with acquired datas (148)');

% ==== % ==== % ====

%calculate reenter error
resuberror = resubLoss(cls);
%calculate cross validation
cvmodel = crossval(cls,'kfold',10);
cverror = kfoldLoss(cvmodel);

order = unique(Label(:,1)); % Order of the group labels
cp = cvpartition(Label(:,1),'k',10); % Stratified cross-validation
ff = @(xtr,ytr,xte,yte)confusionmat(yte,classify(xte,xtr,ytr),'order',order);
cfMat = crossval(ff, [Train(:,1) Train(:,2)], Label(:,1),'partition',cp);
cfMat = reshape(sum(cfMat),2,2);

%cp
%ff
cfMat

end