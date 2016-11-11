clear all;
close all;

network = load('network_5000G_10x10x10x10x10x10x10x10x10x10x10x10x10x10x10_300P_sinc', 'bestIndividual');
network = network.bestIndividual;

nHiddenLayer = 15;
HiddenNeurons = [10;10;10;10;10;10;10;10;10;10;10;10;10;10;10];
nPairs = 50000;
dim = 2;
range = [-5 5];
inputs = (range(end)-range(1))*rand(nPairs, dim)+range(1);

% Visualisation of the MLP
MLPoutput = zeros(1,nPairs);
for i = 1:nPairs
    MLPoutput(i) = MLPforward(inputs(i,:)',nHiddenLayer,HiddenNeurons,network);
end

% figure;
% scatter3(inputs(:,1),inputs(:,2),MLPoutput, '.', 'LineWidth', 2, 'MarkerEdgeColor', 'blue', 'MarkerFaceColor', 'blue');

% Search of the global minimum

maxiter = 99;
sizeSelectedPopulation = 5;
nCrossover = 4;
nMutation = 1;

sizePopulation = 10;
population = cell(1,sizePopulation);

for i=1:sizePopulation
    population{i} = (range(end)-range(1))*rand(1, dim)+range(1);
end

% Analyze fitness for the initial population
fitnessPopulation = zeros(1,length(population));
for i=1:sizePopulation
    fitnessPopulation(i) = MLPforward(population{:,i}',nHiddenLayer,HiddenNeurons,network);
end
[~,SortedIndexes] = sort(fitnessPopulation);

bestAccuracies = zeros(1,maxiter+1);
bestAccuracies(1) = fitnessPopulation(SortedIndexes(1));
averageAccuracies = zeros(1,maxiter+1);
averageAccuracies(1) = mean(fitnessPopulation);


for i=1:maxiter
    fitnessPopulation = zeros(1, sizePopulation);
    for j=1:sizePopulation
        fitnessPopulation(j) = MLPforward(inputs(j,:)',nHiddenLayer,HiddenNeurons,network);
    end
    
    [~,sortedIndex] = sort(fitnessPopulation);
    subPopulation = population(sortedIndex(1:sizeSelectedPopulation));
    
    newIndividuals = cell(1,nCrossover + nMutation);
    
    % create all the new individuals
    for j = 1:(nCrossover + nMutation)
        % create either a crossover child or a mutant child
        if j <= nCrossover
            newIndividuals{j} = crossover_inputs(subPopulation);
        else
            newIndividuals{j} = mutate_inputs(dim, range);
        end
    end
    
    % insert best of the new individuals if they are better
    population = insertNewInputs(population, newIndividuals,inputs,nHiddenLayer,HiddenNeurons,network);
    
    for j = 1:length(population)
        fitnessPopulation (j) = MLPforward(population{:,j}',nHiddenLayer,HiddenNeurons,network);
    end
    
    m = mean(fitnessPopulation);
    
    % Fill the bestFitnesses and averageFitnesses with the values for this
    % generation and move on
    [~,inSortedIndices] = sort(fitnessPopulation);
    
    bestAccuracies(1+i) = fitnessPopulation(inSortedIndices(1));
    averageAccuracies(1+i) = mean(fitnessPopulation);
    
    bestIndividual = population(inSortedIndices(1));
    hold off
    plot(averageAccuracies, 'b')
    hold on
    plot(bestAccuracies, 'r')
    
    x = i/2;
    y = 0.5;
    txt = strcat('Best Fitness : ',num2str(bestAccuracies(i+1)));
    text(x, y, txt);
    title('Best Fitness and Average Fitness')
    drawnow;
    
end

% Visualisation of the MLP
MLPoutput = zeros(1,nPairs);
for i = 1:nPairs
    MLPoutput(i) = MLPforward(inputs(i,:)',nHiddenLayer,HiddenNeurons,network);
end

figure;
scatter3(inputs(:,1),inputs(:,2),MLPoutput, '.', 'LineWidth', 1, 'MarkerEdgeColor', 'blue', 'MarkerFaceColor', 'blue');
hold on;
scatter3(bestIndividual{1}(1),bestIndividual{1}(2),bestAccuracies(end), 'o', 'LineWidth', 5, 'MarkerEdgeColor', 'red', 'MarkerFaceColor', 'red');

[X, Y, Z] = meshgrid(-1:1,-1:1,bestAccuracies(end));
surf(X,Y,Z, 'FaceColor', [1 0 0], 'FaceAlpha', 0.5);
