function xbest = MY_OPTIMIZER(FUN, DIM, ftarget, maxfunevals)
% MY_OPTIMIZER(FUN, DIM, ftarget, maxfunevals)
% samples new points uniformly randomly in [-5,5]^DIM
% and evaluates them on FUN until ftarget of maxfunevals
% is reached, or until 1e8 * DIM fevals are conducted.
global a reached

popsize = 150; % Size of the population
nselected = 7; % Size of selected population

% 1 is Best in the Population
% 2 is Tournament Selection
selection = 1;
tsize = 5; % Tournament size

% 1 is Random Value in Random Component
% 2 is Small Random Addition/Substraction
% 3 is a combination
mutate = 3;
combination_factor = 0.5;

% Initial Population
population = 10*rand(DIM, popsize)-5;

% Analyse fitness of initial population and sort them
popfitness = feval(FUN,population);
[popfitness,sortIndpop] = sort(popfitness);
population = population(:,sortIndpop);

for iter = 1:100
    
    % Selection
    switch selection
        case 1
            % Best
            popselection = population(:,1:nselected);
        case 2
            % Tournament Selection
            tournament = zeros(size(population,1),tsize);
            popselection = zeros(size(population,1),nselected);
            for i = 1:nselected
                for t = 1:tsize
                    tournament(:,t) = population(:,randi([1 popsize]));
                end
                tourfitness = feval(FUN,tournament);
                [~,sortIndtour] = sort(tourfitness);
                popselection(:,i) = tournament(:,sortIndtour(1));
            end
    end
    
    % Mutation        
    switch mutate
        case 1
            % Random Value in Random Component
            component = randi([1 size(population,1)],[1,nselected]); % Component for each individual
            substitutes = 10*rand(1, nselected)-5; % Substitute value
            for i = 1:nselected
                popselection(component(i),i) = substitutes(i); % Replace
            end
        case 2
            % Small Random Addition/Substraction
            component = randi([1 size(population,1)],[1,nselected]); % Component for each individual
            factors = -1 + (1+1).*rand(1,nselected); % Factor for each individual
            maxdiff = 1; % Maximum value that can be added/substracted
            differ = maxdiff*factors; % Value that will be add/subtracted
            for j = 1:nselected
                popselection(component(j),j) = popselection(component(j),j)+differ(j);
            end
        case 3
            RVRCn = ceil(combination_factor*nselected);
            SRASn = nselected-RVRCn;
            ix = randperm(nselected);
            popselection = popselection(:,ix);
            RVRCind = popselection(:,1:RVRCn); % Individuals that will get RVRC
            SRASind = popselection(:,end-(SRASn-1):end); % Individuals that will get SRAS
            % RVRC
            component = randi([1 size(population,1)],[1,RVRCn]); % Component for each individual
            substitutes = 10*rand(1, RVRCn)-5; % Substitute value
            for i = 1:RVRCn
                popselection(component(i),i) = substitutes(i); % Replace
            end
            % SRAS
            component = randi([1 size(population,1)],[1,SRASn]); % Component for each individual
            factors = -1 + (1+1).*rand(1,SRASn); % Factor for each individual
            maxdiff = 0.2; % Maximum value that can be added/substracted
            differ = maxdiff*factors; % Value 
            c = 0;
            for j = nselected-SRASn+1:nselected
                c = c+1;
                popselection(component(c),j) = popselection(component(c),j)+differ(c);
            end
    end
    
    % Analyse fitness of mutated individuals
    popselectionfitness = feval(FUN,popselection);
    [~,sortInd] = sort(popselectionfitness);
    
    % If the mutated individuals are better than other members of the
    % population, replace them in the population and fitness variables
    for i = 1:popsize
        if isempty(sortInd) == 0
            if popfitness(i) > popselectionfitness(sortInd(1))
                if i == 1
                    popfitness = [popselectionfitness(sortInd(1)), popfitness(1:end-i)];
                    population = [popselection(:,sortInd(1)), population(:,1:end-i)];
                else
                    popfitness = [popfitness(1:i-1), popselectionfitness(sortInd(1)), popfitness(i:end-1)];
                    population = [population(:,1:i-1), popselection(:,sortInd(1)), population(:,i:end-1)];
                end
                sortInd(1) = [];
            end
        end
    end
    
    % Select best fitness
    fbest = popfitness(1);
    
    if feval(FUN, 'fbest') < ftarget         % COCO-task achieved
        reached = reached+1;
        break;                                 % (works also for noisy functions)
    end
end
xbest = population(:,1);
a = [a;feval(FUN, 'fbest') ftarget];
end


