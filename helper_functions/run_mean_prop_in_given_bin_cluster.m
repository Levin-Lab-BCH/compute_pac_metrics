function [] = run_mean_prop_in_given_bin_cluster(outcomes,region_table,g1_g2_overlap_clusters,g1_nog2_clusters,save_dir,overlap_vec,bin_idx_table,order_dist,order,groups,amp_dist,MI_norm)
outcomes = update_outcomes_table(outcomes,region_table.Properties.VariableNames,overlap_vec,bin_idx_table.Properties.VariableNames)  ;
    %13 anterior 70 fp1fp2_overlap_neg130d  
for index = 1:size(outcomes,1)
    
    %disp(index)
    
    id = outcomes.Participant(index);
    [dx,p_idx] = check_dx(id{1,1},outcomes,1);

   % disp(id);
    
    % if not in order or curr_dist value is nan, continue
    [continue_flag,curr_dist,~] = get_curr_dist_norm(dx,order_dist, order, groups,amp_dist,MI_norm,id);
    if continue_flag
        continue
    end   
  outcomes =  get_mean_prop_in_given_bin_cluster(outcomes,region_table,g1_g2_overlap_clusters,g1_nog2_clusters,curr_dist,bin_idx_table,p_idx,overlap_vec);
end
writetable(outcomes,[save_dir filesep 'cluster_bin_proportion_allfreqpairs.xlsx']);