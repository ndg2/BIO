function population = insertNewInputs(population, newIndividuals, inputs, nHiddenLayer, HiddenNeurons, network)
% insert new individuals removing the worse ones (if worse) to keep
% population size constant

% population : old population
% newIndividuals : new individuals to insert

oldPopulation = population;

% Sort the fitness of the old population
FitnessPopulation = zeros(1,length(population));
for i = 1:length(population)
    FitnessPopulation (i) = MLPforward(population{:,i}',nHiddenLayer,HiddenNeurons,network)
end
[~,SortedIndexes] = sort(FitnessPopulation, 'descend');

oldFitness = FitnessPopulation;
% Extract only the indices of the individuals we will potentially replace
worstSortedIndices = SortedIndexes(end-(length(newIndividuals)-1):end);

% Sort the fitness of the new individuals
FitnessNewIndividuals = zeros(1,length(newIndividuals));
for i = 1:length(FitnessNewIndividuals)
    FitnessNewIndividuals (i) = MLPforward(newIndividuals{:,i}',nHiddenLayer,HiddenNeurons,network);
end
[~,SortedNewIndexes] = sort(FitnessNewIndividuals, 'descend');

FitnessNewIndividuals;

% create a vector in which the worst fitnesses and the new ones will be put
sortingFitnessVector = zeros(1,2*length(newIndividuals));

% Put them
for i = 1:length(sortingFitnessVector)
    if i <= length(worstSortedIndices)
        sortingFitnessVector(i) = FitnessPopulation(worstSortedIndices(i));
    else
        sortingFitnessVector(i) = FitnessNewIndividuals(SortedNewIndexes(i-length(worstSortedIndices)));
    end
end

% All the fitnesses are sorted
[~,SortedFullIndexes] = sort(sortingFitnessVector, 'descend');

% replace the worst individuals of the initial population by the best of
% the set {worst + new}
newInserted = 0;

for i = 1:length(newIndividuals)
    if SortedFullIndexes(i) <= length(newIndividuals)
        population{worstSortedIndices(i)} = oldPopulation{worstSortedIndices(SortedFullIndexes(i))};
    else
        newIndividual = newIndividuals{SortedNewIndexes(SortedFullIndexes(i)-length(newIndividuals))};
        population{worstSortedIndices(i)} = newIndividual;
        newInserted = newInserted+1;
    end
end
display(newInserted);

for i = 1:length(population)
    FitnessPopulation (i) = MLPforward(population{:,i}',nHiddenLayer,HiddenNeurons,network);
end

end