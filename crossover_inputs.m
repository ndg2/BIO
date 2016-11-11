function individual = crossover_inputs(subPopulation)

indexParents = randperm(length(subPopulation), 2);
parent1 = subPopulation{indexParents(1)};
parent2 = subPopulation{indexParents(2)};

individual = (parent1+parent2)/2;

end