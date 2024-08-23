function [sig_clusters,cluster_threshold,sig_clusters_t,cluster_threshold_t] = generate_significant_clusters_PAC(cluster_dist,cluster_dist_t, cluster_stats,cluster_stats_t,clusters_orig)

% for each channel, save the significant clusters
sig_clusters = zeros(size(clusters_orig,1),size(clusters_orig,2),size(clusters_orig,3));

% for each channel, save the significant clusters
sig_clusters_t = zeros(size(clusters_orig,1),size(clusters_orig,2),size(clusters_orig,3));



% identify cluster thresholds
clusters_sorted = sort(cell2mat(cluster_dist(2:end)));


if length(clusters_sorted)<2 %if no sig clusters were found
    cluster_threshold = nan;
    cluster_threshold_t = nan;
    return
end
try
cluster_threshold = clusters_sorted(floor(length(clusters_sorted)*.95));
catch
    a = 5
end

% identify cluster thresholds by t_scores
clusters_sorted_t = sort(cell2mat(cluster_dist_t()));
cluster_threshold_t = clusters_sorted_t(floor(length(clusters_sorted_t)*.95));
% compute 95th percentile of distribution
% identify significant clusters in ASD and TD (based on SIZE)
% arranged by cluster number x channel
sig_clusters_idx = cellfun(@(x)sum(x>cluster_threshold),cluster_stats);
sig_clusters_idx_t = cellfun(@(x)sum(x>cluster_threshold_t),cluster_stats_t);


for ch = 1:size(cluster_stats,1) %that should be the # of channels 
    % repeat for ASD
    ch_clusters = sig_clusters_idx(ch,:);
    
    cluster_idxs = find(ch_clusters>0);



    
    for c_i = 1:length(cluster_idxs)
        sig_clusters(:,:,ch) = sig_clusters(:,:,ch) + (clusters_orig(:,:,ch) == cluster_idxs(c_i))*1;
    end

        %t scores
        ch_clusters_t = sig_clusters_idx_t(ch,:);
    
    cluster_idxs_t = find(ch_clusters_t>0);

       for c_i = 1:length(cluster_idxs_t)
        sig_clusters_t(:,:,ch) = sig_clusters_t(:,:,ch) + (clusters_orig(:,:,ch) == cluster_idxs_t(c_i))*1;
       end
    
end