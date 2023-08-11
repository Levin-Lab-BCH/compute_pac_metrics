%% this is to look at average hf amplitude in each lf phase bin
function [] = compute_ave_hf_amp_in_lf_bin(g1_g2_overlap_clusters,g1_nog2_clusters,region_table,amp_dist,save_dir,groups,alpha)
% wasn't too fruitful :/
% crop the dataframes
for overlap = 1:2
        if overlap == 1; curr_cluster = g1_g2_overlap_clusters; title_suffix = ''; elseif overlap ==2; curr_cluster =g1_nog2_clusters; title_suffix = [groups{1,1}, ' Only'];end
for region = 1:length(region_table.Properties.VariableNames) % loop over regions
    x = curr_cluster(:,:,region_table{1,region_table.Properties.VariableNames(region)});
    idxs = find(x ~= 0);
    if isempty(idxs); continue; end
    [~,~,g1_dist] = calculate_phase_bias_proportion_pac(region_table{1,region_table.Properties.VariableNames(region)},amp_dist.(groups{1,1}),idxs);
    [~,~,g2_dist] = calculate_phase_bias_proportion_pac(region_table{1,region_table.Properties.VariableNames(region)},amp_dist.(groups{1,2}),idxs);
    if ~isequal(sprintf('%.2f',sum(g1_dist)),'1.00') || ~isequal(sprintf('%.2f',sum(g2_dist)),'1.00')
        a = 5;
    end
  fig =  figure;
    f = polarplot(alpha, g1_dist);
    hold on
    polarplot(alpha, g2_dist);
    rlim([.054 .056])
    title(region_table.Properties.VariableNames{region})
   saveas(f,[save_dir filesep 'Images' filesep 'Extra' filesep 'Phase Bias Cluster Average' filesep region_table.Properties.VariableNames{region} title_suffix '.pdf']) ;
close(fig)
end
end