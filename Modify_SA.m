function [XMin, Emin, Iter_Num, Eval_Num, last_Step_size, last_change] = Modify_SA( Eval_fun , IC ,Bounds)
%% Modified SA function from the tutorial.
% Eval_fun - evaluation function , IC - initial condition ,Bounds -optional
% bounds
% Iter_Num -  Number of iterations.
% Eval_Num -  Number of function evaluations performed.
% last_Step - Step size on the last iteration.
% last_change - Change in function value on the last iteration.
% XMin, Emin -  Minimum position (x,y) and value.

%% SA initial parametrs
r=100; %radius for region for next neighbor
D=1-1e-3; %scaling ratio for the radius
T=7; %initial temperature
CoolingRate=1-1e-2; %cooling rate per iteration
Max_iter = 1e4; %maximal number of iterations
conv_value = 1e-4; %convergence criteria  to ||𝑥𝑖+1 − 𝑥𝑖 || 


%% calculating
% initialzie 
X = IC; XMin = X; Emin = 1e6;
E = Eval_fun(X(1),X(2));
Iter_Num=1; same_Eval_counter = 0;
while true
    Xprev = X; Eprev = E;
    XNew = X+D*r*(2*rand(1,2)-1); % Guess a new place of XNew based on search radius
    XNew = x_sat(XNew,Bounds);   % Saturate X new with bounds
    Enew = Eval_fun(XNew(1),XNew(2)); % evalute xnew
    P = TSP_SA_AcceptanceProbability(E,Enew,T); % check probability to use bad options.
    if P > rand
        X = XNew; E = Enew; % save the new X
        last_change = Eprev-E; %  save the last change
        if P == 1  % if X is actually iproves the optimization
            if norm(Xprev - X,2) < conv_value % check if X change enough
                break
            end
        end
    end
    if Enew < Emin %keeping the lowest function value and place
        Emin = Enew; XMin = XNew;
    end
    
    if ~(mod(Iter_Num,10)) % cool temperature every 10 steps and reduce search radios
        T=T*CoolingRate; r=r*D; 
    end
    
    Iter_Num=Iter_Num+1;
    
    % exiting optimization
    if Iter_Num > Max_iter % to prevent endless loop
        break
    end
end
Eval_Num = Iter_Num; % this code modified from the tutorial , in this implimntation the number of iteration is the number of the evaluations.
last_Step_size = r; % the radius of search

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

function P=TSP_SA_AcceptanceProbability(E,Enew,T)
if Enew<E
    P=1;
else
    P=exp((E-Enew)/T);
end
end