function [inputs,DesiredOutputs] = GenerateTrainingSetSphere(dim,nPairs,range)
% Generate input-output pairs for MLP training

inputs = zeros(nPairs,dim);

for i = 1:dim
    inputs(:,i) = range(1) + (range(2)-(range(1))).*rand(nPairs,1);
end

DesiredOutputs = zeros(nPairs,1);
for i = 1:dim
    DesiredOutputs = DesiredOutputs + inputs(:,i).^2;
end