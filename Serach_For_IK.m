function [SolMat , Sol_num] = Serach_For_IK(IG,P_i,uniqeFlag)
% This function calculate all the solution posible to a given Initial
% Condition. 
% Search for the Inverse kinematics base on the Initial Guesses(IG)
% and the desirard position (P_i) , uniqeFlag set if the output contain all
% solutions, or just the uniqes.

% initilaize the solutions
SolMat = [];
sol_idx = 1;
% determine the invarse kinematic function f(x) = 0
IK_fun = @(P,P_des) ForwardKinematics(P)-P_des;
% Set the parameters , P = f(x) thats why the tolarance set with function
% tolerance
options = optimoptions('fsolve',"FunctionTolerance",1e-4,'Display',"none");

for ig = 1:length(IG(:,1))
    [sol ,~ ,exitflag] = fsolve(@(P) IK_fun(P,P_i),IG(ig,:),options); % use fsolve for get the solution for the currenet initial geuss
    if exitflag > 0 
        sol = wrapTo2Pi(sol); % wrap the solution to [0 2pi]
        sol(sol < 1e-3) = 2*pi; % wrap the solution to (0 2pi] 1e-2 is the tolerance we used to avoid numeric errors
        SolMat(sol_idx,:) = sol; % add the current solution to the solutions matrix
    else
        SolMat(sol_idx,:) = [-1 -1 -1]; % add 'no solution' row
    end
    sol_idx = sol_idx + 1;
end % end for , Initial geusses.

if uniqeFlag 
    SolMat = SolMat((SolMat(:,1)>-1),:); % remove 'no solution' rows
    [~,ia] = unique(round(SolMat,2),'rows'); % sparte the uniqe rows from the solutions matrix
    SolMat = SolMat(ia,:);
end

Sol_num = sum(SolMat(:,1)>-1); % count the number of the  solutions
if Sol_num == 0
    disp('No solution found!'); end 
end



