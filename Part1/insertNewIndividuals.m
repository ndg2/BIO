function population = insertNewIndividuals(population, newIndividuals, nPairs,inputs,nHiddenLayer,HiddenNeurons,DesiredOutputs)
% insert new individuals removing the worse ones (if worse) to keep
% population size constant

% population : old population
% newIndividuals : new individuals to insert

oldPopulation = population;

% Check diversity of the old population
oldPopulationID = zeros(1, length(population));
for i = 1:length(population)
    oldPopulationID(i) = population{i}{1,end-1};
end
oldDiversity = length(unique(oldPopulationID));
% fprintf('number of unique individuals in the old pop : %d\n', oldDiversity);

% Check diversity of the new individuals
newID = zeros(1, length(newIndividuals));
for i = 1:length(newIndividuals)
    newID(i) = newIndividuals{i}{1,end-1};
end
diversityNew = length(unique(newID));

% fprintf('number of new individuals : %d\n', length(newIndividuals))
% fprintf('number of unique new individuals : %d\n', diversityNew)

% Sort the fitness of the old population
FitnessPopulation = zeros(1,length(population));
for i = 1:length(population)
    FitnessPopulation (i) = FitnessValue(nPairs,inputs,nHiddenLayer,HiddenNeurons,population{i},DesiredOutputs);
end

oldFit = FitnessPopulation;

[~,SortedIndexes] = sort(FitnessPopulation);

% Extract only the indices of the individuals we will potentially replace
worstSortedIndices = SortedIndexes(end-(length(newIndividuals)-1):end);

% Sort the fitness of the new individuals
FitnessNewIndividuals = zeros(1,length(newIndividuals));
for i = 1:length(FitnessNewIndividuals)
    FitnessNewIndividuals (i) = FitnessValue(nPairs,inputs,nHiddenLayer,HiddenNeurons,newIndividuals{i},DesiredOutputs);
end
[~,SortedNewIndexes] = sort(FitnessNewIndividuals);
bestIndividual = newIndividuals{SortedNewIndexes(1)};

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
[~,SortedFullIndexes] = sort(sortingFitnessVector);

% replace the worst individuals of the initial population by the best of
% the set {worst + new}

% new individuals inserted
numberNewInserted = 0;

for i = 1:length(newIndividuals)
    if SortedFullIndexes(i) <= length(newIndividuals)
        population{worstSortedIndices(i)} = oldPopulation{worstSortedIndices(SortedFullIndexes(i))};
    else
        newIndividual = newIndividuals{SortedNewIndexes(SortedFullIndexes(i)-length(newIndividuals))};
        population{worstSortedIndices(i)} = newIndividual;
        numberNewInserted = numberNewInserted+1;
    end
end
numberNewInserted
% if rand(1)<0.1 % introduce worst individual every 10 generations
%     population{worstSortedIndices(length(newIndividuals))} = newIndividuals{SortedNewIndexes(end)};
% end


% Check diversity of the new population
newPopulationID = zeros(1, length(population));
for j = 1:length(population)
    newPopulationID(j) = population{j}{1,end-1};
end
newDiversity = length(unique(newPopulationID));
% fprintf('number of unique individuals in the new pop : %d\n', newDiversity);

if oldDiversity ~= newDiversity
%     fprintf('Fitness new individual : %d\n', FitnessNewIndividuals);
%     fprintf('ID new individual : %d\n', getID(newIndividual));
%     display('here we are')
end
end