function [pass,collide] = WallEvent(y)
% That function find the events of "collide" - be in the wall limits and "pass"
% passing thro the wall.
    l1 = 1; l2 = 1; %lengths in the pendulum
    X = [l1*sin(y(1)), l1*sin(y(1))+l2*sin(y(2))]; %pendulum joints x position.
    X_wall = X + [0.5 0.5]; % set the x axis on the wall
    pass = false; collide =false; % initilazie
    if  min(X_wall) < 1e-8  % the first condition is to be lower then the limit.
        if  min(X_wall) >= -1e-8 % the scound condition is to be greatter then the limit.
            collide = true; % X values is in the "collide" event.
        else
            pass = true; % X values is in the "pass" event.
        end   
    end
end

