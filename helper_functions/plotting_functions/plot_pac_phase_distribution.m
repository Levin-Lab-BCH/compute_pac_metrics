function [] = plot_pac_phase_distribution(outcomes,save_dir)

labels = outcomes.Properties.VariableNames(contains(outcomes.Properties.VariableNames,'PhaseBins'));
% want just the phase bins from outcomes for td and asd
for i =1:length(labels)
    group_1 = (outcomes{(outcomes.Group_Num==1),labels{i}})';
    g1_mean = nanmean(group_1,2);
    g1_std = nanstd(group_1,0,2);
    group2 = (outcomes{(outcomes.Group_Num==2),labels{i}})';
    g2_mean = nanmean(group2,2);
    g2_std = nanstd(group2,0,2);
    fig = figure('Position',[250 200 450 400]);
    errorbar((1:18)+0.1,g2_mean,g2_std,'Color',[0.4660 0.6740 0.1880],'LineWidth',2)
    hold on
    errorbar((1:18)-0.1,g1_mean,g1_std,'Color',[0.8500 0.3250 0.0980],'LineWidth',2)
    ylim([0.0544 0.0568]);
    title(strrep(labels{i},'_',' '));
    saveas(fig,strcat(save_dir, filesep, 'Images', filesep, 'Extra', filesep, 'Phase Bin Freqband Plots' ,filesep,labels{i},'.png'));
    close(fig)
end
end