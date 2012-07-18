function feature_output = JBH(varargin)
global normality_test_global;

if exist('normality_test_global')==1    
    feature_output = normality_test_global.jb_stats.H;    
else
    error('The normality test matrix must be computed first');
end

return;