function varargout = compute_normality_tests(varargin)
%mat_in = varargin{1};
handles = varargin{4};

x =  handles.Primary_image_obj.image_volume_data(handles.mask_volume==1);
x = x(:);


% size = 1 ==> Surrounding 18 voxels

[H, pValue, SWstatistic] = swtest(x, 0.05, 0);

normality_test_matrix.sw_stats.H = double(H);
normality_test_matrix.sw_stats.pValue = pValue;

[H, pValue] = jbtest(x);
normality_test_matrix.jb_stats.H = double(H);
normality_test_matrix.jb_stats.pValue = pValue;

[H, pValue] = lillietest(x);
normality_test_matrix.ll_stats.H = double(H);
normality_test_matrix.ll_stats.pValue = pValue;

[H, pValue] = kstest(x);
normality_test_matrix.ks_stats.H = double(H);
normality_test_matrix.ks_stats.pValue = pValue;

if exist('normality_test_global') == 1
    clear normality_test_global;
end
global normality_test_global;
normality_test_global = normality_test_matrix;

if nargout>0
    varargout{1} =  normality_test_matrix;
end

return;

