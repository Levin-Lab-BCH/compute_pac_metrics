function [] = plot_sig_phase_bias_comods(std_struct,phase_in_clusters,groups,comodulogram_row_headers,comodulogram_column_headers,chan_labels,save_dir)
warning off MATLAB:structOnObject ; %turning off warning that gets thrown to clean up command window

cd([save_dir filesep 'Images' filesep 'Extra' filesep 'Phase bias maps'])
lim = max([max(max(max(std_struct.(groups{1,1})))) max(max(max(std_struct.(groups{1,2}))))]);
% go through all channels
for ch = 1:18

    for group = 1:length(groups)
    im = phase_in_clusters.(groups{1,group})(:,:,ch);
   fig = figure;
    
    all = heatmap(flipud(im),'Colormap',pink,'XData',comodulogram_column_headers,'YData',flipud(comodulogram_row_headers), ...
        'XLabel','Phase Frequency (Hz)','YLabel','Amplitude Frequency (Hz)','Title',chan_labels(ch),...
        'ColorLimits',[0 18]);
    axs = struct(gca); %ignore warning that this should be avoided
    cb = axs.Colorbar;
    cb.Ticks = [0:1:18];
    cb.TickLabels = {'','-170°', '-150°', '-130°', '-110°',  '-90°',  '-70°',  '-50°',  '-30°', '-10°',  '10°',   '30°', ...
   '50°',   '70°',   '90°',  '110°',  '130°',  '150°',  '170°'};
    saveas(all,strcat(chan_labels(ch),['_',groups{group},'_phase_in_clusters','.png']));
    close(fig)
    end

end
warning on MATLAB:structOnObject ; %turning back on
