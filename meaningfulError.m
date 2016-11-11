function error = meaningfulError(bestIndividual, nPairs,inputs,nHiddenLayer,HiddenNeurons,DesiredOutputs)

error = 0;
for i = 1:nPairs
    error = error + 100*min(1, abs(DesiredOutputs(i)-MLPforward(inputs(i,:)',nHiddenLayer,HiddenNeurons,bestIndividual)/DesiredOutputs(i)));
end

error = error/nPairs;
end