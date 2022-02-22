function [x,final_iter,step_size,func_value,eval,cost_change,LOG] = SteepestDescend(fun_handle,x0)

%Use this to find the gradient of the function
syms x y
g_xy = matlabFunction(gradient(fun_handle(x,y)));
g =@(x) g_xy(x(1),x(2));
f =@(x) fun_handle(x(1),x(2));

%Input and preallocation
err = 10^-4;
max_iter = 1000;

%table of answers
LOG = zeros(max_iter,2);
LOG(1,:) = x0';
x = x0;
eval=0;

%% iteration
for curr_iter = 2:max_iter
    
    eval = eval+1;
    
	x_prev=x;
    
	p=-g(x)'; 
    if(norm(p)<10^-6)
        p=p/10^-6;
    else
        p=p/norm(p); % step direction
    end
    [a,~,~,output]=fminsearch(@(a)f(x+a*p),0);
    eval = eval + output.funcCount;
    x=x+a*p; % next point
    LOG(curr_iter,:)=x';
    if norm(x-x_prev)<err
        final_iter = curr_iter;
        break % solution found
    end
end

if(curr_iter==max_iter)
    final_iter=max_iter;
end

cost_change = abs(norm(x-x_prev));
step_size = a;
func_value = fun_handle(x(1),x(2));

LOG(curr_iter:end,:)=[]; %remove trailing zeros

%Use if u want to draw
%change linspace of 's' for the correct limits
% s=linspace(-10,10,200);
% [X,Y]=meshgrid(s);
% figure
% contour(X,Y,fun_handle(X,Y),100);
% hold on; grid on; axis equal;
% plot3(LOG(:,1),LOG(:,2),fun_handle(LOG(:,1),LOG(:,2)),'-.r','linewidth',2);
% xlabel('x'); ylabel('y'); title('Steepest decend');

end

