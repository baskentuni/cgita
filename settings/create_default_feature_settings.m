function varargout = create_default_feature_settings(varargin)
% This is a script that determines the settings for the textural feature
% computing. 

% This determines the digitization approach
% digitzation flag:
% 0 - use the min and max within the masked volume for digitization
% 1 - use the min and max within the rectangular cylinder volume  (default)
% 2 - use 0 and max within the masked volume for digitization
% 3 - use 0 and max within the rectangular cylinder volume 
% 4 - use preset min and max values (needs to assign both values)
digitization_flag = 1;
default_digitization_min = 0;
default_digitization_max = 25;
digitization_bins = 64;

% This part of code determines the way data digitization 
% This part of code generates the initial settings of the features to be computed
% In the .mat file, the features are organized in this order:
% feature_structure is the variable to store all the features
% feature_structure{k} contains the kth feature

% feature_structure{1}{x} describes the features under 'Cooccurance matrix'
property_matrix = {'Second angular moment'      'cooccurrence_SAM';
                   'Contrast'                   'cooccurrence_Contrast_1';
                   'Entropy'                    'cooccurrence_Entropy';
                   'Homogeneity'                'cooccurrence_Homogeneity';
                   'Dissimilarity'              'cooccurrence_Dissimilarity';
                   'Inverse difference moment'  'cooccurrence_IDM'};

for idx = 1:size(property_matrix,1)
    feature_structure{1}{idx}.parent = 'Cooccurance';     feature_structure{1}{idx}.name = property_matrix{idx, 1};      feature_structure{1}{idx}.matlab_fun = property_matrix{idx, 2};     
    feature_structure{1}{idx}.parentfcn = 'compute_cooccurance_matrix';
end

% feature_structure{2}{x} describes the features under 'Voxel-alignment matrix'
property_matrix = {'Short run emphasis'                      'run_length_SRE';
                   'Long run emphasis'                       'run_length_LRE';
                   'Intensity variability'                   'run_length_IV';
                   'Run-length variability'                  'run_length_RLV';
                   'Run percentage'                          'run_length_RP';
                   'Low-intensity run emphasis'              'run_length_LIRE';
                   'High-intensity run emphasis'             'run_length_HIRE';
                   'Low-intensity short-run emphasis'        'run_length_LISRE';
                   'High-intensity short-run emphasis'       'run_length_HISRE';
                   'Low-intensity long-run emphasis'         'run_length_LILRE';
                   'High-intensity long-run emphasis'        'run_length_HILRE';};
                           

for idx = 1:size(property_matrix,1)
    feature_structure{2}{idx}.parent = 'Voxel-alignment';     feature_structure{2}{idx}.name = property_matrix{idx, 1};     feature_structure{2}{idx}.matlab_fun = property_matrix{idx, 2};     
    feature_structure{2}{idx}.parentfcn = 'compute_voxel_alignment_matrix';
end
% 
% feature_structure{3}{x} describes the features under 'Neighborhood intensity-difference matrix'
property_matrix = {'Coarseness'                              'NID_Coarseness';
                   'Contrast'                                'NID_Contrast';
                   'Busyness'                                'NID_Busyness'
                   'Complexity'                              'NID_Complexity'
                   'Strength'                                'NID_Strength';};                           

for idx = 1:size(property_matrix,1)
    feature_structure{3}{idx}.parent = 'Neighborhood intensity-difference';     feature_structure{3}{idx}.name = property_matrix{idx, 1};     feature_structure{3}{idx}.matlab_fun = property_matrix{idx, 2};     
    feature_structure{3}{idx}.parentfcn = 'compute_NGTD_matrix';
end

% 
% feature_structure{4}{x} describes the features under 'Intensity-size-zone matrix'
property_matrix = {'Short-zone emphasis'                              'run_length_SRE';
                               'Large-zone emphasis'                  'run_length_LRE';
                               'Intensity variability'                'run_length_IV';
                               'Size-zone variability'                'run_length_RLV';
                               'Zone percentage'                      'run_length_RP';
                               'Low-intensity zone emphasis'          'run_length_LIRE';
                               'High-intensity zone emphasis'         'run_length_HIRE';
                               'Low-intensity short-zone emphasis'    'run_length_LISRE';
                               'High-intensity short-zone emphasis'   'run_length_HISRE';
                               'Low-intensity large-zone emphasis'    'run_length_LILRE';
                               'High-intensity large-zone emphasis'   'run_length_HILRE';};
                           

for idx = 1:size(property_matrix,1)
    feature_structure{4}{idx}.parent = 'Intensity-size-zone';     feature_structure{4}{idx}.name = property_matrix{idx, 1};     feature_structure{4}{idx}.matlab_fun = property_matrix{idx, 2};     
    feature_structure{4}{idx}.parentfcn = 'compute_ISZ_matrix';
end
% 
% feature_structure{5}{x} describes the features under 'Normalized Cooccurance matrix'
property_matrix = {'Second angular moment'      'cooccurrence_SAM';
                   'Contrast'                   'cooccurrence_Contrast_1';
                   'Entropy'                    'cooccurrence_Entropy';                               
                   'Homogeneity'                'cooccurrence_Homogeneity';
                   'Dissimilarity'              'cooccurrence_Dissimilarity';
                   'Inverse difference moment'  'cooccurrence_IDM'
                   'Correlation'                'cooccurrence_Correlation';
                               };

for idx = 1:size(property_matrix,1)-1
    feature_structure{5}{idx}.parent = 'Normalized Cooccurance';     feature_structure{5}{idx}.name = property_matrix{idx, 1};     feature_structure{5}{idx}.matlab_fun = property_matrix{idx, 2};     
    feature_structure{5}{idx}.parentfcn = 'compute_normalized_cooccurance_matrix';
end
idx = idx+1;
feature_structure{5}{end+1}.parent = 'Cooccurance';     feature_structure{5}{end}.name = property_matrix{idx, 1};     feature_structure{5}{end}.matlab_fun = property_matrix{idx, 2};
feature_structure{5}{end}.parentfcn = 'compute_cooccurance_matrix';

property_matrix =             {'Minimum SUV'                 'voxel_min';
                               'Maximum SUV'                 'voxel_max';
                               'Mean SUV'                    'voxel_mean';
                               'SUV Variance'                'voxel_var';
                               'SUV SD'                      'voxel_SD';
                               'SUV Skewness'                'voxel_Skewness'
                               'SUV Kurtosis'                'voxel_Kurtosis'
                               'SUV bias-corrected Skewness' 'voxel_corrected_Skewness'
                               'SUV bias-corrected Kurtosis' 'voxel_corrected_Kurtosis'
                               'TLG'                         'voxel_TLG' 
                               'Tumor volume'                'voxel_Volume'
                               'Entropy'                     'voxel_Entropy';};
                           
for idx = 1:size(property_matrix,1)
    feature_structure{6}{idx}.parent = 'SUV statistics';     feature_structure{6}{idx}.name = property_matrix{idx, 1};     feature_structure{6}{idx}.matlab_fun = property_matrix{idx, 2};     
    feature_structure{6}{idx}.parentfcn = 'prepare_SUV_parent';
end

% 
% feature_structure{6}{x} describes the features under 'Texture spectrum'
property_matrix = {'Max spectrum'                          'texture_spectrum_Max';
                   'Black-white symmetry'                  'texture_spectrum_BWS';};

for idx = 1:size(property_matrix,1)
    feature_structure{7}{idx}.parent = 'Texture Spectrum';     feature_structure{7}{idx}.name = property_matrix{idx, 1};     feature_structure{7}{idx}.matlab_fun = property_matrix{idx, 2};     
    feature_structure{7}{idx}.parentfcn = 'compute_spectrum_matrix';
end
% 
% feature_structure{8}{x} describes the features under 'Texture Feature Coding Method'
property_matrix = {'Coarseness'                             'TFC_Coarseness';
                   'Homogeneity'                            'TFC_Homogeneity';
                   'Mean convergence'                       'TFC_MC'
                   'Variance'                               'TFC_Variance';};

for idx = 1:size(property_matrix,1)
    feature_structure{8}{idx}.parent = 'Texture Feature Coding';     feature_structure{8}{idx}.name = property_matrix{idx, 1};     feature_structure{8}{idx}.matlab_fun = property_matrix{idx, 2};     
    feature_structure{8}{idx}.parentfcn = 'compute_feature_coding_3D';
end

% feature_structure{9}{x} describes the features under 'Texture Feature Coding Co-occurrence matrix'

property_matrix = {            'Second angular moment'      'cooccurrence_SAM';
                               'Contrast'                   'cooccurrence_Contrast';
                               'Entropy'                    'cooccurrence_Entropy';
                               'Homogeneity'                'cooccurrence_Homogeneity';
                               'Intensity'                  'cooccurrence_Intensity'
                               'Inverse difference moment'  'cooccurrence_IDM'
                               'Code Entropy'               'TFC_CE'
                               'Code Similarity'            'TFC_CS'};

for idx = 1:size(property_matrix,1)
    feature_structure{9}{idx}.parent = 'Texture Feature Coding Cooccurance';     feature_structure{9}{idx}.name = property_matrix{idx, 1};      feature_structure{9}{idx}.matlab_fun = property_matrix{idx, 2};     
    feature_structure{9}{idx}.parentfcn = 'compute_FC_cooccurance_matrix';
end

% feature_structure{10}{x} describes the features under 'Neighborhood gray level dependence'
property_matrix = {            'Small number emphasis'            'NGLD_SRE';
                               'Large number emphasis'            'NGLD_LRE';
                               'Number nonuniformity'             'NGLD_NNU';
                               'Second moment'                    'NGLD_SM';
                               'Entropy'                          'NGLD_EN';};

for idx = 1:size(property_matrix,1)
    feature_structure{10}{idx}.parent = 'Neighboring Gray Level Dependence';     feature_structure{10}{idx}.name = property_matrix{idx, 1};     feature_structure{10}{idx}.matlab_fun = property_matrix{idx, 2};     
    feature_structure{10}{idx}.parentfcn = 'compute_NGLD_matrix';
end

% % feature_structure{11}{x} describes the features under 'Normality test'
% property_matrix = {'SW test H'            'SWH';
%                                'SW test p'            'SWp';
%                                'JB test H'              'JBH';
%                                'JB test p'              'JBp';
%                                'Lillifors test H'       'LLH';
%                                'Lillifors test p'       'LLp';
%                                'KS test H'             'KSH';
%                                'KS test p'             'KSp';};
% 
% for idx = 1:size(property_matrix,1)
%     feature_structure{11}{idx}.parent = 'Normality tests';     feature_structure{11}{idx}.name = property_matrix{idx, 1};     feature_structure{11}{idx}.matlab_fun = property_matrix{idx, 2};     
%     feature_structure{11}{idx}.parentfcn = 'compute_normality_tests';
% end

default_primary_colormap = 'hot';
default_fusion_colormap = 'bone';

settings_dir = uigetdir(pwd, 'Select the settings directory');
cd1 = cd;
if settings_dir~=0
    cd(settings_dir);
    save default_feature_settings.mat feature_structure digitization_flag default_digitization_min default_digitization_max digitization_bins;
    save default_feature_settings.mat default_fusion_colormap default_primary_colormap -append;

    if ~exist('user_feature_settings.mat')
        save user_feature_settings.mat feature_structure digitization_flag default_digitization_min default_digitization_max digitization_bins;
        save user_feature_settings.mat default_fusion_colormap default_primary_colormap -append;

    else 
        options.Interpreter = 'tex';
        % Include the desired Default answer
        options.Default = 'Yes';
        % Create a TeX string for the question
        qstring = 'Previous setting file already exists. Overwrite?';
        choice = questdlg(qstring,'Boundary Condition',...
            'Yes','No',options);
        if strcmp(choice, 'Yes')
            save user_feature_settings.mat feature_structure digitization_flag default_digitization_min default_digitization_max digitization_bins;
            save user_feature_settings.mat default_fusion_colormap default_primary_colormap -append;

        end
    end
end
cd(cd1);

return;