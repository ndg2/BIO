% RUN TEST AND VISUALIZER OF ERROR

global a reached
ntests=10;

n = zeros(1,ntests);
nr = zeros(1,ntests);
reached = 0;

for i = 1:ntests
a = [];
exampleexperiment
visualization
n(i) = norm;
nr(i) = normrelative;
end

reached
average_error = mean(n);
average_relative_error = mean(nr);
[average_error average_relative_error]