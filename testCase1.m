%% Test script to study the influence of the values in Y on the probability found

% ----- Building of the table of descriptors, i.e. the number of studying hours

u1 = 0.5:0.25:1.75;
u2 = 1.75:0.25:3.5;
u3 = 4.0:0.25:5.0;
u = [u1 u2 u3 5.5]';

% ----- Building the different corresponding outputs
    
y0 = [0 0 0 0 0 0 1 0 1 0 1 0 1 0 1 1 1 1 1 1]';

% -> Influence of the middle 1 in the ouput
y1 = [0 0 0 0 0 0 0 0 0 0 1 0 1 0 1 1 1 1 1 1]';
y2 = [0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 1 1 1 1 1]';

% -> Influence of the position of the first 1 in the ouput
y3 = [1 0 0 0 0 0 1 0 1 0 1 0 1 0 1 1 1 1 1 1]';
y4 = [0 0 0 0 0 0 0 0 1 0 1 0 1 0 1 1 1 1 1 1]';

% -> What if two "masses" in the ouput ? 
y5 = [0 0 0 0 1 1 1 1 0 0 0 0 0 0 0 0 1 1 1 1]';

% -> What about a "perturbation" in the output ? 
y6 = [0 0 1 0 0 0 0 0 0 0 0 0 0 0 1 1 1 1 1 1]';


% ----- Table to store all the results and outputs
res = {};
outputs = [y0 y1 y2 y3 y4 y5 y6];


% -----Start the tests 

disp("Would you like to plot the probability curves ?");
disp(" 0 : No ");
disp(" 1 : Yes ");
choice = input('Please, make you choise : ');



for i = 1:length(outputs(1,:))
    disp(["*********** Test for y" num2str(i-1)]);
    y = outputs(:,i);
    [a,b,optval] = solveur(u,y);
    res = [res ; {optval,a,b}];
    
    if (choice)
        clear plot
        figure()
        plot(u,y,'o')
        axis([-1,11,-0.1, 1.1]);
        ind1 = find(y==1);
        ind2 = find(y==0);

        us = linspace(-1,11,1000)';
        ps = exp(a*us + b)./(1+exp(a*us+b));
        
        hold on
        plot(us,ps,'-', u(ind1),y(ind1),'o',...
                    u(ind2),y(ind2),'o');

        axis([-1, 11,-0.1,1.1]);
        chr = " y" + num2str(i-1) + " = " + mat2str(y);
        title(chr);
        xlabel('Number of studying hours', 'fontsize', 22);
        ylabel('Probability to pass the exam', 'fontsize', 22);
        
        % Save the plot 
        filename = "y" + num2str(i-1);
        print(filename,'-dpng');
         
    end
end

cres = cell2table(res);
cres.Properties.VariableNames = {'Optimal_value', 'a', 'b'};
writetable(cres,'case1_tests.xls','Sheet',1,'Range','A1');
disp(cres);





%% Solve the minimization problem

function [a,b,optval] = solveur(u,y)
    m = length(y(:,1));
    U = [ones(m,1) u];
    x_size = length(U(1,:));
    cvx_expert true
    cvx_begin
        variables x(x_size)
        maximize(y'*U*x-sum(log_sum_exp([zeros(1,m); x'*U'])))
    cvx_end
    a = x(2)
    b = x(1)
    optval = cvx_optval;
end