% Update report table to report the average MI value where either only
% RTT/ASD was sig or both RTT/ASD and TD were significant
function [outcomes] = compute_MI_average(outcomes,order_dist,order,groups,amp_dist,MI_norm,g1_g2_overlap_clusters,g1_nog2_clusters,region_table,overlap_vec)
outcomes = update_outcomes_table(outcomes,overlap_vec,region_table.Properties.VariableNames,{'avg'});
for index = 1:size(outcomes,1)
    id = outcomes.Participant(index);
    
    try
    [dx,~] = check_dx(id{1,1},outcomes);
    catch
        A = 5;
    end
    [continue_flag,~,MInorm] = get_curr_dist_norm(dx,order_dist, order, groups,amp_dist,MI_norm,id);
    if continue_flag
        continue
    end
    g1_only = MInorm .* g1_nog2_clusters;
    overlap = MInorm .* g1_g2_overlap_clusters;
    for lap = 1:length(overlap_vec) % loop over overlap or asd/rtt only
        for region = 1:length(region_table.Properties.VariableNames) % loop over regions
            if lap == 1
                x = overlap(:,:,region_table{1,region_table.Properties.VariableNames(region)});
            elseif lap == 2
                 x = g1_only(:,:,region_table{1,region_table.Properties.VariableNames(region)});
            end
            sum_vals = sum(sum(sum(x)));
            total_vals = sum(sum(sum(x>0)));
            avg = sum_vals / total_vals; if isinf(avg); avg=NaN; end
            outcomes{index,strcmp(outcomes.Properties.VariableNames,[overlap_vec{lap},'_',region_table.Properties.VariableNames{region},'_avg'])} = avg;
        end
    end
end