function [] = plot_pac_phase_bias_scatter(outcomes,save_dir,groups)
%to do fix strength label
count = 1;
polar_names = outcomes.Properties.VariableNames(contains(outcomes.Properties.VariableNames,'_PhasBias_NoCircMean'));
for polar_name = 1:length(polar_names)
x_g1= (outcomes{(outcomes.Group_Num==1),polar_names{polar_name}});
x_g2= (outcomes{(outcomes.Group_Num==2),polar_names{polar_name}});
[p,h,stats] =ranksum(x_g1,x_g2);
dim = [0.15 0.6 0.3 0.3];
str = {strcat('p =',num2str(p))};%strcat('U =',num2str(stats.ranksum)};
    if nansum(x_g1)==0 && nansum(x_g2)==0; continue ; end   


x_g1 = x_g1(~isnan(x_g1));
    g1_avg = circ_mean(x_g1);
    x_g2 = x_g2(~isnan(x_g2));
    g2_avg = circ_mean(x_g2);
%     subplot(3,3,count)
   fig = figure;
    b = .95;
    a = 1.05;
    w_g1 = (b-a).*rand(length(x_g1),1) + a;
    f = scatter(w_g1,x_g1',10,'MarkerFaceColor',[0.8500 0.3250 0.0980],'MarkerEdgeColor',[0.8500 0.3250 0.0980],'DisplayName',groups{1,1});
    hold on
    b = -.05;
    a = .05;
    w_g2 = (b-a).*rand(length(x_g2),1) + a;
    scatter(w_g2,x_g2',10,'MarkerFaceColor',[0.4660 0.6740 0.1880],'MarkerEdgeColor',[0.4660 0.6740 0.1880],'DisplayName',groups{1,2});
    title(strrep(polar_names{polar_name},'_',' '));
    xlim([-.5 1.5]);

    %get average line axes
    line_width = (max(range(w_g2),range(w_g1)))*4;
try
    plot([median(w_g1)-line_width/2,median(w_g1)+line_width],[g1_avg,g1_avg],'--','Color',[0.8500 0.3250 0.0980],'LineWidth',2,'HandleVisibility','off');
catch
    a=5
end
    plot([median(w_g2)-line_width/2,median(w_g2)+line_width],[g2_avg,g2_avg],'--','Color',[0.4660 0.6740 0.1880],'LineWidth',2,'HandleVisibility','off');
    set(gca,'Xtick',[])
   % ylim([-0.75, 2.5]);
    legend('Location','northeast')
    count = count+1;
    annotation('textbox',dim,'String',str,'FitBoxToText','on');
    saveas(fig,strcat(save_dir, filesep, 'Images', filesep, 'Freqband Phase Bias Ratio Plots' ,filesep,polar_names{polar_name},'.pdf'));
    close(fig)
  %  saveas(f,['/Users/flemingpeck/Dropbox (BCH)/BCH/Levin Lab/ABCCT/PAC/Freqband_strengthplots/',names{t},'.pdf']);
end