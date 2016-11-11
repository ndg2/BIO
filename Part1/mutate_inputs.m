function individual = mutate_inputs(dim, range)

individual = (range(end)-range(1))*rand(1, dim)+range(1);

end