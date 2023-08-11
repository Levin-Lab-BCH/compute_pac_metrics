function [outcomes] = get_mean_prop_in_given_bin_cluster(outcomes,region_table,overlap_clusters,g1only_clusters,curr_dist,bin_table,participant_idx,overlap_vec)
for overlap = 1:length(overlap_vec)
        if overlap == 1; curr_cluster = overlap_clusters; elseif overlap ==2; curr_cluster =g1only_clusters;end
for region = 1:length(region_table.Properties.VariableNames) % loop over regions
    for bin_idx = 1:length(bin_table.Properties.VariableNames)
    x = curr_cluster(:,:,region_table{1,region_table.Properties.VariableNames(region)});
    idxs = find(x ~= 0);
    if isempty(idxs); continue; end
    [~,bin_count_out,~] = calculate_phase_bias_proportion_pac(region_table{1,region_table.Properties.VariableNames(region)},curr_dist,idxs,bin_table{1,bin_table.Properties.VariableNames(bin_idx)});
  if isempty(bin_table) && sum(bin_count_out)~= 1
      error('Count across bins doesn''t sum to 1, check code')
  end
    outcomes{participant_idx,strcmp(outcomes.Properties.VariableNames,strcat(region_table.Properties.VariableNames(region),'_',overlap_vec{overlap},'_',bin_table.Properties.VariableNames(bin_idx)))} = bin_count_out;
    end
end
end
end