function [z, d, p, b_coef] = LDAfuncex_P300(TrainTargetA, TrainTargetB, TrialDATA) 

Train = vertcat(TrainTargetB(:, 2:154), TrainTargetA(:, 2:154));
% Label(1:111, :) = NonTarget / Label(112:148, :) = Target
Label = vertcat(zeros(length(TrainTargetB(:, 1)), 1), ones(length(TrainTargetA(:, 1)), 1));

% ===  % ===  1. Calculate Linear Discriminant Coefficients % ===  % === 

b_coef = lda_train(Train, Label, 'shrinkage');
b = b_coef.w(:, 2:154);

% ===  % ===  2. Calulcate discriminant scores for all trial data % ===  % ===

x = TrialDATA(:, 2:154);

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

%(for P300) summerize class probabilities
mean(p)

end