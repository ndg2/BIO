% Breeding function : Crossover


function newIndividual = crossover_sphere(subsetPopulation,nHiddenLayer)
% From the selected subset of the population, we choose 2 parents to
% perform crossover

% select randomly 2 parents among the selected population
indexParents = randperm(length(subsetPopulation), 2);
parent1 = subsetPopulation{indexParents(1)};
parent2 = subsetPopulation{indexParents(2)};

newIndividual = parent1;

% Crossover
if rand(1)>0.5 % optimize bias
    
    % select a random index to chose which bias to change
    biasIndex = randsample(linspace(1,nHiddenLayer+1,nHiddenLayer+1),1,true,[parent1{4,1:nHiddenLayer+1}]);
    
    newIndividual{3,biasIndex} = parent1{3,biasIndex} + parent2{3,biasIndex};
    
    % increase the probability of changing this matrix
    for i=1:nHiddenLayer+1
        newIndividual{4,i} = 0.995*parent1{2,i};
    end
    newIndividual{4,biasIndex} = 1.02*parent1{2,biasIndex};
    
else % optimize weights
    
    % select a random index to chose which matrix to change
    matrixIndex = randsample(linspace(1,nHiddenLayer+1,nHiddenLayer+1),1,true,[parent1{2,1:nHiddenLayer+1}]);
    
    noise = rand(1);
    newIndividual{1,matrixIndex} = noise.*parent1{1,matrixIndex} + (1-noise).*parent2{1,matrixIndex};
    
    % increase the probability of changing this matrix
    for i=1:nHiddenLayer+1
        newIndividual{2,i} = 0.995*parent1{2,i};
    end
    newIndividual{2,matrixIndex} = 1.02*parent1{2,matrixIndex};
end
newIndividual{1,end-1} = getID(newIndividual);
newIndividual{1,end} = 'cross';

end

% function newIndividual = crossover(subsetPopulation,nHiddenLayer)
% % From the selected subset of the population, we choose 2 parents to
% % perform crossover
% 
% indexParents = randperm(length(subsetPopulation), 2);
% parent1 = subsetPopulation{indexParents(1)};
% parent2 = subsetPopulation{indexParents(2)};
% 
% % Crossover
% 
% % Pickup one matrix randomly (that should be different for the two parents)
% matrixIndex = randi(nHiddenLayer+1);
% count = 0;
% if size(parent2{1,matrixIndex}) == 0
% end
% 
% if size(parent1{1,matrixIndex}) == 0
% end
% 
% while parent2{1,matrixIndex} == parent1{1,matrixIndex}
%     matrixIndex = randi(nHiddenLayer+1);
%     count = count+1;
%     if count > 100;
%         break;
%     end
% end
% 
% newIndividual = cell(2,nHiddenLayer+4);
% for i = 1:nHiddenLayer+1
%     if i == matrixIndex
% %         fprintf('ID parent1 : %d \n', getID(parent1));
% %         fprintf('ID parent2 : %d \n', getID(parent2));
%         coef = rand(1);
%         breededMatrix = coef * parent1{1,i} + (1-coef)*parent2{1,i};
%         newIndividual{1,i} = breededMatrix;
%     else
%         newIndividual{1,i} = parent1{1,i};
%     end
% end
% % fprintf('ID child : %d \n', getID(newIndividual));
% 
% % if getID(newIndividual) == getID(parent1) || getID(newIndividual) == getID(parent2)
% %     display('here we are')
% % end
% 
% newIndividual{1,i+1}  = mean([parent1{1,nHiddenLayer+2} parent2{1,nHiddenLayer+2}]); % bias
% noise = (rand(1)-0.5)/(10*newIndividual{1,i+1});
% newIndividual{1,i+1}  = newIndividual{1,i+1} + noise;
% newIndividual{1,i+2} = getID(newIndividual);
% newIndividual{1,i+3} = 'cross';
% end

% function newIndividual = crossover(subsetPopulation,nHiddenLayer)
% % From the selected subset of the population, we choose 2 parents to
% % realise a crossover
%
% indexParents = randperm(size(subsetPopulation, 1), 2);
% parent1 = subsetPopulation(indexParents(1), :);
% parent2 = subsetPopulation(indexParents(2), :);
%
% % Crossover (First half of matrices from parent1 and second half from
% % parent2)
% newIndividual = cell(1,nHiddenLayer+1);
% for i = 1:nHiddenLayer+1
%     if isempty(newIndividual{i}) == false
%         break
%     end
%     newIndividual{i} = parent1{i};
%     if isempty(newIndividual{nHiddenLayer+2-i}) == false
%         break
%     end
%     newIndividual{nHiddenLayer+2-i} = parent2{end+1-i};
% end
% end