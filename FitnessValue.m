function fitness = FitnessValue(nPairs,inputs,nHiddenLayer,HiddenNeurons,W,DesiredOutputs)
% Analyze fitness for the current proposed solution
% We try to minimise the error. Perfect fitness = 0

MLPoutput = zeros(nPairs,1);

    for i = 1:nPairs
        MLPoutput(i) = MLPforward(inputs(i,:)',nHiddenLayer,HiddenNeurons,W);
    end
    fitness = sum((MLPoutput-DesiredOutputs).^2); % Calculate fitness of the proposed solution
    if fitness > 400;
        
    end
end