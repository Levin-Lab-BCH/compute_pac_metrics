function [grp_proc_info] = pac_analysis_load_file_yb()

%set up user preferences for running post beapp pac analysis 

%% Provide Path Information - this assumes you
grp_proc_info.pac_metrics.path_struct.code_path = 'X:\Public\EEG Analyses + Matlab scripts\PAC\Analyze_beapp_PAC_outputs'; %path to your "Analyze_beapp_PAC_outputs" folder, ex: '/Volumes/neuro-levin/Public/EEG Analyses + Matlab scripts/PAC/Analyze_beapp_PAC_outputs';
grp_proc_info.pac_metrics.path_struct.outcomes_path = 'C:\Users\ch220650\Downloads\Rett_project_visits_beapp_labels.csv';%C:\Users\ch220650\Documents\02_Programming_Projects\01_BEAPP_TestsandExternalSupport\Rett_project_visits_beapp_labels.csv'; %path to our outcomes csv sheet with IDs and Groups, ex: '/Users/devorahkranz/Documents/Nelson_Fagiolini_Levin/Rett project/Rett_project_visits.csv';%/ABCCT_outcomes.csv';
grp_proc_info.pac_metrics.path_struct.src_dir = 'C:\Users\ch220650\Documents';%02_Programming_Projects\01_BEAPP_TestsandExternalSupport';% path to where your beapp pac and out folder lives for your beapp run, ex: '/Users/devorahkranz/Documents/Nelson_Fagiolini_Levin/Rett project/Data/participants/'; pac_BL_all_6sSegment_NoAmp_Padded_Overlap';%Devorah-Pac';
grp_proc_info.pac_metrics.path_struct.beapp_run_tag = '_dk_8123' ; %run tag for your beapp run ex: _BL_all_6sSegment_NoAmp_Padded_Overlap - make sure to include "_" at beginning!

%% Group
grp_proc_info.pac_metrics.groups = {'RTT','TD'}; %your two diagnostic groups, list your experimental group (e.g not TD) first, ex: {'RTT','ASD'}
%% do you want to compute sig clusters both ways 

%% Toggle on/off different module steps
grp_proc_info.pac_metrics.toggle_steps.run_all = 1 ; %if run all, ignore all steps below

%necessary
grp_proc_info.pac_metrics.toggle_steps.load_files = 0; %if you've already loaded all files for this run, set to 0 and it will load the pre-computed surrogates
grp_proc_info.pac_metrics.toggle_steps.run_permutations = 0 ; 
grp_proc_info.pac_metrics.toggle_steps.run_compare_clusters = 0; %if you've already loaded all files for this run, set to 0 and it 


%optional
grp_proc_info.pac_metrics.toggle_steps.report_MI_av_sheet = 1;
grp_proc_info.pac_metrics.toggle_steps.run_freq_band_analysis = 1; %add comments here - don
grp_proc_info.pac_metrics.toggle_steps.run_phase_prop_analyses = 1; %add comments here
grp_proc_info.pac_metrics.toggle_steps.run_phase_proportion_by_bin = 1; %
    %if you set toggle_steps.run_phase_proportion_by_bin to 1, identify what angels (bins) you want to look at the phase proportion of for your channels
    %Copy and paste the subset of options into the cell below:
    % {'neg170deg','neg150deg','neg130deg','neg110deg','neg90deg','neg70deg','neg50deg','neg30deg','neg10deg','10deg','30deg','50deg', '70deg','90deg','110deg','130deg','150deg','170deg'}
   grp_proc_info.pac_metrics.toggle_steps.run_phase_proportion_bin_variables = {'neg170deg','neg150deg','neg130deg','neg110deg'};
grp_proc_info.pac_metrics.toggle_steps.plot_phase_bias_proportion = 1;
 
    %steps will only run if you say yes on top of run all
grp_proc_info.pac_metrics.toggle_steps.visualize_phase_bias_comods = 1 ;



