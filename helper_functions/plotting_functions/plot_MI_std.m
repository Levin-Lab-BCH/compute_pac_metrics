% change to directory to save
function [] = plot_MI_std(std_struct,save_dir,groups,comodulogram_row_headers,comodulogram_column_headers,chan_labels)
cd([save_dir filesep 'Images' filesep 'Extra' filesep 'STD maps'])
lim = max([max(max(max(std_struct.(groups{1,1})))) max(max(max(std_struct.(groups{1,2}))))]);
% go through all channels

for ch = 1:size(std_struct.(groups{1,1}),3)


%     im = compare_std(:,:,ch);
% 
%     figure;
%     
%     all = heatmap(flipud(im),'Colormap',fireice(150),'XData',f.comodulogram_column_headers,'YData',flipud(f.comodulogram_row_headers), ...
%         'XLabel','Phase Frequency (Hz)','YLabel','Amplitude Frequency (Hz)','Title',chan_labels(ch),...
%         'ColorLimits',[min(min(min(compare_std))) abs(min(min(min(compare_std))))]);
%     
%     saveas(all,strcat(chan_labels(ch),'_std_compare','.png'));
    
    %%%
    
    im = std_struct.(groups{1,1})(:,:,ch);

    fig = figure;
    
    all = heatmap(flipud(im),'Colormap',hot,'XData',comodulogram_column_headers,'YData',flipud(comodulogram_row_headers), ...
        'XLabel','Phase Frequency (Hz)','YLabel','Amplitude Frequency (Hz)','Title',strcat(groups{1,1},'-',chan_labels(ch) ,' std'),...
        'ColorLimits',[0 lim]);
    
    saveas(all,strcat(chan_labels(ch),'_std_',groups{1,1},'.png'));
    close(fig)
    %%%
%     
%     im = TD_std(:,:,ch);
% 
%     figure;
%     
%     all = heatmap(flipud(im),'Colormap',hot,'XData',f.comodulogram_column_headers,'YData',flipud(f.comodulogram_row_headers), ...
%         'XLabel','Phase Frequency (Hz)','YLabel','Amplitude Frequency (Hz)','Title',chan_labels(ch),...
%         'ColorLimits',[0 lim]);
%     
%     saveas(all,strcat(chan_labels(ch),'_std_TD','.png'));
end