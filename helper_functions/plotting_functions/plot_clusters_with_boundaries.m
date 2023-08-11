%author: yael braverman refactored from code in Fleming's pac analysis -
%may need to troubleshoot/generalize xticks
function [] = plot_clusters_with_boundaries(curr_sig_clusters,curr_minorm,comodulogram_row_headers,comodulogram_column_headers,comodulogram_third_dim_headers,chan_labels,save_dir,group)
cd([save_dir filesep 'Images' filesep 'PAC Strength']) % change to directory to save
% go through all channels

for ch = 1:length(comodulogram_third_dim_headers)

    x = find(flipud(curr_sig_clusters(:,:,ch)) == 1);
    [row,col] = ind2sub([size(curr_sig_clusters,1) size(curr_sig_clusters,2)],x);
    im = squeeze(nanmean(curr_minorm(:,:,ch,:),4));
    all = figure;
    imagesc(flipud(im));
    hold on
    map = squeeze(flipud(curr_sig_clusters(:,:,ch)));
    linewidth = 3;
    color = 'w';
    for k = 1:length(row)
        %disp("Col: ")
        %disp(col(k))
        %disp("Row: ")
        %disp(row(k))

    %     scatter([col(k)],[row(k)-0.3],'filled','>','k');

        % check all directions
        if col(k) < size(curr_sig_clusters,2) && map(row(k),col(k)+1) ~= 1
            plot([col(k)+0.5,col(k)+0.5],[row(k)+0.5,row(k)-0.5],...
            'LineWidth',linewidth,'Color',color);
            scatter([col(k)+0.42],[row(k)],'filled','<',color);
        end
        if col(k) > 1 && map(row(k),col(k)-1) ~= 1
            plot([col(k)-0.5,col(k)-0.5],[row(k)+0.5,row(k)-0.5],...
            'LineWidth',linewidth,'Color',color);
            scatter([col(k)-0.42],[row(k)],'filled','>',color);
        end

        if row(k) > 1 && map(row(k)-1,col(k)) ~= 1
            plot([col(k)-0.5,col(k)+0.5],[row(k)-0.5,row(k)-0.5],...
            'LineWidth',linewidth,'Color',color);
            scatter([col(k)],[row(k)-0.3],'filled','v',color);
        end

        if row(k) < size(curr_sig_clusters,1) && map(row(k)+1,col(k)) ~= 1
            plot([col(k)-0.5,col(k)+0.5],[row(k)+0.5,row(k)+0.5],...
            'LineWidth',linewidth,'Color',color);
            scatter([col(k)],[row(k)+0.3],'filled','^',color);
        end

        if col(k) == size(curr_sig_clusters,2)
            plot([col(k)+0.5,col(k)+0.5],[row(k)+0.5,row(k)-0.5],...
            'LineWidth',linewidth,'Color',color);
            scatter([col(k)+0.42],[row(k)],'filled','<',color);
        end

        if col(k) == 1
            plot([col(k)-0.5,col(k)-0.5],[row(k)+0.5,row(k)-0.5],...
            'LineWidth',linewidth,'Color',color);
            scatter([col(k)-0.42],[row(k)],'filled','>',color);
        end

        if row(k) == 1
            plot([col(k)-0.5,col(k)+0.5],[row(k)-0.5,row(k)-0.5],...
            'LineWidth',linewidth,'Color',color);
            scatter([col(k)],[row(k)-0.3],'filled','v',color);
        end

        if row(k) == size(curr_sig_clusters,1)
            plot([col(k)-0.5,col(k)+0.5],[row(k)+0.5,row(k)+0.5],...
            'LineWidth',linewidth,'Color',color);
            scatter([col(k)],[row(k)+0.3],'filled','^',color);
        end

        
         set(gca, 'YTick',1:length(comodulogram_row_headers),'YTickLabel', flipud(comodulogram_row_headers));
         set(gca, 'XTick',1:length(comodulogram_column_headers),'XTickLabel', comodulogram_column_headers);


        rectangle('Position',[col(k)-0.5, row(k)-0.5, 1, 1],'EdgeColor','w');
    end
            set(gca,'ColorMap',pink)

            % colorbar;
    set(gca,'YTick',0);
    set(gca,'XTick',0);
    caxis([0, 3]);
   % title(chan_labels(ch))
        % ylabel('Amplitude Frequency (Hz)')
        % xlabel('Phase Frequency (Hz)')
        set(gca,'visible','off')
    saveas(all,strcat(group,'_',chan_labels(ch),'_strength_clusters_w_boundaries','.png'));
    close(all)
end


    topoplot_of_comod_allm_yb('_strength_clusters_w_boundaries.png',strcat(save_dir, filesep,'Images',filesep,'PAC Strength'),group)

%colorbar
%saveas(all,'colorbar_strength_clusters.png');