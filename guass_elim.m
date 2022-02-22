function sol_direct=guass_elim(A,b,pivot_flag)

if (length(A(1,:)) == length(b(:,1)))
    
    n = length(A(:,1)); % n is the number of the matrix columns
    for i = [2:n]
        if pivot_flag
            Temp_A = A(i-1:n,:); % uses a temporaray matrix that driven from the original
            Temp_b = b(i-1:n);
            [~ , index] = sortrows(abs(Temp_A),i-1,'descend'); % sort the rows by the pivot number of the temporary matrix
            A(i-1:n,:) = Temp_A(index,:); % change A and b acurding to the new order 
            b(i-1:n) = Temp_b(index);
        end
       Piv_Value = A(i-1,i-1); % takes the cuerrent pivot value
       Reduce_Value = A([i:n],i-1)/Piv_Value; % calculte the number to multipy each colum based on the pivot value
       A([i:n],:) = A([i:n],:)- Reduce_Value .* A(i-1,:); % for j=i+1:N R_j = R_j - D * R_i
       b(i:n) =  b(i:n)- Reduce_Value * b(i-1);  %same for b
    end

    % פותר מטריצה משולשת עליונה לפי לולאה הפוכה
    sol_direct = zeros(n,1);
    for j = [n:-1:1]
        sol_direct(j) = b(j) - A(j,:)*sol_direct; 
    end
    
    
else
    errordlg('A and b are not compatible in size!')
end

end

