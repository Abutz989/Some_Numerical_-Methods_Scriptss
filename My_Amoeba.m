function [XMin, Emin, Iter_Num, Eval_Num, last_Step_size, last_change] = My_Amoeba( Eval_fun , IC ,Bounds)
%% Downhill function from the tutorial.
% Eval_fun - evaluation function , IC - initial condition ,Bounds -optional
% bounds
% Iter_Num -  Number of iterations.
% Eval_Num -  Number of function evaluations performed.
% last_Step - Step size on the last iteration.
% last_change - Change in function value on the last iteration.
% XMin, Emin -  Minimum position (x,y) and value.

%% Downhill initial parametrs
Max_iter = 1e4; %maximal number of iterations
conv_value = 1e-4; %convergence criteria  to ||𝑥𝑖+1 − 𝑥𝑖 || 

X = [IC ; IC+sqrt(2)*[1,1] ; IC+sqrt(2)*[1,-1]]; % initial X =[x0,x1,x2] triangle
Fitness = Eval_fun(X(:,1),X(:,2)); % calculates X cost (function value)
[Fitness,ind] = sort(Fitness,'descend'); % min cost in element 3
X = X(ind,:); % sort x0 x1 x2
Eval_Num = 3; % count evaluations

%% claculation
for Iter_Num = [1:Max_iter]
    E_best_prev = Fitness(3); % the best eval' for now
    mid_point = X(2,:)+(X(3,:)-X(2,:))/2; % calculate the mid point by  geometry
    X_new = mid_point + mid_point - X(1,:); % do reflection
    X_new = x_sat(X_new,Bounds); % saturate x with bounds
    E_New = Eval_fun(X_new(1),X_new(2)); % evalute the new x
    Eval_Num = Eval_Num+1; % count evaluations
    last_Step_size = 2*norm(mid_point - X(1,:),2); % calculate step size
    if E_New < Fitness(3,:) % if x new is the best
        X_new = mid_point + 2*(mid_point - X(1,:)); % reflection and expansion (twice)
        X_new = x_sat(X_new,Bounds); % saturate x with bounds
        last_Step_size = 3/2*last_Step_size; % calculate step size
        E_New = Eval_fun(X_new(1),X_new(2)); % evalute the new x
        Eval_Num = Eval_Num+1; % count evaluations
    elseif E_New > Fitness(1,:) % x new is still the worst
         X_new = X(1,:) + 0.5*(mid_point - X(1,:)); % constaction
         last_Step_size = 1/4*last_Step_size; % calculate step size
         E_New =  Eval_fun(X_new(1),X_new(2)); % evalute the new x
         Eval_Num = Eval_Num+1; % count evaluations
         if E_New > Fitness(1,:)  % x newer is still the worst
             X_new = X(1,:) + 0.5*(X(3,:) - X(1,:)); % Passing through the eye of the needle (squuze x0 and x1 by half
             X(2,:) = mid_point;
             Fitness(2) = Eval_fun(X(2,1),X(2,2)); % evalute new x1
             Eval_Num = Eval_Num+1; % count evaluations
             last_Step_size = 0.5*norm((X(3,:) - X(1,:)),2); % calculate step size
             E_New =  Eval_fun(X_new(1),X_new(2)); % evalute the new x
             Eval_Num = Eval_Num+1; % count evaluations
         end
    end
    X(1,:) = X_new; % x0 = xnew
    Fitness(1) = E_New; 
    [Fitness,ind] = sort(Fitness,'descend'); % min cost in element 3
    X = X(ind,:); %sort X by values
    last_change = E_best_prev-Fitness(3); % calculte the last change in the optimization
    
    if last_Step_size < conv_value % if the step size is to small - braek
        break
    end    
end

XMin = X(3,:); Emin = Fitness(3); % best solution in memory
end

function X = x_sat(X,bounds)
a = bounds(1); b = bounds(2);
%a is the lower bound of x and y; b is the upper bound of x and y
if X(1) < a 
    X(1)=a; end
if X(2)<a
    X(2)=a; end
if X(1)>b
    X(1)=b; end
if X(2)>b
    X(2)=b; end
end
