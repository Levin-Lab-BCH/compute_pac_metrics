function [] = plot_phase_prop_and_stats(phase_prop_bins,phase_stats,groups,save_dir,alpha,colors)
curr_fields = fields(phase_prop_bins);
for region = 1:length(curr_fields)
    % plot and save phase proportion
if any(isnan(phase_prop_bins.(curr_fields{region}).(groups{1,1}))) | any(isnan(phase_prop_bins.(curr_fields{region}).(groups{1,2})))
    continue
end
    fig = figure;
f = polarplot([alpha, alpha(1)], [mean(phase_prop_bins.(curr_fields{region}).(groups{1,1}),1), mean(phase_prop_bins.(curr_fields{region}).(groups{1,1})(:,1),1)],'-s','LineWidth',2,'Color',colors{1,1});
hold on
polarplot([alpha, alpha(1)], [mean(phase_prop_bins.(curr_fields{region}).(groups{1,2}),1), mean(phase_prop_bins.(curr_fields{region}).(groups{1,2})(:,1),1)],'-s','LineWidth',2,'Color',colors{1,2});
legend(groups)
title(['Phase Proportion ',curr_fields{region}],'FontSize',14)
rlim([0 .2])
saveas(f,[save_dir filesep 'Images' filesep 'Phase Bin Proportion' filesep curr_fields{region} '.png']);
close(fig)
    %plot and save stats
if 0 %don't plot p values in polar plots for now
    fig = figure;
f = polarplot([alpha, alpha(1)], [phase_stats.(curr_fields{region})(:)',phase_stats.(curr_fields{region})(1)],'-s','LineWidth',2);
title(['Phase Proportion Stats:',curr_fields{region}],'FontSize',14)
 rlim([0 .05])
saveas(f,[save_dir filesep 'Images' filesep 'Phase Bin Proportion' filesep curr_fields{region} '_stats.png']);%pdf of png?
close(fig)
end
end