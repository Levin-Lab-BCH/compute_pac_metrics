function [grp_proc_info] = pac_analysis_load_file()

%set up user preferences for running post beapp pac analysis 
grp_proc_info.chan_labels = "O1" % if left empty [], code will assume all 10-20 channels 

%% Provide Path Information - this assumes you
grp_proc_info.pac_metrics.path_struct.code_path = '/Users/devorahkranz/Documents/Nelson_Fagiolini_Levin/Rett_project/Code_Analysis/compute_pac_metrics-main'; %path to your "Analyze_beapp_PAC_outputs" folder, ex: '/Volumes/neuro-levin/Public/EEG Analyses + Matlab scripts/PAC/Analyze_beapp_PAC_outputs';
grp_proc_info.pac_metrics.path_struct.outcomes_path = '/Users/devorahkranz/Documents/Nelson_Fagiolini_Levin/Rett_project/Data/mouse_eeg/Mouse_groups.csv';%C:\Users\ch220650\Documents\02_Programming_Projects\01_BEAPP_TestsandExternalSupport\Rett_project_visits_beapp_labels.csv'; %path to our outcomes csv sheet with IDs and Groups, ex: '/Users/devorahkranz/Documents/Nelson_Fagiolini_Levin/Rett project/Rett_project_visits.csv';%/ABCCT_outcomes.csv';
grp_proc_info.pac_metrics.path_struct.src_dir = '/Users/devorahkranz/Documents/Nelson_Fagiolini_Levin/Rett_project/Data/mouse_eeg'; %02_Programming_Projects\01_BEAPP_TestsandExternalSupport';% path to where your beapp pac and out folder lives for your beapp run, ex: '/Users/devorahkranz/Documents/Nelson_Fagiolini_Levin/Rett project/Data/participants/'; pac_BL_all_6sSegment_NoAmp_Padded_Overlap';%Devorah-Pac';
grp_proc_info.pac_metrics.path_struct.beapp_run_tag = '_BL_mice_chan_edited_refupdated'; %run tag for your beapp run ex: _BL_all_6sSegment_NoAmp_Padded_Overlap - make sure to include "_" at beginning!

%% Group
grp_proc_info.pac_metrics.groups = {'MeCP2','WT'}; %your two diagnostic groups, list your experimental group (e.g not TD) first, ex: {'RTT','ASD'}

%% Colors

%Color code to give diagnostic groups, in this example RTT will have RGB
%code [ 0.8500 0.3250 0.0980], TD will have RGB code [0.4660 0.6740
%0.1880], and the color to indicate both collapsed groups will be [0.9290
%0.6940 0.1250], see
%https://www.mathworks.com/help/matlab/creating_plots/specify-plot-colors.html
%for other color options
grp_proc_info.pac_metrics.colors = {[ 0.8500 0.3250 0.0980],[0.4660 0.6740 0.1880], [0.9290 0.6940 0.1250]};
grp_proc_info.pac_metrics.band_shade_colors = [1 1 1];
red = [0.6350 0.0780 0.1840];
blue = [0 0.4470 0.7410];
yellow = [0.9290 0.6940 0.1250];
grp_proc_info.pac_metrics.colors = {red,blue,yellow};


%% Channels

%This pipeline assumes you are running the 18 10-20 channels defined by the
%net you used in your beapp run
%For hydrocel geodesic 128.0 the ordering of the 10-20 channels is:
%["FP2","Fz","FP1","F3","F7","C3","T3","P3","T5","Pz","O1","O2","P4","T6","C4","T4","F8","F4"];
%To confirm this order for your run, or check for another net type, follow these
%steps
    %1. Load a file from your segment folder for your current beapp run
    %2. type "selected_chans = {labels{file_proc_info.beapp_indx{1,1}}}"
    %into the command window
    %selected_chans will show you the labels of your channels evaluated in
    %the correct order, you can copy it into this script and reference this
    %NOTE: If you see more than 18, double check no additional electrodes
    %were analyzed for this run.
%instructions in "READ ME - Checking Channel Ordering"

%select the positions of the array above that correspond to your anterior
%electrodes of interest
grp_proc_info.set_chan_groups = 1; %Default is 0 - which will run metrics for whole brain, and anterior and posterio as set below
% if 1, you can set your own channel groups skip to line 57, otherwise, set anterior and posterior gorups here
grp_proc_info.pac_metrics.anterior = []; %[1,2,3,4,5,17,18];% (Fp2, Fz, Fp1, F3, F7, F8, F4)
%select the positions of the array above that correspond to your anterior
%electrodes of interest
grp_proc_info.pac_metrics.posterior = [1]; %[9,14,10,11,12];% (T5/P7, T6/P8, Pz, O1, O2)

%% OR
grp_proc_info.chan_group_labels = {'O1'}; %
grp_proc_info.chan_group_positions = {[1]}; %ddimension should correspond to number of channel gorup labels
%% do you want to compute sig clusters both ways 

%% Toggle on/off different module steps
grp_proc_info.pac_metrics.toggle_steps.run_all = 0; %if run all, ignore all steps below

%necessary
grp_proc_info.pac_metrics.toggle_steps.load_files = 0; %if you've already loaded all files for this run, set to 0 and it will load the pre-computed surrogates
grp_proc_info.pac_metrics.toggle_steps.run_permutations = 0; 
grp_proc_info.overwrite_unique_combs = 1; %SET BACK TO 0 ONCE YOU HAVE ENOUGH MICE, this controls whether a unique flip is required during the permutation analysis 
grp_proc_info.pac_metrics.toggle_steps.run_compare_clusters = 0; %if you've already loaded all files for this run, set to 0 and it 

%optional
grp_proc_info.pac_metrics.shade_freq_band = 0; %add shading by your selected frequency bands to overlay on comodulograms
grp_proc_info.pac_metrics.toggle_steps.report_MI_av_sheet = 1;
grp_proc_info.pac_metrics.toggle_steps.run_freq_band_analysis = 1; %add comments here - don
grp_proc_info.pac_metrics.toggle_steps.run_phase_prop_analyses = 1; %add comments here
grp_proc_info.pac_metrics.toggle_steps.run_phase_proportion_by_bin = 1; %
%if you set toggle_steps.run_phase_proportion_by_bin to 1, identify what angels (bins) you want to look at the phase proportion of for your channels
%Copy and paste the subset of options into the cell below:
% {'neg170deg','neg150deg','neg130deg','neg110deg','neg90deg','neg70deg','neg50deg','neg30deg','neg10deg','10deg','30deg','50deg', '70deg','90deg','110deg','130deg','150deg','170deg'}
grp_proc_info.pac_metrics.toggle_steps.run_phase_proportion_bin_variables = {'neg170deg','neg150deg','neg130deg','neg110deg'};
grp_proc_info.pac_metrics.toggle_steps.plot_phase_bias_proportion = 0;
 
    %steps will only run if you say yes on top of run all
grp_proc_info.pac_metrics.toggle_steps.visualize_phase_bias_comods = 0;

