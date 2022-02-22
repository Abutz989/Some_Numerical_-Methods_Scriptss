function [dy] = My_DoublePendulum(t,y)

%The ode problem will be defined as dy with a row vector of 4 where
%dy(1) angular velocity rod 1
%dy(2) angular velocity rod 2
%dy(3) angular accelaration rod 1
%dy(4) angular accelaration rod 2
dy = zeros(4,1);

%Define parameters' sizes from exercise
m1 = 1;
m2 = 0.5;
l1 = 1;
l2 = 1;
g=1; %Should be 9.81 but was defined differentely in exercise

%Define equation in a shorter way using the following
a = (m1+m2)*l1;
b = m2*l2*cos(y(1)-y(2));
c = m2*l1*cos(y(1)-y(2));
d = m2*l2;
e = -m2*l2*y(4)^2*sin(y(1)-y(2))-g*(m1+m2)*sin(y(1));
f = m2*l1*y(3)^2*sin(y(1)-y(2))-m2*g*sin(y(2));

dy(1) = y(3);
dy(2) = y(4);
dy(3) = (e*d-b*f)/(a*d-b*c);
dy(4) = (a*f-c*e)/(a*d-b*c);

end

