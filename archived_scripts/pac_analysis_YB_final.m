% Author: Yael Braverman - modified/refactored from Fleming Peck's pac_analysis script
clear
% Define Folders
code_path = '/Volumes/neuro-levin/Public/EEG Analyses + Matlab scripts/PAC/Analyze_beapp_PAC_outputs';
outcomes_path = '/Users/devorahkranz/Documents/Nelson_Fagiolini_Levin/Rett project/Rett_project_visits.csv';%/ABCCT_outcomes.csv';
src_dir =  '/Users/devorahkranz/Documents/Nelson_Fagiolini_Levin/Rett project/Data/participants/pac_BL_all_6sSegment_NoAmp_Padded_Overlap';%Devorah-Pac';

 % outcomes_path =     'C:\Users\ch220650\Devorah-Pac\outcomes.csv';
%  outcomes_path =     'C:\Users\ch2clea20650\pac_results_test_run\ABCCT-verification\outcomes.csv';
%  outcomes_path = 'C:\Users\ch220650\pac_results_test_run_2\Rett_project_visits.csv';%ABCCT-verification\PAC_log.csv';%Rett_project_visits.csv'
%    src_dir =     'C:\Users\ch220650\pac_results_3';
% src_dir =     ' C:\Users\ch220650\Documents\02_Programming_Projects\03_BCH_Projects\Devorah-Pac\pac_5.25.23' ;%  'C:\Users\ch220650\PAC_3.31.2023';%pac_results_test_run\ABCCT-Downsample-verification';
 %   code_path =     'Z:\Public\EEG Analyses + Matlab scripts\PAC\Analyze_beapp_PAC_outputs';

%% DO NOT EDIT BELOW THIS LINE
addpath(genpath(code_path));
groups = {'RTT','TD'};
%groups = {'TD','ASD'};
all_plots = 1;
% Prepare Directions
save_dir = [src_dir filesep 'results']; prepare_pac_directories(save_dir);
addpath(genpath(src_dir)); cd(src_dir);
flist = dir(fullfile(src_dir,'*.mat')); flist = {flist.name}';
% Plotting Channel Information/ Channel Maps I confirmed that these ARE in the right order (fleming)
chan_indexes = [9, 11, 22, 24, 33, 36, 45, 52, 58, 62, 70, 83, 92, 96, 104, 108, 122, 124];
chan_labels = ["FP2","Fz","FP1","F3","F7","C3","T3","P3","T5","Pz","O1","O2","P4","T6","C4","T4","F8","F4"];
anterior =  [1,2,3,4,5,17,18];% (Fp1, Fp2, F3, F4, F7, F8, Fz) %confirm these are set in order by beapp
posterior = [9,14,10,11,12];% (P7, P8, Pz, O1, O2)
lf_labels = {'Theta','Alpha','Beta'};
hf_labels = {'Gamma','Gamma','HighGamma'};
%% Open All Files and Create / Save Participant and Surrogate MI Variables for later 
        % open all files and create huge blocks for g1 (ASD or RTT for example) and no ASD/RTT conditions
if toggle_steps.run_all | toggle_steps.load_files
        outcomes = readtable(outcomes_path);
            [amp_dist_all,order_dist,order,MI_surr, MI_raw, MI_norm, ...
         comodulogram_column_headers, comodulogram_row_headers, comodulogram_third_dim_headers]= generate_MI_surr(flist,outcomes,src_dir,save_dir,groups);
else
    cd([save_dir filesep 'PAC analysis variables']);
    load('PAC_analysis_variables.mat')
end
%% check distributions
plot_surr_dist(MI_surr,comodulogram_row_headers,comodulogram_column_headers,groups)
%% Approach 1: Cluster analysis 
% Step 1: Measure Cluster Sizes In Dataset by checking 1) where in comodulogram there is PAC above surrogate and 2) where/how big the remaining clusters are
%cd([save_dir filesep 'PAC analysis variables'])
row = length(comodulogram_row_headers); column = length(comodulogram_column_headers); third = length(comodulogram_third_dim_headers); 
MI_raw_orig = MI_raw;
MI_norm_orig = MI_norm;
MI_surr_orig = MI_surr;
%for p = [35 45 55 65 75 85 95]
    % define random subset for MI surr and raw for TD and ASD
% randomly select 104 (TD n) ASD participants
%     for group = 1:length(groups)
%         idxs = find(~isnan(MI_raw_orig.(groups{1,group})(1,1,1,:)));
%         rands = randperm(length(idxs));
%         rands = rands(1:p);
%             rand_idxs = idxs(rands);
%         MI_norm.(groups{1,group}) = MI_norm_orig.(groups{1,group})(:,:,:,rand_idxs);
%         MI_raw.(groups{1,group}) = MI_raw_orig.(groups{1,group})(:,:,:,rand_idxs);
%          MI_surr.(groups{1,group}) = MI_surr_orig.(groups{1,group})(:,:,:,rand_idxs);
% 
%     end
for group = 1:length(groups)
    % Call function to generate matrices that are sig above surrogate dist for each group
[sig_points.(groups{1,group}),pvalues.(groups{1,group}),tvalues.(groups{1,group}),df.(groups{1,group})] = create_PAC_clusters(MI_surr.(groups{1,group}),MI_raw.(groups{1,group}));
% Call function to identify where clusters are and measure their size
    [clusters.(groups{1,group}),cluster_stats.(groups{1,group}),cluster_stats_t.(groups{1,group})] = characterize_PAC_clusters(sig_points.(groups{1,group}),tvalues.(groups{1,group}),row,column,third);
end
%% FINAL cluster plots
% 1000 iterations
%load('C:\Users\ch220650\pac_results_test_run\ABCCT_BEAPP_verification\pac_abcct_verification_highres\results\PAC analysis variables\perm_idxs.mat')
same_idxs.(groups{1,1}) = []; flip_idxs.(groups{1,1}) = []; same_idxs.(groups{1,2}) = []; flip_idxs.(groups{1,2}) = [];
for group = 1:length(groups)
    %  Cluster analysis Step 2: Run permutation (swapping surrogate/ ids into raw and vice versa)  Then, permutation test of significance
[cluster_dist.(groups{1,group}),cluster_dist_t.(groups{1,group})] = run_PAC_permutations(MI_raw.(groups{1,group}),MI_surr.(groups{1,group}),flip_idxs.(groups{1,group}),same_idxs.(groups{1,group}));
end
%% Cluster analysis Step 3: Check which of the original clusters pass the threshold after running the permutations  
for group = 1:length(groups)
   [sig_clusters.(groups{1,group}),cluster_threshold.(groups{1,group}),sig_clusters_t.(groups{1,group}),cluster_threshold_t.(groups{1,group})] = generate_significant_clusters_PAC(cluster_dist.(groups{1,group}),cluster_dist_t.(groups{1,group}),cluster_stats.(groups{1,group}),cluster_stats_t.(groups{1,group}),clusters.(groups{1,group}));
end
%% 
save(strcat('PAC_cluster_variables.mat'),'clusters','cluster_stats','cluster_stats_t','cluster_dist','cluster_dist_t','sig_points','sig_clusters','sig_clusters_t','cluster_threshold','cluster_threshold_t','tvalues');
%end

%% Approach 2: g1 vs g2 tests (ex: RTT vs TD or ASD vs TD)
%% ASD/RTT vs TD step 1: Get initial sig map comparing MI_norms for ASD/RTT vs TD
[compare_sig_points,compare_pvalues,compare_tvalues,~]=create_PAC_clusters(MI_norm.(groups{1,1}),MI_norm.(groups{1,2}));
% Call function to identify where clusters are in original data and measure their size
 [compare_clusters,compare_cluster_stats,compare_cluster_stats_t] = characterize_PAC_clusters(compare_sig_points,compare_tvalues,length(comodulogram_row_headers),length(comodulogram_column_headers),length(comodulogram_third_dim_headers));
%% ASD/RTT vs TD step 2: permutation test
% Then, permutation test of significance
[compare_cluster_dist,compare_cluster_dist_t] = run_PAC_permutations(MI_norm.(groups{1,1}),MI_norm.(groups{1,2}));     
%% ASD/RTT vs TD step 3: identify significant clusters
[compare_sig_clusters,compare_cluster_threshold,compare_sig_clusters_t,compare_cluster_threshold_t] = generate_significant_clusters_PAC(compare_cluster_dist,compare_cluster_dist_t,compare_cluster_stats,compare_cluster_stats_t,compare_clusters);
 cd([save_dir filesep 'PAC analysis variables'])
save('PAC_compare_cluster_variables.mat','MI_norm','compare_cluster_dist','compare_cluster_threshold','compare_sig_clusters', ...
     'compare_clusters','compare_sig_clusters_t','compare_cluster_threshold_t','compare_cluster_stats','compare_sig_points','compare_tvalues','compare_pvalues');
%% FINAL FIGURE ASD/RTT - TD strength - Fig 2C: Topoplot visualizing the channel- and frequency-space differences in PAC strength by subtracting TD PAC strength in (B) from ASD PAC strength in (A)
plot_g1_minus_g2_pac_strength(MI_norm,groups,chan_labels,save_dir)
%% Standard deviations of ASD/RTT and TD
[std_struct] = compute_MI_std(MI_raw,save_dir,groups);
%% plot standard deviation  only run if doing "all plots" not generated for PAC paper
% change to directory to save
if all_plots ; plot_MI_std(std_struct,save_dir,groups,comodulogram_row_headers,comodulogram_column_headers,chan_labels); end
%% Analyses that don't depend on clustering methods - Freqband analysis
  %% FREQ BAND ANALYSIS First compute the phase strength, phase bias, and phase dist for each freq band then plot
    if toggle_steps.run_all | toggle_steps.run_freq_band_analysis
    outcomes = readtable(outcomes_path);
    freq_table = table([ 4; 8], [8;  12],[12; 20],[28; 56],[44 ;56],'VariableNames',{'Theta','Alpha','Beta','Gamma','HighGamma'},'RowNames',{'Minimum','Maximum'});
    [outcomes] = run_phase_metrics_freq_band_analysis(lf_labels,hf_labels,freq_table,{'WholeBrain','Anterior','Posterior','FP1FP2'},{[1:18],anterior,posterior,[1,3]},outcomes,comodulogram_column_headers,comodulogram_row_headers,order_dist,order,groups,amp_dist_all,MI_norm,alpha);
    writetable(outcomes,[save_dir filesep 'freqband_PAC_metrics_complete.xlsx']);
    %plot phase distribution
    if 1; plot_pac_phase_distribution(outcomes,save_dir); end
    %polar plots phase bias - Figure 4: Individual and Group Average Phase Preference
    plot_pac_phase_bias(outcomes,save_dir,groups)
    %strength plots - Figure 3: Individual PAC Strength
    plot_pac_strength(outcomes,save_dir,groups)
    % phase bias scatter plots - using the ratio method and not circ_mean
    plot_pac_phase_bias_scatter(outcomes,save_dir,groups)
    end

for sig_cluster_method = 1:2
    if sig_cluster_method == 1
        curr_sig_cluster = sig_clusters;

    elseif sig_cluster_method == 2
        save_dir = fullfile(src_dir,'results_t_score_clusters');
        curr_sig_cluster = sig_clusters_t;
        prepare_pac_directories(save_dir);
    end
    g1_g2_overlap_clusters = curr_sig_cluster.(groups{1,2}) .* curr_sig_cluster.(groups{1,1});
    g1_nog2_clusters = (( curr_sig_cluster.(groups{1,1}) -  curr_sig_cluster.(groups{1,2})) == 1)*1;
    %% Fig 2D - save plots of significance - show whether at each hf/lf point asd/rtt was sig, td was sig or both or none (1 or 0)
    plot_sig_pac_clusters(curr_sig_cluster,comodulogram_row_headers,comodulogram_column_headers,comodulogram_third_dim_headers,groups,save_dir,chan_labels)
    
    %% plot significant clusters - only run if doing "all plots" not generated for PAC paper
    % make channel plots with ASD/RTT and TD overlap and save plots of significance
    if all_plots; plot_sig_pac_clusters_g1vsg2(compare_sig_clusters,comodulogram_row_headers,comodulogram_column_headers,comodulogram_third_dim_headers,save_dir,chan_labels,compare_cluster_dist); end
    
    %% FINAL FIGURE WITH BOUNDARIES AROUND CLUSTERS - CHECK IF NEEDED OR DO FOR ALL PLOTS
    % change to directory to save - Fig 2A/B: topoplot with normalized PAC strength color-coded using the PAC strength legend increasing from black (low strength) to yellow (high strength). frequency groupings noted with a white outline.
    plot_clusters_with_boundaries(curr_sig_cluster.(groups{1,2}),MI_norm.(groups{1,2}),comodulogram_row_headers,comodulogram_column_headers,comodulogram_third_dim_headers,chan_labels,save_dir,groups{1,2})
   if toggle_steps.run_all | toggle_steps.report_MI_av_sheet 
    %% find MI average and save to report table
    % set up report table
    outcomes = readtable(outcomes_path);
    overlap_vec = {'Overlap',[groups{1,1},'only']};
    region_table = table([1,3], [11,12],[7,16],[1,2,3,4,5,17,18],[8,13,9,14,10,11,12],'VariableNames',{'FP1FP2','O1O2','T3T4','Anterior','Posterior'});
    [outcomes] = compute_MI_average(outcomes,order_dist,order,groups,amp_dist_all,MI_norm,g1_g2_overlap_clusters,g1_nog2_clusters,region_table,overlap_vec);
    writetable(outcomes,[save_dir filesep 'PAC_MInorm_cluster_averages_revised_allfreqpairs.xlsx']);
   end
    %% PHASE BIAS
    % want to average each phase bin across all significant frequency pairs in a cluster for each participant average across all participants within each group
  
    %% plot maps phase_bias_comods only run if doing "all plots" not generated for PAC paper
    if toggle_steps.visualize_phase_bias_comods
          %% find highest phase bin value for each frequency pair -
    [max_phase_bin,max_phase_value] = compute_max_phase_bin_and_val(amp_dist_all,groups);
    phase_in_clusters.(groups{1,1}) = max_phase_bin.(groups{1,1}).*curr_sig_cluster.(groups{1,1});% map of group1 phase in group1 clusters (ex: RTT or ASD)
    phase_in_clusters.(groups{1,2}) = max_phase_bin.(groups{1,2}).*curr_sig_cluster.(groups{1,2}); % map of TD phase in TD clusters
    plot_sig_phase_bias_comods(std_struct,phase_in_clusters,groups,comodulogram_row_headers,comodulogram_column_headers,chan_labels,save_dir);

    %% Phase bias - compute group average phase bias and phase bias by participant (2nd output)
    alpha = linspace((-17/18) * pi, (17/18) * pi,18);
    [phase_bias_avg,phase_matrices] = compute_phase_bias_average(alpha,amp_dist_all,comodulogram_row_headers,comodulogram_column_headers,comodulogram_third_dim_headers,groups);
    %% plot phase maps - only run if all_plots turned on - not included in PAC manuscript
    clusters_phase.(groups{1,1}) = phase_bias_avg.(groups{1,1});
    clusters_phase.(groups{1,2}) = phase_bias_avg.(groups{1,2});
    plot_phase_maps(chan_labels,groups,save_dir,comodulogram_column_headers,comodulogram_row_headers,clusters_phase); 
    end
    %% compute and plot phase bias proportion for rois with g1 and g2 sig and those with just g1 sig
    %YB note: could adjust r axis / limits later
   if toggle_steps.run_all | toggle_steps.plot_phase_bias_proportion
    for overlap = 1:2 % 1 overlap 2 dont
        if overlap ==2
            curr_cluster = g1_nog2_clusters;
        elseif overlap == 1
            curr_cluster = g1_g2_overlap_clusters;
        end % Figure 5: Group differences of phase bias proportion in lf-hf pair coupling for overlap and non overlapped clusters.
        run_phase_bias_proportion(region_table,curr_cluster,amp_dist_all,overlap,groups,alpha) %% plot all participants phase bias proportion
    end
   end
    % identify indexes of clusters of interest
    %% identify the mean proportion in phase bin in cluster
    % do for g1 and g2 for ALL, get g1only clusters and overlap_clusters from above
    if toggle_steps.run_all | toggle_steps.run_phase_proportion_by_bin
        full_table = table([1],[2],[3],[4],[5],[6],[7],[8],[9],[10],[11],[12],[13],[14],[15],[16],[17],[18],'VariableNames', ...
            {'-170deg','-150deg','-130deg','-110deg','-90deg','-70deg','-50deg','-30deg','-10deg','10deg','30deg','50deg', ...
            '70deg','90deg','110deg','130deg','150deg','170deg'},'RowNames',{'bin_idx'});
        outcomes = readtable(outcomes_path); % to do - make bin_idx_table automatic
        bin_idx_table = full_table(:,toggle_steps.run_phase_proportion_bin.variables);
        run_mean_prop_in_given_bin_cluster(outcomes,region_table,g1_g2_overlap_clusters,g1_nog2_clusters,save_dir,overlap_vec,bin_idx_table,order_dist,order,groups,amp_dist_all,MI_norm);
    end
    %% this is to look at average hf amplitude in each lf phase bin - only run/visualize if all_plots turned on
    if all_plots ; compute_ave_hf_amp_in_lf_bin(g1_g2_overlap_clusters,g1_nog2_clusters,region_table,amp_dist_all,save_dir,groups,alpha); end
    %% Phase proportion
    %compute phase proportion over anterior/posterior/whole brain for all freqs and each frequecny pair
    %phase_prop_bins = compute_phase_props(amp_dist_all,groups, freq_table,lf_labels,hf_labels,comodulogram_row_headers,comodulogram_column_headers,anterior,posterior);
   if toggle_steps.run_all | toggle_steps.run_phase_prop_analyses
    phase_prop_bins = struct();
    for overlap = 1:2 % 1 overlap 2 dont
        if overlap ==2
            curr_cluster = g1_g2_overlap_clusters;
        elseif overlap == 1
            curr_cluster = g1_nog2_clusters;
        end % Figure 5: Group differences of phase bias proportion in lf-hf pair coupling for overlap and non overlapped clusters.
        phase_prop_bins = compute_phase_props(phase_prop_bins,amp_dist_all,groups, freq_table,lf_labels,hf_labels,comodulogram_row_headers,comodulogram_column_headers,[region_table(:,{'Anterior','Posterior'}) table([1:18],'VariableNames',{'WholeBrain'})],curr_cluster,overlap);
    end
    %phase bias stats for phase prop
    phase_stats = compute_phase_prop_stats(phase_prop_bins,alpha,groups,save_dir);
    %plot and save phase proportion and stats
    plot_phase_prop_and_stats(phase_prop_bins,phase_stats,groups,save_dir,alpha);% Figure 5: Group differences of phase bias proportion in lf-hf pair coupling for overlap and non overlapped clusters. Not masked for significance
   end
end