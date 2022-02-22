function sol_itr = iterative_solver(G,c,x0,k)
 
Extra_Respect = false; % true - solving without loop

if Extra_Respect
   % without loop x_{k+1} = G^k*x_0 + sum((1+G+..G^{k-1}))*c
   % Note :  that requires a lot of memory , make probloms while runnning
   % large k number and large matrix
    if k > 0
        % First -craete the power series  (1+G+..G^{k-1}) using handle function
        powElment =@(G, n) G^n;
        G_series_0 =  arrayfun(@(x) powElment(G,x),[0:1:(k-1)],'UniformOutput',false);
        G_series = cat(3,G_series_0{:});

        % Now we can implement : x_{k+1} = G^k*x_0 + sum((1+G+..G^{k-1}))*c
        sol_itr = G^k*x0 + sum(G_series,3)*c;

    else
        sol_itr = x0;
    end
else
    % loop , every step x_{k+1} = G * x_k + c
    sol_itr = x0;
    for n=1:k
        sol_itr = G*sol_itr+c;
    end
    
    
end


end
