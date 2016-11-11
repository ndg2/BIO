% MLP Forward Program
function output = MLPforward(input,nHiddenLayer,HiddenNeurons,W)
% input: column vector containing the inputs to the MLP
% nHiddenLayer: Number of hidden layers
% HiddenNuerons: Number of neurons on each hidden layer

%% Initialization
nlayer = 1 + nHiddenLayer;
a = 1; % a factor of hyperbolic activation function a*tanh(W.*p)
p = 0.5; % p factor of hyperbolic activation function a*tanh(W.*p)

% bias = 0.5; % Bias parameter


% X{1} corresponds to the input to hidden layer 1
% X{2} corresponds to the input to hidden layer 2...
X = cell(1,nlayer);

% Y{1} corresponds to the output of hidden layer 1
% Y{2} corresponds to the output of hidden layer 2...
Y = cell(1,nlayer);

%% Forward process
for i = 1:nlayer
    if i == 1 % First layer uses input
        X{1} = W{1,1}*input+W{3,1};
        Y{i} = tanh(X{i}.*p); % Activation function: linear
    else if i < nlayer
            X{i} = W{1,i}*Y{i-1}+W{3,i}; % weigth*input + bias
            Y{i} = tanh(X{i}.*p); % Activation function: hyperbolic tangent
        else
            X{i} = W{1,i}*Y{i-1}+W{3,i};
            Y{i} = (100*((tanh(X{i}.*p)))); % Activation function: linear between 0 and 2 (maxValue)           
        end
    end
end

%% Output
output = Y{end};
if length(output) > 1

end
end