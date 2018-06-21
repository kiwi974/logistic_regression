%% Test script to study the influence of the threshold from which we consider that a wine is "good"


thresholdInf = 5;
thresholdSup = 10;


% ----- Table to store all the results and outputs
res = {};


% -----Start the tests 

for i = thresholdInf:thresholdSup
    disp(["*********** Test for threshold = " num2str(i)]);
    [u,y,c] = wineInfo(i);
    disp(['The number of wines with a quality above ' num2str(i) ' is ' num2str(c)]);
    [a,b,optval] = solveur(u,y);
    res = [res ; {optval,strjoin(string(a)),norm(a,2),b}];
end

cres = cell2table(res);
cres.Properties.VariableNames = {'Optimal_value', 'a','norm_of_a' 'b'};
writetable(cres,'case2_tests.xls','Sheet',1,'Range','A1');
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
    a = x(2:x_size)
    b = x(1)
    optval = cvx_optval;
end




%% Get the descriptors and the associated output vector from red wine data csv file

function [descriptors,scores,count] =  wineInfo(threshold)

    M = csvread('/home/kiwi974/cours/epfl/convex_opti/project/data/winequality-red.csv',1,1);

    descriptors = M(:,1:10);  % Seem to be not bad : 2, 
    scores = M(:,11);

    % If quality >= threshold then the wine is good (new quality = 1) else it is not
    % (new quality = 0)

    count = 0;
    for i = 1:length(scores)
        if (scores(i) >= threshold)
            scores(i) = 1;
            count = count +1;
        else 
            scores(i) = 0;
        end
    end

end