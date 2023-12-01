function [] = plot_phase_maps(chan_labels,groups_label,save_dir,column_headers, row_headers,colors,vargin)

for group = 1:length(groups_label)
for ch = 1:18
    
    im = vargin.(groups_label{1,group})(:,:,ch);
    %yb note - this looks like it does the same thing just on different color
%scheme/no numbers, commenting out this version b/c its more difficult to
%plot w/ topoplots
%     figure;
%     all = heatmap(flipud(im),'Colormap',pink,'XData',column_headers,'YData',flipud(row_headers(:)), ...
%         'XLabel','Phase Frequency (Hz)','YLabel','Amplitude Frequency (Hz)','Title',chan_labels(ch),'ColorLimits',[-pi pi]);
%     axs = struct(gca); %ignore warning that this should be avoided
%     saveas(all,strcat(save_dir, filesep ,'Images' ,filesep ,'Cluster Phase Maps', filesep ,groups_label{group},'_',chan_labels(ch),'_cluster_phase_allfreqpairs','.png'))
%% %% CIRCULAR plot phase maps

    fig=figure;
    imagesc(flipud(im));
%     set(gca, 'YTick',1:length(comodulogram_row_headers) ,'YTickLabel', flipud(comodulogram_row_headers));
%     set(gca, 'XTick',1:length(comodulogram_column_headers),'XTickLabel', comodulogram_column_headers);
     %phasemap;
     colormap pink
set(gca,'CLim',[-pi pi]);
 %   xlabel('Phase Frequency (Hz)');
 set(gca,'XTick',[]); set(gca,'YTick',[]);
 saveas(fig,strcat(save_dir, filesep ,'Images' ,filesep ,'Extra', filesep ,'Cluster Phase Maps', filesep ,groups_label{group},'_',chan_labels(ch),'_cluster_phase_allfreqpairs','.png'))
 close(fig)
 %   ylabel('Amplitude Frequency (Hz)');
%     title(chan_labels(ch));
clear im
end
topoplot_of_comod_allm_yb('_cluster_phase_allfreqpairs.png',strcat(save_dir, filesep,'Images',filesep,'Extra',filesep,'Cluster Phase Maps'),groups_label{1,group},colors)
end