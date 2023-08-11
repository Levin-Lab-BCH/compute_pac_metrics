function [] = plot_pac_phase_bias(outcomes,save_dir,groups)

polar_names = outcomes.Properties.VariableNames(contains(outcomes.Properties.VariableNames,'PhaseBias'));
count = 1;
for polar_name = 1:length(polar_names)
x_g1= (outcomes{(outcomes.Group_Num==1),polar_names{polar_name}});
x_g2= (outcomes{(outcomes.Group_Num==2),polar_names{polar_name}});
 if nansum(x_g1)==0 && nansum(x_g2)==0; continue ; end   
    x_g1 = x_g1(~isnan(x_g1));
    g1_avg = circ_mean(x_g1);
    
    x_g2 = x_g2(~isnan(x_g2));
    g2_avg = circ_mean(x_g2);
    
    fig = figure;
%     subplot(3,3,count);
    f = polarscatter(x_g1,zeros(size(x_g1))+.85,30,'filled','^','MarkerFaceColor',[0.8500 0.3250 0.0980],'DisplayName',groups{1,1});
    hold on
    polarscatter(x_g2,zeros(size(x_g2))+0.8,30,'filled','^','MarkerFaceColor',[0.4660 0.6740 0.1880],'DisplayName',groups{1,2});
    polarscatter(g1_avg,0.5,65,'filled','MarkerFaceColor',[0.8500 0.3250 0.0980],'HandleVisibility','off');
    polarscatter(g2_avg,0.5,65,'filled','MarkerFaceColor',[0.4660 0.6740 0.1880],'HandleVisibility','off');
    title(strrep(polar_names{polar_name},'_',' '));
    rlim([0 1]);  
    rticks(gca,[])
    legend('Location','best')
    count = count +1;
    saveas(fig,strcat(save_dir, filesep, 'Images', filesep, 'Freqband Polar Plots' ,filesep,polar_names{polar_name},'.png'));
    close(fig)
  %  saveas(f,['/Users/flemingpeck/Dropbox (BCH)/BCH/Levin Lab/ABCCT/PAC/Freqband_Polarplots/',names{t},'_UPDATED.pdf']);
end
end