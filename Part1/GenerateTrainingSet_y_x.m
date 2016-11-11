function [inputs,DesiredOutputs] = GenerateTrainingSet_y_x(dim,nPairs)
% Generate input-output pairs for MLP training

inputs = zeros(nPairs,dim);

for i = 1:dim
    inputs(:,i) = (-1) + (1-(-1)).*rand(nPairs,1); % Random [-1,1]
end

DesiredOutputs = zeros(nPairs,1); % y = x
for i = 1:dim
    DesiredOutputs = inputs(:,i);
end