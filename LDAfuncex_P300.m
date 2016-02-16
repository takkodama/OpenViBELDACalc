function [z, d, p_4duration, b_coef] = LDAfuncex_P300(TrainClassB, TrainClassA, TrialDATA) 

Train = vertcat(TrainClassB, TrainClassA);
% Label(1:111, :) = NonTarget / Label(112:148, :) = Target
Label = vertcat(zeros(length(TrainClassB(:, 1)), 1), ones(length(TrainClassA(:, 1)), 1));

% ===  % ===  1. Calculate Linear Discriminant Coefficients % ===  % === 

b_coef = lda_train(Train, Label, 'shrinkage');
b = b_coef.w;

% ===  % ===  2. Calulcate discriminant scores for all trial data % ===  % ===

x = TrialDATA;

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
for j = 1:(size(p, 2))
    for i = 1:4
        p_4duration(i, j) = mean(p(1+5*(i-1):5*(i), j));
    end
end



end