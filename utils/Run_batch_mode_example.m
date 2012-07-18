% Instructions:
% 0. Make a copy of this file and rename it. Do the following modification
% on the NEW file you just renamed.
% 1. Modify the line with "data_excel_filename". Assign the filename to an
% Excel file that contains the subject image and voi information.
% 2. Modify the line with "results_excel_output_filename_prefix". Assign
% the filename to an location you wish to save the results for the texture
% analysis
% 3. Modify the line with "screenshot_foldername". Assign the foldername
% that  you want to save the screen shots
% 4. Modify the line with "do_subjects ". Assign the index of subjects you
% want to process.
% After all the modifcation, click 'Debug -> Run XX.m' XX is the filename
% you used for renaming at step 0. Or simply click F5. You should see GUIs
% poping up and running on itself. Check after some time to see if the
% results have been saved.

clear variables; close all;

%%%%%Basic settings==============
data_excel_filename = 'Run_batch_mode_input_excel_example.xls';

results_excel_output_filename_prefix = 'E:\Research Data\Texture analysis\Run_0621\results_';

screenshot_foldername = 'E:\Research Data\Texture analysis\temp';

%%%%%Advanced settings
default_digitization_min = 0;
default_digitization_max = 25;
digitization_flag = 2;
digitization_bins = 64;
save user_feature_settings.mat digitization_flag digitization_bins default_digitization_min default_digitization_max -append;
%%%%%%%%%%%%%%%%%%%==============

if ~isdir(screenshot_foldername)
    mkdir(screenshot_foldername);
end

[ndata, text, alldata] = xlsread(data_excel_filename);

subject_code = alldata(2:end, 1);
PET_folders = alldata(2:end, 2);
VOI_files = alldata(2:end, 3);

counter = 0;
tic;
for idx = 1:size(alldata,1)
    display('===========================');
    display(['Processing subject: ' subject_code{idx}]);
    % Launch the GUI, which is a singleton
    CGITA_GUI
    % Find handle to hidden figure
    temp = get(0,'showHiddenHandles');
    set(0,'showHiddenHandles','on');
    hfig = gcf;
    % Get the handles structure
    handles = guidata(hfig);
    
    % Load the images
    CGITA_GUI('load_Primary_btn_Callback',...
        handles.load_Primary_btn,[],handles, PET_folders{idx})
    
    handles = guidata(hfig);
    
    % Load the VOI
    CGITA_GUI('load_VOI_btn_Callback',...
        handles.load_VOI_btn,[],handles, VOI_files{idx});
    handles = guidata(hfig);
    
    % Do the texture analysis
    temp1 = CGITA_GUI('apply_TA_button_Callback',...
        handles.apply_TA_button,[],handles, 'no_gui');
    
    counter = counter +1;
    
    % Put the texture analysis into the cell array
    final_cell{counter} = temp1;
    
    handles = guidata(hfig);
    
    drawnow;
    
    pause(3);
    
    handles = guidata(hfig);
    
    CGITA_GUI('snap_screen_btn_Callback',...
        handles.apply_TA_button,[],handles, screenshot_foldername, subject_code{idx});
    
    delete(hfig);
end

%% generate the excel spreadsheet for results
output_matrix = cell(size(final_cell{counter},1),counter+2);

output_matrix(1:end, 1:2) =  final_cell{1}(1:end,1:2);

for idx = 1:counter
    output_matrix(1, 2+idx) = subject_code(do_subjects(idx));
    output_matrix(2:end, 2+idx) = final_cell{idx}(2:end,3);
end

% Write the excel file for results
output_filename = [results_excel_output_filename_prefix datestr(now, 'mmmm_dd_yyyy_HH_MM_SS_') num2str(digitization_flag) num2str(digitization_bins) num2str(default_digitization_min) num2str(default_digitization_max) '.xls'];
[success message]=xlswrite(output_filename, output_matrix);

if success
    display('============ Report ===============');
    display('This batch was executed successfully and the results were saved as an excel file:');
    display(output_filename);
    display(['Processed ' num2str(counter) ' subjects. Average time for each subject is ' num2str(t2/counter/60) ' minutes']);
    display('Congrats! ');
    display('=================================');
end
