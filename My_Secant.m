function x2 = My_Secant(fun,x1,MaxIter,Sol_Tol)
x0 = zeros(size(x1));
x2 = zeros(size(x1));
if all(~x1)
    x1 = rand(size(x0));
end

for idx = 1: MaxIter
   x2 = x1 - (x1-x0)/(fun(x1)-fun(x0))*fun(x1);
   x0 = x1; x1 = x2;

   f2 = fun(x2);
   if norm(f2,'inf') < Sol_Tol
       break
   end

end
end

