% Author: Yael Braverman - modified/refactored from Fleming Peck's pac_analysis script
function [] = compute_pac_metrics(grp_proc_info_in)
outcomes_path = grp_proc_info_in.pac_metrics.path_struct.outcomes_path;
src_dir =  fullfile(grp_proc_info_in.pac_metrics.path_struct.src_dir,strcat('pac',grp_proc_info_in.pac_metrics.path_struct.beapp_run_tag));

%% DO NOT EDIT BELOW THIS LINE
overwrite_unique_combs = grp_proc_info_in.overwrite_unique_combs;
if ~isfield(grp_proc_info_in.pac_metrics,'shade_freq_band')
    shade_freq_band = 0;
else
    shade_freq_band = grp_proc_info_in.pac_metrics.shade_freq_band;
end
addpath(genpath(grp_proc_info_in.pac_metrics.path_struct.code_path));
groups = grp_proc_info_in.pac_metrics.groups;
all_plots = 1;
% Prepare Directions
save_dir = [src_dir filesep 'results']; prepare_pac_directories(save_dir);
addpath(genpath(src_dir)); cd(src_dir);
flist = dir(fullfile(src_dir,'*.mat')); flist = {flist.name}';
if isempty(flist); error(['no files found at ' ,src_dir, ',check path inputs and retry']); end
chan_labels = [grp_proc_info_in.chan_labels];
if isempty(chan_labels)
    % Plotting Channel Information/ Channel Maps I confirmed that these ARE in the right order (fleming)
chan_labels = ["FP2","Fz","FP1","F3","F7","C3","T3","P3","T5","Pz","O1","O2","P4","T6","C4","T4","F8","F4"];
end
anterior = grp_proc_info_in.pac_metrics.anterior;
posterior = grp_proc_info_in.pac_metrics.posterior;

%anterior =  [1,2,3,4,5,17,18];% (Fp2, Fz, Fp1, F3, F7, F8, F4) %confirm these are set in order by beapp
%posterior = [9,14,10,11,12];% (P7, P8, Pz, O1, O2)
freq_table = table([ 4; 8], [8;  12],[12; 20],[28; 56],[44 ;56],'VariableNames',{'Theta','Alpha','Beta','Gamma','HighGamma'},'RowNames',{'Minimum','Maximum'});
lf_labels = {'Theta','Alpha','Beta'};
hf_labels = {'Gamma','Gamma','HighGamma'};
alpha_deg = linspace((-17/18) * pi, (17/18) * pi,18);
%% Open All Files and Create / Save Participant and Surrogate MI Variables for later
% open all files and create huge blocks for g1 (ASD or RTT for example) and no ASD/RTT conditions
if grp_proc_info_in.pac_metrics.toggle_steps.load_files
    outcomes = readtable(outcomes_path);
    [amp_dist_all,order_dist,order,MI_surr, MI_raw, MI_norm, ...
        comodulogram_column_headers, comodulogram_row_headers, comodulogram_third_dim_headers]= generate_MI_surr(flist,outcomes,src_dir,save_dir,groups);
else
    cd([save_dir filesep 'PAC analysis variables'])
    load([save_dir filesep 'PAC analysis variables' filesep 'PAC_analysis_variables.mat'])
end
%% check distributions
if grp_proc_info_in.pac_metrics.toggle_steps.run_permutations
    plot_surr_dist(MI_surr,comodulogram_row_headers,comodulogram_column_headers,groups)
    %% Approach 1: Cluster analysis
    % Step 1: Measure Cluster Sizes In Dataset by checking 1) where in comodulogram there is PAC above surrogate and 2) where/how big the remaining clusters are
    cd([save_dir filesep 'PAC analysis variables'])
    row = length(comodulogram_row_headers); column = length(comodulogram_column_headers); third = length(comodulogram_third_dim_headers);
    for group = 1:length(groups)
        % Call function to generate matrices that are sig above surrogate dist for each group
        [sig_points.(groups{1,group}),pvalues.(groups{1,group}),tvalues.(groups{1,group}),df.(groups{1,group})] = create_PAC_clusters(MI_surr.(groups{1,group}),MI_raw.(groups{1,group}));
        % Call function to identify where clusters are and measure their size
        [clusters.(groups{1,group}),cluster_stats.(groups{1,group}),cluster_stats_t.(groups{1,group})] = characterize_PAC_clusters(sig_points.(groups{1,group}),tvalues.(groups{1,group}),row,column,third);
    end
    %% FINAL cluster plots
    % 1000 iterations
    same_idxs.(groups{1,1}) = []; flip_idxs.(groups{1,1}) = []; same_idxs.(groups{1,2}) = []; flip_idxs.(groups{1,2}) = [];
    for group = 1:length(groups)
        %  Cluster analysis Step 2: Run permutation (swapping surrogate/ ids into raw and vice versa)  Then, permutation test of significance
        [cluster_dist.(groups{1,group}),cluster_dist_t.(groups{1,group})] = run_PAC_permutations(MI_raw.(groups{1,group}),MI_surr.(groups{1,group}),flip_idxs.(groups{1,group}),same_idxs.(groups{1,group}),overwrite_unique_combs);
    end
    %% Cluster analysis Step 3: Check which of the original clusters pass the threshold after running the permutations
    for group = 1:length(groups)
        [sig_clusters.(groups{1,group}),cluster_threshold.(groups{1,group}),sig_clusters_t.(groups{1,group}),cluster_threshold_t.(groups{1,group})] = generate_significant_clusters_PAC(cluster_dist.(groups{1,group}),cluster_dist_t.(groups{1,group}),cluster_stats.(groups{1,group}),cluster_stats_t.(groups{1,group}),clusters.(groups{1,group}));
    end
    %%
    save(strcat('PAC_cluster_variables.mat'),'clusters','cluster_stats','cluster_stats_t','cluster_dist','cluster_dist_t','sig_points','sig_clusters','sig_clusters_t','cluster_threshold','cluster_threshold_t','tvalues');
    %end
else
    cd([save_dir filesep 'PAC analysis variables']);
   load([save_dir filesep 'PAC analysis variables' filesep 'PAC_cluster_variables.mat']);
end
%% Approach 2: g1 vs g2 tests (ex: RTT vs TD or ASD vs TD)

if grp_proc_info_in.pac_metrics.toggle_steps.run_compare_clusters
    %% ASD/RTT vs TD step 1: Get initial sig map comparing MI_norms for ASD/RTT vs TD
    [compare_sig_points,compare_pvalues,compare_tvalues,~]=create_PAC_clusters(MI_norm.(groups{1,1}),MI_norm.(groups{1,2}));
    % Call function to identify where clusters are in original data and measure their size
    [compare_clusters,compare_cluster_stats,compare_cluster_stats_t] = characterize_PAC_clusters(compare_sig_points,compare_tvalues,length(comodulogram_row_headers),length(comodulogram_column_headers),length(comodulogram_third_dim_headers));
    %% ASD/RTT vs TD step 2: permutation test
    % Then, permutation test of significance
    [compare_cluster_dist,compare_cluster_dist_t] = run_PAC_permutations(MI_norm.(groups{1,1}),MI_norm.(groups{1,2}),[],[],overwrite_unique_combs);
    %% ASD/RTT vs TD step 3: identify significant clusters
    [compare_sig_clusters,compare_cluster_threshold,compare_sig_clusters_t,compare_cluster_threshold_t] = generate_significant_clusters_PAC(compare_cluster_dist,compare_cluster_dist_t,compare_cluster_stats,compare_cluster_stats_t,compare_clusters);
    cd([save_dir filesep 'PAC analysis variables'])
    save('PAC_compare_cluster_variables.mat','MI_norm','compare_cluster_dist','compare_cluster_threshold','compare_sig_clusters', ...
        'compare_clusters','compare_sig_clusters_t','compare_cluster_threshold_t','compare_cluster_stats','compare_sig_points','compare_tvalues','compare_pvalues');
else
    cd([save_dir filesep 'PAC analysis variables'])
    load([save_dir filesep 'PAC analysis variables' filesep 'PAC_compare_cluster_variables.mat'])
end

%% FINAL FIGURE ASD/RTT - TD strength - Fig 2C: Topoplot visualizing the channel- and frequency-space differences in PAC strength by subtracting TD PAC strength in (B) from ASD PAC strength in (A)
plot_g1_minus_g2_pac_strength(MI_norm,groups,chan_labels,save_dir,grp_proc_info_in.pac_metrics.colors); 
%% Standard deviations of ASD/RTT and TD
[std_struct] = compute_MI_std(MI_raw,save_dir,groups);
%% plot standard deviation  only run if doing "all plots" not generated for PAC paper
% change to directory to save
if all_plots ; plot_MI_std(std_struct,save_dir,groups,comodulogram_row_headers,comodulogram_column_headers,chan_labels); end
%% Analyses that don't depend on clustering methods - Freqband analysis
%% FREQ BAND ANALYSIS First compute the phase strength, phase bias, and phase dist for each freq band then plot
if grp_proc_info_in.pac_metrics.toggle_steps.run_all | grp_proc_info_in.pac_metrics.toggle_steps.run_freq_band_analysis
    outcomes = readtable(outcomes_path);
    
    if grp_proc_info_in.set_chan_groups == 0 %if yo udont want to set it run the defaults
    [outcomes] = run_phase_metrics_freq_band_analysis(lf_labels,hf_labels,freq_table,{'WholeBrain','Anterior','Posterior','FP1FP2','C3C4','O1O2'},{[1:18],anterior,posterior,[1,3],[6,15],[11,12]},outcomes,comodulogram_column_headers,comodulogram_row_headers,order_dist,order,groups,amp_dist_all,MI_norm,alpha_deg);
    else
        [outcomes] = run_phase_metrics_freq_band_analysis(lf_labels,hf_labels,freq_table,grp_proc_info_in.chan_group_labels,grp_proc_info_in.chan_group_positions,outcomes,comodulogram_column_headers,comodulogram_row_headers,order_dist,order,groups,amp_dist_all,MI_norm,alpha_deg);
    end
    writetable(outcomes,[save_dir filesep 'freqband_PAC_metrics_complete.xlsx']);
    %plot phase distribution
    if 1; plot_pac_phase_distribution(outcomes,save_dir,grp_proc_info_in.pac_metrics.colors); end
    %polar plots phase bias - Figure 4: Individual and Group Average Phase Preference
    plot_pac_phase_bias(outcomes,save_dir,groups,grp_proc_info_in.pac_metrics.colors)
    %strength plots - Figure 3: Individual PAC Strength
    plot_pac_strength(outcomes,save_dir,groups,grp_proc_info_in.pac_metrics.colors)
    % phase bias scatter plots - using the ratio method and not circ_mean
    plot_pac_phase_bias_scatter(outcomes,save_dir,groups,grp_proc_info_in.pac_metrics.colors)
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
    plot_sig_pac_clusters(curr_sig_cluster,comodulogram_row_headers,comodulogram_column_headers,comodulogram_third_dim_headers,groups,save_dir,chan_labels,grp_proc_info_in.pac_metrics.colors,hf_labels,lf_labels,freq_table,shade_freq_band)

    %% plot significant clusters - only run if doing "all plots" not generated for PAC paper
    % make channel plots with ASD/RTT and TD overlap and save plots of significance
    if all_plots; plot_sig_pac_clusters_g1vsg2(compare_sig_clusters,comodulogram_row_headers,comodulogram_column_headers,comodulogram_third_dim_headers,save_dir,chan_labels,compare_cluster_dist); end

    %% FINAL FIGURE WITH BOUNDARIES AROUND CLUSTERS - CHECK IF NEEDED OR DO FOR ALL PLOTS
    % change to directory to save - Fig 2A/B: topoplot with normalized PAC strength color-coded using the PAC strength legend increasing from black (low strength) to yellow (high strength). frequency groupings noted with a white outline.
    plot_clusters_with_boundaries(curr_sig_cluster.(groups{1,1}),MI_norm.(groups{1,1}),comodulogram_row_headers,comodulogram_column_headers,comodulogram_third_dim_headers,chan_labels,save_dir,groups{1,2},grp_proc_info_in.pac_metrics.colors)
    if grp_proc_info_in.pac_metrics.toggle_steps.run_all | grp_proc_info_in.pac_metrics.toggle_steps.report_MI_av_sheet
        %% find MI average and save to report table
        % set up report table
        outcomes = readtable(outcomes_path);
        overlap_vec = {'Overlap',[groups{1,1},'only']};
        %[8,13,9,14,10,11,12]
        %[1,2,3,4,5,17,18]
        if grp_proc_info_in.set_chan_groups == 0 %if yo udont want to set it run the defaults
        region_table = table([1,3], [11,12],[7,16],[6, 15],anterior,posterior,'VariableNames',{'FP1FP2','O1O2','T3T4','C3C4','Anterior','Posterior'});
        else
            region_table = table(cell2mat(grp_proc_info_in.chan_group_positions),'VariableNames',grp_proc_info_in.chan_group_labels); %might have an issue with multiple channels
        end
        [outcomes] = compute_MI_average(outcomes,order_dist,order,groups,amp_dist_all,MI_norm,g1_g2_overlap_clusters,g1_nog2_clusters,region_table,overlap_vec);

        writetable(outcomes,[save_dir filesep 'PAC_MInorm_cluster_averages_revised_allfreqpairs.xlsx']);
    end
    %% PHASE BIAS
    % want to average each phase bin across all significant frequency pairs in a cluster for each participant average across all participants within each group

    %% plot maps phase_bias_comods only run if doing "all plots" not generated for PAC paper
    if grp_proc_info_in.pac_metrics.toggle_steps.visualize_phase_bias_comods
        %% find highest phase bin value for each frequency pair -
        [max_phase_bin,max_phase_value] = compute_max_phase_bin_and_val(amp_dist_all,groups);
        phase_in_clusters.(groups{1,1}) = max_phase_bin.(groups{1,1}).*curr_sig_cluster.(groups{1,1});% map of group1 phase in group1 clusters (ex: RTT or ASD)
        phase_in_clusters.(groups{1,2}) = max_phase_bin.(groups{1,2}).*curr_sig_cluster.(groups{1,2}); % map of TD phase in TD clusters
        plot_sig_phase_bias_comods(std_struct,phase_in_clusters,groups,comodulogram_row_headers,comodulogram_column_headers,chan_labels,save_dir);

        %% Phase bias - compute group average phase bias and phase bias by participant (2nd output)
        [phase_bias_avg,phase_matrices] = compute_phase_bias_average(alpha_deg,amp_dist_all,comodulogram_row_headers,comodulogram_column_headers,comodulogram_third_dim_headers,groups);
        %% plot phase maps - only run if all_plots turned on - not included in PAC manuscript
        clusters_phase.(groups{1,1}) = phase_bias_avg.(groups{1,1});
        clusters_phase.(groups{1,2}) = phase_bias_avg.(groups{1,2});
        plot_phase_maps(chan_labels,groups,save_dir,comodulogram_column_headers,comodulogram_row_headers,grp_proc_info_in.pac_metrics.colors,clusters_phase);
    end
    %% compute and plot phase bias proportion for rois with g1 and g2 sig and those with just g1 sig
    %YB note: could adjust r axis / limits later
    if grp_proc_info_in.pac_metrics.toggle_steps.run_all | grp_proc_info_in.pac_metrics.toggle_steps.plot_phase_bias_proportion
        for overlap = 1:2 % 1 overlap 2 dont
            if overlap ==2
                curr_cluster = g1_nog2_clusters;
            elseif overlap == 1
                curr_cluster = g1_g2_overlap_clusters;
            end % Figure 5: Group differences of phase bias proportion in lf-hf pair coupling for overlap and non overlapped clusters.
            run_phase_bias_proportion(region_table,curr_cluster,amp_dist_all,overlap,groups,alpha_deg) %% plot all participants phase bias proportion
        end
    end
    % identify indexes of clusters of interest
    %% identify the mean proportion in phase bin in cluster
    % do for g1 and g2 for ALL, get g1only clusters and overlap_clusters from above
    if grp_proc_info_in.pac_metrics.toggle_steps.run_all | grp_proc_info_in.pac_metrics.toggle_steps.run_phase_proportion_by_bin
        full_table = table([1],[2],[3],[4],[5],[6],[7],[8],[9],[10],[11],[12],[13],[14],[15],[16],[17],[18],'VariableNames', ...
            {'neg170deg','neg150deg','neg130deg','neg110deg','neg90deg','neg70deg','neg50deg','neg30deg','neg10deg','10deg','30deg','50deg', ...
            '70deg','90deg','110deg','130deg','150deg','170deg'},'RowNames',{'bin_idx'});
        outcomes = readtable(outcomes_path); % to do - make bin_idx_table automatic
        bin_idx_table = full_table(:,grp_proc_info_in.pac_metrics.toggle_steps.run_phase_proportion_bin_variables);
        run_mean_prop_in_given_bin_cluster(outcomes,region_table,g1_g2_overlap_clusters,g1_nog2_clusters,save_dir,overlap_vec,bin_idx_table,order_dist,order,groups,amp_dist_all,MI_norm);
    end
    %% this is to look at average hf amplitude in each lf phase bin - only run/visualize if all_plots turned on
    if all_plots ; compute_ave_hf_amp_in_lf_bin(g1_g2_overlap_clusters,g1_nog2_clusters,region_table,amp_dist_all,save_dir,groups,alpha_deg); end
    %% Phase proportion
    %compute phase proportion over anterior/posterior/whole brain for all freqs and each frequecny pair
    if grp_proc_info_in.pac_metrics.toggle_steps.run_all | grp_proc_info_in.pac_metrics.toggle_steps.run_phase_prop_analyses
        phase_prop_bins = struct();
        for overlap = 1:2 % 1 overlap 2 dont
            if overlap ==2
                curr_cluster = g1_g2_overlap_clusters;
            elseif overlap == 1
                curr_cluster = g1_nog2_clusters;
            end % Figure 5: Group differences of phase bias proportion in lf-hf pair coupling for overlap and non overlapped clusters.
            if grp_proc_info_in.set_chan_groups == 0 %if yo udont want to set it run the defaults
                region_input = [region_table(:,{'Anterior','Posterior'}) table([1:18],'VariableNames',{'WholeBrain'})];
            else
                region_input = [region_table(:,grp_proc_info_in.chan_group_labels)]; %might have an issue with multiple channels
            end

            phase_prop_bins = compute_phase_props(phase_prop_bins,amp_dist_all,groups, freq_table,lf_labels,hf_labels,comodulogram_row_headers,comodulogram_column_headers,region_input,curr_cluster,overlap);
        end
        %phase bias stats for phase prop
        phase_stats = compute_phase_prop_stats(phase_prop_bins,alpha_deg,groups,save_dir);
        %plot and save phase proportion and stats
        plot_phase_prop_and_stats(phase_prop_bins,phase_stats,groups,save_dir,alpha_deg,grp_proc_info_in.pac_metrics.colors);% Figure 5: Group differences of phase bias proportion in lf-hf pair coupling for overlap and non overlapped clusters. Not masked for significance
    end
end