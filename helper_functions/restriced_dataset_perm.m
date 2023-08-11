%% ASD restricted dataset permutations
% YB moved this to separate script for now since not clear if needed - if
% will be used can refactor/clean up script
function [] = restriced_dataset_perm(ASD_MIraw,ASD_MIsurr,comodulogram_row_headers,comodulogram_column_headers,comodulogram_third_dim_headers)
% ASD_MIraw and ASD_MIsurr
% save indexes of not nan values
idxs = find(~isnan(ASD_MIraw(1,1,1,:)));

% randomly select 104 (TD n) ASD participants
rands = randperm(211);
rands = rands(1:104);
rand_idxs = idxs(rands);

r_ASD_MIraw = ASD_MIraw(:,:,:,rand_idxs);
r_ASD_MIsurr = ASD_MIsurr(:,:,:,rand_idxs);

% identify sig points
[r_ASD_sig_points,~,~,~]=create_PAC_clusters(r_ASD_MIsurr,r_ASD_MIraw);
% identify clusters
[r_ASD_clusters,r_ASD_cluster_stats]=characterize_PAC_clusters(r_ASD_sig_points,nan(length(comodulogram_row_headers),length(comodulogram_column_headers),length(comodulogram_third_dim_headers)));
% rand perm analysis
r_ASD_cluster_dist = run_PAC_perumatations(r_ASD_MIraw,r_ASD_MIsurr);
% threshold clusters
r_ASD_sig_clusters = generate_significant_clusters_PAC (r_ASD_cluster_dist,r_ASD_cluster_stats,r_ASD_clusters);
% compute 95th percentile of distribution

r_ASD_clusters_sorted = sort(r_ASD_cluster_dist(2:end));
r_ASD_cluster_threshold = r_ASD_clusters_sorted(floor(length(r_ASD_clusters_sorted)*.95));

% identify significant clusters
% arranged by cluster number x channel
r_ASD_sig_clusters_idx = cellfun(@(x)sum(x>r_ASD_cluster_threshold),r_ASD_cluster_stats);
% save clusters
% save rand_idxs
cd([savedir filesep 'PAC analysis variables'])
save('r5_ASD_clusters.mat','r_ASD_sig_clusters','rand_idxs','r_ASD_cluster_threshold',...
    'r_ASD_clusters_sorted');
%% plot the restricted ASD clusters
load('r1_ASD_clusters.mat')
r1_clusters = r_ASD_sig_clusters;

load('r2_ASD_clusters.mat')
r2_clusters = r_ASD_sig_clusters;

load('r3_ASD_clusters.mat')
r3_clusters = r_ASD_sig_clusters;

load('r4_ASD_clusters.mat')
r4_clusters = r_ASD_sig_clusters;

load('r5_ASD_clusters.mat')
r5_clusters = r_ASD_sig_clusters;
%%
%cd('/Volumes/LaCie/Levin/PAC/Images/Restricted ASD maps')
cd([save_dir filesep 'Images' filesep 'Restricted ASD Maps'])
for ch = 1:18
    %
    
%     td_im = TD_sig_clusters(:,:,ch);
%     asd_im = ASD_sig_clusters(:,:,ch);
% 
%     both_im = ((td_im == 1) & (asd_im == 1)) * 3;
%     
%     only_asd = ((td_im ~= 1) & (asd_im == 1)) * 2;
%     
%     only_td = ((td_im == 1) & (asd_im ~= 1)) * 1;
% 
%     all = only_td + only_asd + both_im;
% 
%     cmap = [1 1 1; 0.4660 0.6740 0.1880; 0.8500 0.3250 0.0980; 0.9290 0.6940 0.1250];
%     
%     fig = figure;
%     imagesc(flipud(all));
%     hAxes = gca;
%     colormap( hAxes , cmap );
%     set(gca,'YTick',0);
%     set(gca,'XTick',0);
%     caxis([0, 3]);
    
    
    %
    
    cmap = [1 1 1; 0.4660 0.6740 0.1880; 0.8500 0.3250 0.0980; 0.9290 0.6940 0.1250];

    im = r1_clusters(:,:,ch) * 2;

    fig = figure;
    imagesc(flipud(im));
    hAxes = gca;
    colormap( hAxes , cmap );
    set(gca,'YTick',0);
    set(gca,'XTick',0);
    caxis([0, 3]);
    
%     all = heatmap(flipud(im),'Colormap',pink,'XData',f.comodulogram_column_headers,'YData',flipud(f.comodulogram_row_headers), ...
%         'XLabel','Phase Frequency (Hz)','YLabel','Amplitude Frequency (Hz)','Title',chan_labels(ch),...
%         'ColorLimits',[0 1.5]);
    
    saveas(fig,strcat(chan_labels(ch),'_r1_clusters','.png'));
    
    %
    
    im = r2_clusters(:,:,ch)*2;

    fig = figure;
    imagesc(flipud(im));
    hAxes = gca;
    colormap( hAxes , cmap );
    set(gca,'YTick',0);
    set(gca,'XTick',0);
    caxis([0, 3]);
    
%     all = heatmap(flipud(im),'Colormap',pink,'XData',f.comodulogram_column_headers,'YData',flipud(f.comodulogram_row_headers), ...
%         'XLabel','Phase Frequency (Hz)','YLabel','Amplitude Frequency (Hz)','Title',chan_labels(ch),...
%         'ColorLimits',[0 1.5]);
%     
    saveas(fig,strcat(chan_labels(ch),'_r2_clusters','.png'));
    
    %
    
    im = r3_clusters(:,:,ch)*2;

%     figure;
    fig = figure;
    imagesc(flipud(im));
    hAxes = gca;
    colormap( hAxes , cmap );
    set(gca,'YTick',0);
    set(gca,'XTick',0);
    caxis([0, 3]);
    
%     all = heatmap(flipud(im),'Colormap',pink,'XData',f.comodulogram_column_headers,'YData',flipud(f.comodulogram_row_headers), ...
%         'XLabel','Phase Frequency (Hz)','YLabel','Amplitude Frequency (Hz)','Title',chan_labels(ch),...
%         'ColorLimits',[0 1.5]);
    
    saveas(fig,strcat(chan_labels(ch),'_r3_clusters','.png'));
    
    %
    
    im = r4_clusters(:,:,ch)*2;

   
    
    fig = figure;
    imagesc(flipud(im));
    hAxes = gca;
    colormap( hAxes , cmap );
    set(gca,'YTick',0);
    set(gca,'XTick',0);
    caxis([0, 3]);
    
%     all = heatmap(flipud(im),'Colormap',pink,'XData',f.comodulogram_column_headers,'YData',flipud(f.comodulogram_row_headers), ...
%         'XLabel','Phase Frequency (Hz)','YLabel','Amplitude Frequency (Hz)','Title',chan_labels(ch),...
%         'ColorLimits',[0 1.5]);
    
    saveas(fig,strcat(chan_labels(ch),'_r4_clusters','.png'));
    
    %
    
    im = r5_clusters(:,:,ch)*2;

    
    
    fig = figure;
    imagesc(flipud(im));
    hAxes = gca;
    colormap( hAxes , cmap );
    set(gca,'YTick',0);
    set(gca,'XTick',0);
    caxis([0, 3]);
    
%     all = heatmap(flipud(im),'Colormap',pink,'XData',f.comodulogram_column_headers,'YData',flipud(f.comodulogram_row_headers), ...
%         'XLabel','Phase Frequency (Hz)','YLabel','Amplitude Frequency (Hz)','Title',chan_labels(ch),...
%         'ColorLimits',[0 1.5]);
    
    saveas(fig,strcat(chan_labels(ch),'_r5_clusters','.png'));


end

