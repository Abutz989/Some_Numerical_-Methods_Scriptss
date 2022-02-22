function [t,y] = MY_RK4_event(fun_handle,step_size,time_span,initial_value)
    % calculate RK4 unit it event occurs or the time span pass

    f = fun_handle; % set ode equation

    h = step_size; %Define step size in a shorter parameter h
    y = initial_value; %initilaize y0
    t(1) = time_span(1); % initilzize t0
    i = 1; %initilaize i
    collide = false;

    while (t(i) < time_span(2)) & (~collide) % run while loop untile it reach the time spane or the event occur
        t(i+1) = t(i) + h; % set the time progress
        % calculate k
        k1 = f(t(i)     , y(i,:))';
        k2 = f(t(i)+h/2 , y(i,:)+k1/2*h)';
        k3 = f(t(i)+h/2 , y(i,:)+k2/2*h)';
        k4 = f(t(i)+h   , y(i,:)+k3*h)';
        % calculate y in RK4
        y(i+1,:) = y(i,:) + (k1+2*k2+2*k3+k4)*h/6;
        % check for the events
        [pass,collide] = WallEvent(y(i+1,:)); % if collide wall event occur , finish the while loop

        % if pass wall event,  go one step buck and reduce time step.
         if pass
            i = i-1;
            h = h/2;
         end
        i = i+1;
    end
end

