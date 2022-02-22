function [x_opt,fval,iter_final,output_final] = QN(fun_handle,x0)
f =@(x) fun_handle(x(1),x(2));
options = optimoptions(@fminunc,'Display','none','Algorithm','quasi-newton','TolFun',10^-4,'MaxIterations',10^4,'FunctionTolerance',10^-4);
[x_opt,fval,~,output_final] = fminunc(f,x0,options);
iter_final = output_final.iterations;

end