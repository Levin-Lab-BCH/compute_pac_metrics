%Run compute pac metrics
server_letter = 'Z:';

cd(fullfile(server_letter,filesep,'Public',filesep,'EEG Analyses + Matlab scripts',filesep,'PAC',filesep,'Analyze_beapp_PAC_outputs',filesep,'0_load_files'))
%step 1: edit line 5 (or comment this line and add another line) with your
%load file
%ex: [grp_proc_info_in] = pac_analysis_load_file_Rett_DK;
[grp_proc_info_in] = pac_analysis_load_file;
%step 2: hit run
%do not edit 
compute_pac_metrics(grp_proc_info_in)
