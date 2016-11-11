function ID = getID(individual)
ID = 0;
compteur = 0.73;

for i = 1:length(individual)-2
    for j = 1:size(individual{i}, 1)
        for k = 1:size(individual{i}, 2)
            ID = ID + individual{i}(j,k) * compteur;
            compteur = compteur + 0.73;
        end
    end
end

individual{end-1} = ID;
end