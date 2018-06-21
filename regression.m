% Section 7.1.1
% Boyd & Vandenberghe, "Convex Optimization"
% Original by Lieven Vandenberghe
% Adapted for CVX by Argyris Zymnis - 01/31/06
%
% We consider a binary random variable y with prob(y=1) = p and
% prob(y=0) = 1-p. We assume that that y depends on a vector of
% explanatory variables u in R^n. The logistic model has the form
% p = exp(a'*u+b)/(1+exp(a'*u+b)), where a and b are the model parameters.
% We have m data points (u_1,y_1),...,(u_m,y_m).
% We can reorder the data so that for u_1,..,u_q the outcome is y = 1
% and for u_(q+1),...,u_m the outcome is y = 0. Then it can be shown
% that the ML estimate of a and b can be found by solving
%
% maximize sum_{i=1,..,q}(a'*u_i+b) - sum_i(log(1+exp(a'*u_i+b)))
%
% In this case we have m = 100 and the u_i are just scalars.
% The figure shows the data as well as the function
% f(x) = exp(aml*x+bml)/(1+exp(aml*x+bml)) where aml and bml are the
% ML estimates of a and b.

randn('state',0);
rand('state',0);

% Generate data
a =  1;
b = -5 ;


disp('What would you like to study ?')
disp(' 1 : Default cvx data');
disp(' 2 : Probability to pass exam w.r.t studying hours number');
disp(' 3 : Probability for a red wine to have good taste w.r.t volatile acidity');

mode = input('Make you choice : ');

if (mode == 1)
    m = 100;
    u = 10*rand(m,1);
    y = (rand(m,1) < exp(a*u+b)./(1+exp(a*u+b)));
elseif (mode == 2)
    m = 20;
    u1 = 0.5:0.25:1.75;
    u2 = 1.75:0.25:3.5;
    u3 = 4.0:0.25:5.0;
    u = [u1 u2 u3 5.5]';
    y = [0 0 0 0 1 1 1 1 0 0 0 0 0 0 0 0 1 1 1 1]';
elseif (mode == 3)
    [u,y] = wineInfo(7);
    m = length(y);
end
   
plot(u,y,'o')
axis([-1,11,-0.1, 1.1]);

% Solve problem

U = [ones(m,1) u];
x_size = length(U(1,:));
cvx_expert true
cvx_begin
    variables x(x_size)
    maximize(y'*U*x-sum(log_sum_exp([zeros(1,m); x'*U'])))
cvx_end

% Plot results and logistic function

ind1 = find(y==1);
ind2 = find(y==0);

aml = x(2);  bml = x(1);
us = linspace(-1,11,1000)';
ps = exp(aml*us + bml)./(1+exp(aml*us+bml));

disp(["Coefficients found : b = " num2str(bml) "and a = "]);
x(2:x_size)

dots = plot(us,ps,'-', u(ind1),y(ind1),'o',...
     u(ind2),y(ind2),'o');

axis([-1, 11,-0.1,1.1]);
xlabel('x');
ylabel('y');








function [descriptors,scores] =  wineInfo(threshold)

    M = csvread('/home/kiwi974/cours/epfl/convex_opti/project/data/winequality-red.csv',1,1);

    descriptors = M(:,1:10);  % Seem to be not bad : 2, 
    scores = M(:,11);

    % If quality >= threshold then the wine is good (new quality = 1) else it is not
    % (new quality = 0)

    for i = 1:length(scores)
        if (scores(i) >= threshold)
            scores(i) = 1;
        else 
            scores(i) = 0;
        end
    end

end