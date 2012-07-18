function first_idx = find_first_in_vec(vec_in)
temp1 = find(vec_in==1);
if length(temp1)>0
    first_idx = temp1(1);
else 
    first_idx =0 ;
end
return;