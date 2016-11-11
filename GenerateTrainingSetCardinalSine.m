function [inputs,DesiredOutputs] = GenerateTrainingSetCardinalSine(dim,nPairs, range)
% Generate input-output pairs for MLP training

inputs = zeros(nPairs,dim);

for i = 1:dim
    inputs(:,i) = range(1) + (range(2)-range(1)).*rand(nPairs,1); % Random [-20,20]
end

DesiredOutputs = zeros(nPairs,1);
for i = 1:dim
    DesiredOutputs = DesiredOutputs + sin(inputs(:,i))./inputs(:,i);
end

% DesiredOutputs = DesiredOutputs/400-1; % Map de Output domain to the Activation function domain??