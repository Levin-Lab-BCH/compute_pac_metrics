function [] = plot_sig_pac_clusters(sig_clusters,comodulogram_row_headers,comodulogram_column_headers,comodulogram_third_dim_headers,groups,save_dir,chan_labels,colors,hf_labels,lf_labels,freq_table,shade_by_freq_band)
% save plots of significance - show whether at each hf/lf point asd/rtt was sig, td was sig or both or none (1 or 0)
% change to directory to save
cd([save_dir filesep 'Images' filesep 'Cluster Maps'])
% go through all channels
g2_im = sig_clusters.(groups{1,2});
g1_im = sig_clusters.(groups{1,1});

both_im = ((g2_im == 1) & (g1_im == 1)) * 3;

only_g1 = ((g2_im ~= 1) & (g1_im == 1)) * 2; %only group 1 is orange

only_g2 = ((g2_im == 1) & (g1_im ~= 1)) * 1; % only group 2 is green

all = only_g2 + only_g1 + both_im;
%cmap = [1 1 1; TD_green_color, RTT_orange_color, both_yellow_color]
cmap = [1 1 1; 0.4660 0.6740 0.1880; 0.8500 0.3250 0.0980; 0.9290 0.6940 0.1250];
cmap = [1 1 1; colors{1,2}; colors{1,1}; colors{1,3}];
for ch = 1:length(comodulogram_third_dim_headers)
    fig = figure;
    imagesc((all(:,:,ch)));
    hAxes = gca;
    hAxes.YDir = 'normal';
    colormap(hAxes , cmap );

    if shade_by_freq_band
        boundary_x_ticks = [];
        median_x_labels = [];
        median_y_labels = [];
        boundary_y_ticks = [];
        % x_labels = repmat({' '},1,length(comodulogram_column_headers));
        for coupled_band = 1:length(lf_labels)
            [~,~,x_temp] =intersect(freq_table{:,lf_labels(coupled_band)}',comodulogram_column_headers);

            %determine middle
            x_labels{coupled_band} = lf_labels{coupled_band};
            median_x_labels = unique([median_x_labels;median(x_temp)]);
            boundary_x_ticks = unique([x_temp; boundary_x_ticks]);

            %repeat for high freq
            [~,~,y_temp] =intersect(freq_table{:,hf_labels(coupled_band)}',flipud(comodulogram_row_headers));
            y_labels{coupled_band} = hf_labels{coupled_band};
            median_y_labels = unique([median_y_labels;median(y_temp)]);
            boundary_y_ticks = unique([y_temp; boundary_y_ticks]);
        end
        y_labels = unique(y_labels); x_labels = unique(x_labels);
        %In plot only keep tick marks for boundaries
        xt=hAxes.XTick;                            % retrieve ticks
        [~,ia] =setdiff(comodulogram_column_headers,comodulogram_column_headers(boundary_x_ticks)); %ones to clear - non boundaries
        hAxes.XTick=xt(setdiff([1:length(comodulogram_column_headers)],ia));                   % clear all Tick marks except boundaries

        %repeat for y
        hAxes.YTick = linspace(hAxes.YLim(1),hAxes.YLim(2),length(comodulogram_row_headers)); %go in reverse order since we flipped the data to
        yt=fliplr(hAxes.YTick);                            % retrieve ticks
        row_headers_temp = flipud(comodulogram_row_headers); %put in ascending order
        [~,ia_y] =setdiff(row_headers_temp,row_headers_temp(boundary_y_ticks)); %ones to clear - non boundaries
        hAxes.YTick=sort(yt(setdiff(1:[length(comodulogram_row_headers)],ia_y)));                   % clear all Tick marks except boundaries


        hold on

        %Create axes to hold just labels and no ticks
        hAxes(2)=axes('position',hAxes.Position');   % second axes on top of first
        hAxes(2).XLim = hAxes(1).XLim;
        hAxes(2).YLim = hAxes(1).YLim;
        hAxes(2).XTick = xt; %match xticks to orginal axis
        hAxes(2).YTick = fliplr(yt); %match yticks to orignal axis
        hAxes(2).XTick=xt(median_x_labels);                   % set labels for just medians
        hAxes(2).YTick = sort(yt(round(median_y_labels))); %set labels for just medians

        hAxes(2).XTickLabel = x_labels;
        hAxes(2).YTickLabel = y_labels;


        hAxes(1).XTickLabel=[];                    % turn labels of first off
        hAxes(1).YTickLabel = [];
        hAxes(2).YTickLabelRotation = 60;
        hAxes(2).FontSize = 15;
        hAxes(2).TickLength=[0,0];                 % set ticks to zero length 2nd
        hAxes(1).TickLength = [.06 .06];
        axes(hAxes(1))
    else
        set(gca,'YTick',0);
        set(gca,'XTick',0);
    end
    caxis([0, 3]);
    set(gca,'CLim',[0 3])
    hold on
    set(gca,'Visible','on')
    set(gca,'Box','off')
    %set(gca,'visible','off')
    fig.Name = strcat(chan_labels(ch),'_clusters');
%      all_heatmap = heatmap(flipud(all(:,:,ch)), 'Colormap',cmap,'ColorLimits',[0 3],...
%      'XData',comodulogram_column_headers,'YData',flipud(comodulogram_row_headers), ...
%       'XLabel','Phase Frequency (Hz)','YLabel','Amplitude Frequency (Hz)');%'Title',chan_labels(ch));
% 
%  all_heatmap = heatmap(flipud(all(:,:,ch)), 'Colormap',cmap,'ColorLimits',[0 3]);
%  all_heatmap.XDisplayLabels = nan(size(all_heatmap.XDisplayData));
%  all_heatmap.YDisplayLabels=nan(size(all_heatmap.YDisplayData));
%  colorbar off
  
   %  axs = struct(gca); %ignore warning that this should be avoided
   %  cb = axs.Colorbar;
   %  cb.TickLabels = {'None','',groups{1,2},'',groups{1,1},'','Both'};
     saveas(fig,strcat(chan_labels(ch),'_clusters','.png'));
     %exportgraphics(fig,strcat(chan_labels(ch),'_clusters','.png'),'Resolution',1000);
     close(fig)
end
%save colorbar
fig = figure();

topoplot_of_comod_allm_yb('_clusters.png',strcat(save_dir, filesep,'Images',filesep,'Cluster Maps'),'',colors)

