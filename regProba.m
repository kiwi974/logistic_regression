% Plot the probablity according to one variable only


function regProba()
       
    abs = linspace(-15,15,1000);
    colors = ['-r', '-b', '-c', '-k', '-m'];

    % Plot according to a
    aValues = [-10 -2 0 2 10];
    na = length(aValues);
    
    figure(1)
    hold on 
    
    for i = 1:na
        pa = @(b)proba(aValues(i),b,1);
        orda = pa(abs);
        plot(abs,orda,colors(i));
    end
    legend(['a = ' num2str(-10)], ['a = ' num2str(-2)], ['a = ' num2str(0)], ['a = ' num2str(2)], ['a = ' num2str(10)]);
    
    hold off
    

    % Plot according to b
    bValues = [-10 -2 0 2 10];
    nb = length(bValues);
    
    figure(2)
    hold on 
    
    for i = 1:nb
        p = @(a)proba(a,bValues(i),1);
        ord = p(abs);
        plot(abs,ord,colors(i));
    end
    legend(['b = ' num2str(-10)], ['b = ' num2str(-2)], ['b = ' num2str(0)], ['b = ' num2str(2)], ['b = ' num2str(10)]);
    
    hold off
    
    % Plot according to both a and b 
    figure(3)
    
    x = linspace(-30,30,1000);
    [X,Y] = meshgrid(x,x);
    Z = proba(X,Y,1);
    mesh(X,Y,Z);
    grid on

end


function p = proba(a,b,u)
    p = exp(a*u+b)./(1+exp(a*u+b));
end
