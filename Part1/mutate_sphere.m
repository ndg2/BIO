% Breeding function : mutate

function newIndividual = mutate_sphere(population,nHiddenLayer,sortedIndices)
% From the selected subset of the population, we choose 1 parent to
% realise a mutation

% select an individual among the mutation
indexParents = randi(length(population));
parent = population{indexParents};

newIndividual = parent;

if rand(1)>0.5 % optimize bias
    
    % select a random index to chose which bias to change
    biasIndex = randsample(linspace(1,nHiddenLayer+1,nHiddenLayer+1),1,true,[parent{4,1:nHiddenLayer+1}]);
    
    noise = 0.2*(rand(size(parent{3,biasIndex}))-0.5);
    newIndividual{3,biasIndex} = parent{3,biasIndex} + noise;
    
    % increase the probability of changing this matrix
    for i=1:nHiddenLayer+1
        newIndividual{4,i} = 0.995*parent{2,i};
    end
    newIndividual{4,biasIndex} = 1.02*parent{2,biasIndex};
    
else % optimize weights
    
    % classify this individual as good, medium or bad
    class = 'medium';
    if ismember(indexParents, sortedIndices(1:fix(length(sortedIndices)/3)))
        class = 'good';
    else if ismember(indexParents, sortedIndices(end-fix(length(sortedIndices)/3):end))
            class = 'bad';
        end
    end
    
    % select a random index to chose which matrix to change
    matrixIndex = randsample(linspace(1,nHiddenLayer+1,nHiddenLayer+1),1,true,[parent{2,1:nHiddenLayer+1}]);
    columnIndex = randsample(linspace(1, size(parent{1,matrixIndex},2), size(parent{1,matrixIndex},2)), 1, true);
    
    matrix = parent{1,matrixIndex};
    column = matrix(:,columnIndex);
    
    %     if strcmp(class,'good')
    %         noise = 0.05*(rand(size(parent{1,matrixIndex}))-0.5);
    %     else if strcmp(class,'medium')
    %             noise = 0.1*(rand(size(parent{1,matrixIndex}))-0.5);
    %         else
    %             noise = 0.2*(rand(size(parent{1,matrixIndex}))-0.5);
    %         end
    %     end
    %     newIndividual{1,matrixIndex} = parent{1,matrixIndex} + noise;
    
    if strcmp(class,'good')
        noise = 0.5*(rand(length(column),1)-0.5);
    else if strcmp(class,'medium')
            noise = 0.7*(rand(length(column),1)-0.5);
        else
            noise = 0.9*(rand(length(column),1)-0.5);
        end
    end
    column = column+noise;
    matrix(:,columnIndex) = column;
    newIndividual{1,matrixIndex} = matrix;
    
    
    % increase the probability of changing this matrix
    for i=1:nHiddenLayer+1
        newIndividual{2,i} = 0.995*parent{2,i};
    end
    newIndividual{2,matrixIndex} = 1.02*parent{2,matrixIndex};
end
newIndividual{1,end-1} = getID(newIndividual);
newIndividual{1,end} = 'mutant';

end

% function newIndividual = mutate(subsetPopulation,nHiddenLayer)
% % From the selected subset of the population, we choose 1 parent to
% % realise a mutation
%
% indexParents = randi(length(subsetPopulation));
% parent = subsetPopulation{indexParents};
%
% matrixIndex = randi(nHiddenLayer+1);
%
% newIndividual = cell(2,nHiddenLayer+4);
% % Mutate individual (Replace randomly chosen matrix with random matrix)
% for i = 1:nHiddenLayer+1
%     if i == matrixIndex
%         mutatedMatrix = parent{1,i}; % the child will be mostly based on the parent
%
%         % pickup one column randomly
%         columnIndex = randi(size(parent{1,i}, 2));
%
%         % place the chosen column from parent2 in the child
%         mutatedMatrix(:,columnIndex) = rand(size(parent{1,i}, 1),1);
%
%         newIndividual{1,i} = mutatedMatrix;
%     else
%         newIndividual{1,i} = parent{1,i};
%     end
% end
%
% noise = (rand(1)-0.5)/(parent{1,i+1});
% newIndividual{1,i+1} = parent{1,i+1} + noise; % bias
% newIndividual{1,i+2} = getID(newIndividual);
% newIndividual{1,i+3} = 'mutant';
% end


% function newIndividual = mutate(subsetPopulation,nHiddenLayer)
% % From the selected subset of the population, we choose 1 parent to
% % realise a mutation
%
% indexParents = randi(size(subsetPopulation, 1));
% parent = subsetPopulation(indexParents, :);
%
% newIndividual = parent;
% % Mutate individual (Replace randomly chosen matrix with random matrix)
%     choose = randi([1,nHiddenLayer+1]); % Choose randomly one matrix of Wnew
%     mutation = rand(size(newIndividual{choose})); % Create random matrix
%     newIndividual{choose} = mutation; % Replace matrix
% end