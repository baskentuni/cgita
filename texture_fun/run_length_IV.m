function feature_output = run_length_IV(varargin)
global run_length_matrix_all 

if exist('run_length_matrix_all')==1
    feature_output = 0;
    for idx1 = 1:size(run_length_matrix_all,1)        
            feature_output = feature_output + sum(run_length_matrix_all(idx1,:))^2;        
    end
    feature_output = feature_output / sum(run_length_matrix_all(:));
    
else
    error('The run length matrix must be computed first');
end

return;