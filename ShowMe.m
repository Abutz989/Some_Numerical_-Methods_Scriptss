function ShowMe(y0)
    % Animate the senario base on initial condition(y0)
    l1 = 1; l2 = 1; h=0.1;  

    figure('color','w');
    %make sure of different colors
    col = hsv(length(h));
    time_span = [0 10];  % set the interval of t

    [t,y] = MY_RK4_event(@(t,y) My_DoublePendulum(t,y) ,h,time_span,[y0 0 0]);
    xdraw = [l1*sin(y(:,1)), l1*sin(y(:,1))+l2*sin(y(:,2))];
    ydraw = [-l1*cos(y(:,1)),-l1*cos(y(:,1))-l2*cos(y(:,2))];
    for i=1:length(t)
        %plot the first handle
        plot([0 xdraw(i,1)],[0 ydraw(i,1)],'marker','O','color','b');
        hold on
        %plot the second handle
        plot([xdraw(i,1) xdraw(i,2)],[ydraw(i,1) ydraw(i,2)],'color','g','marker','O');
        xlabel('x');ylabel('y');
        grid on; axis equal; xlim([-1 2]); ylim([-2 1]); 
        title(['Time: ',num2str(t(i)),'/',num2str(t(end)),'sec']); hold off;
        drawnow
        pause(0.1)
    end
end



