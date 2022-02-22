function [IG_Mat] = Get_IG_mat(n)
% This function return a matrix that covers the entire grid defined by n;
X = linspace(0,2*pi,n);
Y = linspace(0,2*pi,n);
Z = linspace(0,2*pi,n);
idx = 1;
    for x = X
        for y = Y
            for z = Z
                IG_Mat(idx,:) = [x,y,z];
                idx = idx + 1;
            end % end for, z valuse
        end % end for, y valuse
    end % end for, x valuse
    
end

