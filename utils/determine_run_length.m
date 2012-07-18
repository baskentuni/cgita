function run_length_now = determine_run_length(vec_in)
if length(find(vec_in==0)) == 0
    run_length_now = length(vec_in);
else    
    vec2 = abs(diff(vec_in));
    first_idx = find_first_in_vec(vec2);
    run_length_now = first_idx;
end
return;