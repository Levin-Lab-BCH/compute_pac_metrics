
% make channel plots with ASD/RTT and TD overlap
function [] = plot_sig_pac_clusters_g1vsg2(compare_sig_clusters,comodulogram_row_headers,comodulogram_column_headers,comodulogram_third_dim_headers,save_dir,chan_labels,compare_cluster_dist)
% save plots of significance
% open test file to get column labels
% change to directory to save
cd([save_dir filesep 'Images' filesep 'Cluster maps'])
% go through all channels

for ch = 1:length(comodulogram_third_dim_headers)

    compare_im = compare_sig_clusters(:,:,ch);

   fig =  figure;
    
    imagesc(flipud(compare_im));
    hAxes = gca;
    colormap( hAxes , pink );
    set(gca,'YTick',0);
    set(gca,'XTick',0);
    set(gca,'CLim',[0 1])
    set(gca,'visible','off')

   % all = heatmap(flipud(compare_im),'Colormap',pink,'XData',comodulogram_column_headers,'YData',flipud(comodulogram_row_headers), ...
      %  'XLabel','Phase Frequency (Hz)','YLabel','Amplitude Frequency (Hz)','Title',chan_labels(ch),...
      %  'ColorLimits',[0 1]);
   % axs = struct(gca); %ignore warning that this should be avoided
   % cb = axs.Colorbar;
   % cb.TickLabels = {'None','','','','','','','','','','Sig'};
    fig.Name = strcat(chan_labels(ch),'_compare_sig_clusters');
    saveas(fig,strcat(chan_labels(ch),'_compare_sig_clusters','.png'));
    close(fig)
end


topoplot_of_comod_allm_yb('_compare_sig_clusters.png',strcat(save_dir, filesep,'Images',filesep,'Cluster Maps'),'')


fig = figure;
histogram(cell2mat(compare_cluster_dist)); title('Histogram of Simulated Compare Cluster Sizes'); 