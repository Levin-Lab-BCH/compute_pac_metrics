function [] = run_phase_bias_proportion(region_table,curr_cluster,amp_dist,overlap,groups,alpha)
if overlap ==1
    title_suffix = '';
elseif overlap == 2
    title_suffix = [groups{1} ' Only'];
end
for region = 1:length(region_table.Properties.VariableNames) % loop over regions
    x = curr_cluster(:,:,region_table{1,region_table.Properties.VariableNames(region)});
    idxs = find(x ~= 0);
    if isempty(idxs) %if no clusters are signifcant for this region, don't generate plot
        continue
    end
    [pb_g1_proportions,~,~] = calculate_phase_bias_proportion_pac(region_table{1,region_table.Properties.VariableNames(region)},amp_dist.(groups{1,1}),idxs);
% TD
[pb_g2_proportions,~,~] = calculate_phase_bias_proportion_pac(region_table{1,region_table.Properties.VariableNames(region)},amp_dist.(groups{1,2}),idxs);
if ~isequal(sprintf('%.2f',sum(pb_g1_proportions,2)),'1.00')| ~isequal(sprintf('%.2f',sum(pb_g2_proportions,2)),'1.00')
    error('Proportions across bins do not sum to 1, check code')
end
fig = figure;
f = polarplot([alpha, alpha(1)], [pb_g1_proportions, pb_g1_proportions(1)],'-s','LineWidth',2,'Color',[0.8500 0.3250 0.0980]);
hold on
polarplot([alpha, alpha(1)], [pb_g2_proportions, pb_g2_proportions(1)],'-s','LineWidth',2,'Color',[0.4660 0.6740 0.1880]);
title([region_table.Properties.VariableNames(region),' phase bias ',title_suffix]);
%rlim([0 .12]);
rlim([0 1.1]); rticks([.1:.05:1.1]);
rticklabels({'0','.05','.1','.15','.2','.25','.3','.35','.4','.45','.5','.55','.6','.65','.7','.75','.8','.85','.9','.95'})
legend(groups)
%saveas(f,'/Volumes/Flem/ABBCT T1/Images/Phase bias max bin in clusters/posterior.pdf');
close(fig)
end
end