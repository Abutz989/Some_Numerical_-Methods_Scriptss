function [X_min_Abs, E_min_Abs, Iter_Num, Eval_Num, last_change]  =  Modify_GA(Eval_fun ,Bounds)
% Eval_fun - evaluation function , IC - initial condition ,Bounds -optional
% bounds
% Iter_Num -  Number of iterations.
% Eval_Num -  Number of function evaluations performed.
% last_Step - Step size on the last iteration.
% last_change - Change in function value on the last iteration.
% XMin, Emin -  Minimum position (x,y) and value.

%% GA initial parametrs
Iter_Num = 0; % generation counter initialized
varhi  =  min(Bounds(2),1e5); varlo = max(Bounds(1),-1e5); % variable limits , 1e5 is the infinty bound for that matter.
n_par  =  2; % number of optimization variables
maxit  =  1e4; % max number of iterations
popsize  =  1e3; % set population size
Eval_Num = 0 ;% number of function evaluations
selection = .5; % fraction of population to be kept for the next generation
keep = floor(selection*popsize); % #population members that survive (not all memebers of current generation are replaced with siblings)
n_mates = ceil((popsize-keep)/2); % number of matings.
next_population = zeros(popsize,n_par); %preallocating the next generation's population
mutrate = 0.2; % set mutation rate
n_mut = ceil(popsize*n_par*mutrate); % total number of mutations
E_min_Abs = 1e6; % large value for defult
X_min_Abs = [0 0]; % initial answer value for defult
%% First evaluation
population = (varhi-varlo)*rand(popsize,n_par)+varlo; % random around mean of variable limits
Fitness = Eval_fun(population(:,1),population(:,2)); % calculates population cost (function value)
[Fitness,ind] = sort(Fitness); % min cost in element 1
population = population(ind,:); % sort continuous
Eval_Num = Eval_Num + popsize;
Xmin = population(1,:);
Emin = Fitness(1);

%% Iterate through generations (Main Loop)
while Iter_Num<maxit
    Iter_Num = Iter_Num+1; % increments generation counter
    X_min_prev = Xmin; % best X of the last round
    
    rndPar  =  randperm(keep); % random list of parents
    parent1  =  rndPar(1:floor(keep/2)); % fathers indexs
    parent2  =  rndPar(floor(keep/2)+1:end);  % mothers indexs

    %% Mating using single point crossover
    ix = 1:2:2*n_mates; % index of mate #1
    xp = randi([1,2],n_mates,1); % crossover point (vector of intergers of 1 and 2)
    r = rand(1,n_mates); % mixing parameter of parent1 and parent2
    for ic = 1:n_mates
        x_new1 = r(ic)*population(parent1(ic),1) + (1-r(ic))*population(parent2(ic),1); % mating the parents so the reset of the population will be childrens
        x_new2 = r(ic)*population(parent2(ic),1) + (1-r(ic))*population(parent1(ic),1);
        y_new1 = r(ic)*population(parent1(ic),2) + (1-r(ic))*population(parent2(ic),2);
        y_new2 = r(ic)*population(parent2(ic),2) + (1-r(ic))*population(parent1(ic),2);
        if xp(ic) == 1 % crossover for x
            next_population(keep+ix(ic),:) = [x_new1,population(parent1(ic),2)]; % 1st offspring
            next_population(keep+ix(ic)+1,:) = [x_new2,population(parent2(ic),2)]; % 2nd offspring
        elseif xp(ic) == 2   % crossover for y
            next_population(keep+ix(ic),:) = [population(parent1(ic),1),y_new1]; % 1st offspring
            next_population(keep+ix(ic)+1,:) = [population(parent2(ic),1),y_new2]; % 2nd offspring
        end
    end
    population(keep+1:end,:) =  next_population(keep+1:end,:);%all children are copied to population

    %% Mutate the population
    rndMut  =  randperm(popsize*n_par); % random list of mutation
    for ii = 1:n_mut
        population(rndMut(ii)) = (varhi-varlo)*rand+varlo; % all mutants insert randomly to the population
    end
    Fitness = Eval_fun(population(:,1),population(:,2)); % calculates population cost (function value)
    [Fitness,ind] = sort(Fitness); % min cost in element 1
    population = population(ind,:); % sort continuous
    Eval_Num = Eval_Num + popsize; % adding the number of evaluations
    Xmin = population(1,:); Emin = Fitness(1); % saving the best answer for now and evaluate it
    % this section comes in case the first citizen became a mutant, so we have to use a copy 
    if Emin<E_min_Abs  
        last_change = E_min_Abs - Emin;
        E_min_Abs = Emin;
        X_min_Abs = Xmin;    
    end
end

end