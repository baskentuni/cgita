function feature_output = run_length_RP(varargin)
global run_length_matrix_all 
global image_property

if exist('run_length_matrix_all')==1 && exist('image_property')==1

    feature_output = sum(run_length_matrix_all(:)) / image_property.num_voxels;
    
else
    error('The run length matrix must be computed first');
end

return;