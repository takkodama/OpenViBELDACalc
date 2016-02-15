function [z, d, p_4duration, b_coef] = LDAfuncex_SSVEP(TrainTarget, TrainNonTarget, TrialDATA) 

Train = vertcat(TrainNonTarget(:, 2:3), TrainTarget(:, 2:3));
% Label(1:111, :) = NonTarget / Label(112:148, :) = Target
Label = vertcat(zeros(length(TrainNonTarget(:, 1)), 1), ones(length(TrainTarget(:, 1)), 1));

% ===  % ===  1. Calculate Linear Discriminant Coefficients % ===  % === 
b_coef = lda_train(Train, Label, 'shrinkage');
b = b_coef.w(:, 2:3);

% ===  % ===  % ===  (Depict graph) % ===  % ===  % === 
%Scatter
%{
figure
s = gscatter(Train(:, 1), Train(:, 2), Label(:,1), 'br','xo',[],'off');
s(1).LineWidth = 2;
axis([-0.3 0.3 -0.3 0.3]);
hold on

%Hyperplane
for i = 1: size(b_coef.w, 1)
    f{i, 1} = @(x1,x2) b_0(i) + b(i, 1)*x1 + b(i, 2)*x2;
    h(i+100) = ezplot(f{i, 1}, [-5 5 -5 5]); % Plot the relevant portion of the curve.
    h(i+100).LineWidth = 2; 
    h(i+100).Color = ColorArray(i);
    hold on
end

%Refline
vline = line([0,0],[-0.5 0.5]);
vline.Color = 'r';
hold on
hline = refline([0 0]);
hline.Color = 'r';
%}

% ===  % ===  2. Calulcate discriminant scores for all trial data % ===  % ===  % ===

x = TrialDATA(:, 2:3);

%Discrinimant score
z = [ones(size(x,1), 1) x] * b_coef.w';

%Distance from each hyperplane
for j = 1:(size(b_coef.w, 1))
    for i = 1:size(x, 1)
        d(i, j) = abs(z(i, j))/hypot(b(j, 1),b(j, 2));
    end
end

%Class probability
p = exp(z) ./ repmat(sum(exp(z),2),[1 2]);

%(for SSVEP) summerize class probabilities
for j = 1:(size(p, 2))
    for i = 1:4
        p_4duration(i, j) = mean(p(1+17*(i-1):17*(i), j));
    end
end


end