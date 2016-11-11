% Compute the error for all the analyzed functions

% Absolute difference between minmum value found and global minumum
diff = abs(a(:,1)-a(:,2));

% Addition of errors
total = sum(diff);

% Relative error
relative = abs(diff./a(:,2));

% Normalize error 
norm = total/length(diff);
normrelative = sum(relative)/length(diff);
normstring = num2str(norm);
normrelativestring = num2str(normrelative);

% Plot
figure
subplot(1,2,1)
plot(diff)
dim = [.15 .5 .3 .3];
str = strcat('Normalized total error = ',normstring);
annotation('textbox',dim,'String',str,'FitBoxToText','on');
subplot(1,2,2)
plot(relative)
dim = [.58 .5 .3 .3];
strrelative = strcat('Normalized relative error = ',normrelativestring);
annotation('textbox',dim,'String',strrelative,'FitBoxToText','on');