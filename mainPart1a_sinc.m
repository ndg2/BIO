% MLP Training with GA

clear all
close all

% ANN Structure
nHiddenLayer = 15; % Number of Hidden Layers
HiddenNeurons = [10;10;10;10;10;10;10;10;10;10;10;10;10;10;10]; % Number of neurons on each Hidden Layer
% Parameters
maxiter = 4999; % Maximum number of iterations for GA
dim = 2; % Dimension of input
maxValue = 2;
range = [-5 5];
nPairs = 300; % Number of input-output pairs
nIndividuals = 100; % Number of individuals in population
nSelected = 20; % Number of remaining individuals in the selected subset
nCrossover = 10;
nMutation = 50;
repartition = [];

% Generate Npairs input-output pairs
% [inputs,DesiredOutputs] = GenerateTrainingSet_y_x(dim,nPairs);
[inputs,DesiredOutputs] = GenerateTrainingSetCardinalSine(dim,nPairs,range);

% Generate initial population
neurons = [dim;HiddenNeurons;1];
population = cell(1,nIndividuals); % Cell containing the individuals of the population
W = cell(4,nHiddenLayer+4); % Cell containing the Weights matrices for the MLP
for j = 1:nIndividuals
    for i = 1:nHiddenLayer+1
        W{1,i} = rand(neurons(i+1),neurons(i)).*2-1; % Initial weights random between -1 and 1#
        W{2,i} = 1/(nHiddenLayer+1);
        W{3,i} = rand(1)*2-1;
        W{4,i} = 1/(nHiddenLayer+1);
    end
    W{1,i+2} = getID(W);
    W{1,i+3} = 'init';
    population{j} = W;
end

% Analyze fitness for the initial population
FitnessPopulation = zeros(1,length(population));
for i = 1:length(population)
    FitnessPopulation (i) = FitnessValue(nPairs,inputs,nHiddenLayer,HiddenNeurons,population{i},DesiredOutputs);
end

[~,SortedIndexes] = sort(FitnessPopulation);

bestIndividualTypes = zeros(1,maxiter+1);
bestIndividualTypes(1) = 0;
bestMeaningfulError = zeros(1,maxiter+1);
bestMeaningfulError(1) = 100;
bestAccuracies = zeros(1,maxiter+1);
bestAccuracies(1) = sqrt(FitnessPopulation(SortedIndexes(1))/nPairs)/maxValue;
averageAccuracies = zeros(1,maxiter+1);
averageAccuracies(1) = sqrt(mean(FitnessPopulation)/nPairs)/maxValue;
bestIndividuals = cell(1,maxiter+1);
bestIndividuals{1} = population{SortedIndexes(1)};
repartition = [repartition getTypeIndividual(population)];

populationID = zeros(1, nIndividuals);
for i = 1:nIndividuals
    populationID(i) = population{i}{1,end-1};
end
diversity = zeros(1,maxiter+1);
diversity(1) = length(unique(populationID));

%% Genetic Algorithm
figure

for counter = 1:maxiter
    % Display the position in the loop in case of long computation
    display(counter)
    
    [~,SortedIndexes] = sort(FitnessPopulation);
    
    subsetPopulation = cell(1, nSelected);
    for i = 1:nSelected
        subsetPopulation{i} = population{SortedIndexes(i)};
    end
    
    newIndividuals = cell(1,nCrossover + nMutation);
    
    % create all the new individuals
    for index = 1:(nCrossover + nMutation)
        
        % create either a crossover child or a mutant child
        if index <= nCrossover
            newIndividuals{index} = crossover_sinc(subsetPopulation,nHiddenLayer);
        else
            newIndividuals{index} = mutate_sinc(population,nHiddenLayer,SortedIndexes);
        end
    end
    
    % insert best of the new individuals if they are better
    population = insertNewIndividuals(population, newIndividuals, nPairs,inputs,nHiddenLayer,HiddenNeurons,DesiredOutputs);
    
    for i = 1:length(population)
        FitnessPopulation (i) = FitnessValue(nPairs,inputs,nHiddenLayer,HiddenNeurons,population{i},DesiredOutputs);
    end
    
    m = mean(FitnessPopulation);
    
    % Fill the bestFitnesses and averageFitnesses with the values for this
    % generation and move on
    [~,inSortedPopulation] = sort(FitnessPopulation);
    inBestIndividual = population{inSortedPopulation(1)};
    
    bestIndividual = population{inSortedPopulation(1)};
    if strcmp(bestIndividual{1,end}, 'init')
        bestIndividualTypes(counter+1) = 0;
    else if strcmp(bestIndividual{1,end}, 'mutant')
            bestIndividualTypes(counter+1) = 1;
        else
            bestIndividualTypes(counter+1) = 2;
        end
    end
    
    bestIndividuals{1+counter} = bestIndividual;   
    bestMeaningfulError(counter+1) = meaningfulError(bestIndividual, nPairs,inputs,nHiddenLayer,HiddenNeurons,DesiredOutputs);
    bestAccuracies(counter+1) = sqrt(FitnessPopulation(inSortedPopulation(1))/nPairs)/maxValue;
    averageAccuracies(counter+1) = sqrt(mean(FitnessPopulation)/nPairs)/maxValue;
    repartition = [repartition getTypeIndividual(population)];
    
    populationID = zeros(1, nIndividuals);
    for i = 1:nIndividuals
        populationID(i) = population{i}{1,end-1};
    end
    diversity(counter+1) = length(unique(populationID));
    
    subplot(2,1,1)
    hold off;
    plot(100*averageAccuracies, 'b')
    hold on;
    plot(100*bestAccuracies, 'g')
    plot(bestMeaningfulError, 'r')
    
    x = counter/2;
    y = 20;
    txt = strcat('Best Accuracy : ',num2str(100*bestAccuracies(counter+1)));
    txt2 = strcat('Relative Error : ',num2str(bestMeaningfulError(counter+1)));
    text(x, y, txt);
    text(x, 2*y, txt2);
    title('Best Fitness, Average Fitness and Relative Error')
    
    subplot(2,1,2)
    plot(bestIndividualTypes, '.black')
    ylim([0 3]);
    x = [2 2 2];
    y = [0.3 1.3 2.3];
    text(x(1), y(1), 'original');
    text(x(2), y(2), 'mutant');
    text(x(3), y(3), 'crossed')
    title('Best Individual Type')
    drawnow;
end

nPairs = 100;
subplot(2,4,1)
hold on;
plot(100*averageAccuracies, 'b')
plot(100*bestAccuracies, 'g')
plot(bestMeaningfulError, 'r')
x = counter/4;
y = 30;
text(x, y, txt);
text(x, 2*y, txt2);
title('Best Accuracy, Average Accuracies and Relative Error')

[~,SortedPopulation] = sort(FitnessPopulation);
BestIndividual = population{SortedPopulation(1)};
BestFitness = FitnessPopulation(SortedPopulation(1));

subplot(2,4,5);
hold on;
area([repartition(3,:)' repartition(2,:)' repartition(1,:)'])
title('Repartition of individuals')

subplot(2,4,4);
hold on;
plot(bestIndividualTypes, '.black')
ylim([0 3]);
x = [2 2 2];
y = [0.3 1.3 2.3];
text(x(1), y(1), 'original');
text(x(2), y(2), 'mutant');
text(x(3), y(3), 'crossed')

title('Best Individual Type')

subplot(2,4,8);
plot(diversity)
title('Number of individuals')

subplot(2,4,[2 3 6 7])
MLPoutput = zeros(1,nPairs);
for i = 1:nPairs
    MLPoutput(i) = MLPforward(inputs(i,:)',nHiddenLayer,HiddenNeurons,BestIndividual);
    error = (abs(DesiredOutputs(i)-MLPoutput(i)))/(0.1*maxValue);
    if error >1
        error = 1;
    end
    scatter3(inputs(i,1),inputs(i,2),DesiredOutputs(i), 'o', 'LineWidth', 0.5, 'MarkerEdgeColor', [error 1-error 0], 'MarkerFaceColor', [error 1-error 0]); % Plot Training Set
    hold on
    grid on
end
title('Desired Output and best MLP output')


nPairs = 50000;
range = [-5 5];

inputs = zeros(nPairs,dim);
for i = 1:dim
    inputs(:,i) = range(1) + (range(2)-(range(1))).*rand(nPairs,1); % Random [-2,2]
end
figure;
% Visualisation of the MLPs
for k=1:1
    MLPoutput = zeros(1,nPairs);
    for i = 1:nPairs
        MLPoutput(i) = MLPforward(inputs(i,:)',nHiddenLayer,HiddenNeurons,bestIndividual);
    end
    clf;
    scatter3(inputs(:,1),inputs(:,2),MLPoutput, '.', 'LineWidth', 1, 'MarkerEdgeColor', 'blue', 'MarkerFaceColor', 'blue');
    drawnow;
end

RealOutput = zeros(nPairs,1);

output = 0;
for j = 1:dim
    output = output + sin(inputs(:,j))./inputs(:,j);
end
RealOutput = output;

hold on;
scatter3(inputs(:,1),inputs(:,2),RealOutput, '.', 'LineWidth', 1, 'MarkerEdgeColor', 'red', 'MarkerFaceColor', 'red');
