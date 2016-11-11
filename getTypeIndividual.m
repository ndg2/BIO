function repartition = getTypeIndividual(population)

    numberInitialIndividuals = 0;
    numberCrossedIndividuals = 0;
    numberMutantIndividuals = 0;
    
    for i =1:length(population)
        currentIndividual = population{i};
        if strcmp(currentIndividual{1,end},'init')
            numberInitialIndividuals = numberInitialIndividuals + 1;
        else if strcmp(currentIndividual{1,end},'cross')
                numberCrossedIndividuals = numberCrossedIndividuals + 1;
            else if strcmp(currentIndividual{1,end},'mutant')
                    numberMutantIndividuals = numberMutantIndividuals + 1;
                end
            end
        end      
    end
    repartition = [numberInitialIndividuals ; numberCrossedIndividuals ; numberMutantIndividuals];
end