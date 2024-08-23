function [clusters,cluster_stats,cluster_stats_t] =characterize_PAC_clusters (sig_points,t_values,row,column,third)
% Selected data points on the same channel adjacent to one another in 
% terms of low frequency or high frequency were grouped together into 
% clusters (MATLAB function bwlabel, connectivity = 4).
% Data points where the null hypothesis was rejected (p < .05, 2-sided 
% t-test) were selected.
clusters = nan(row,column,third);
cluster_stats = cell(third,1);
cluster_stats_t = cell(third,1);
% identify clusters for each channel
for ch = 1:third
    %check if whole channel has nans (b/c less than 2 participants didn't
    %have this channel as good) and then fill w zeros (bwlabel isn't
    %sensitive to nans and will set them all as 1s which we dont want
    if sum(sum(isnan(sig_points(:,:,ch)))) == (numel(sig_points(:,:,ch)))
    clusters(:,:,ch) = zeros(size(sig_points(:,:,ch)));
    else
        %replace other nans with zeros (edge case where t-test gives nan bc x ==y
        sig_points(isnan(sig_points))=0;
    [clusters(:,:,ch)] = bwlabel(sig_points(:,:,ch),4);
    end

    % for this channel count size of cluster
    board = clusters(:,:,ch);
    t_board = t_values(:,:,ch);
    correct_t = t_board;
    %adjust t_board values by taking out min sig value
    min_sig_t = min(abs(t_board(logical(sig_points(:,:,ch)))));

        if ~isempty(min_sig_t)
            correct_t(t_board>=0) = correct_t((t_board>=0))-min_sig_t;
            correct_t(t_board<0) = correct_t((t_board<0))+min_sig_t;
        end

    cluster_count = 0;
    for curr_cluster = 1:max(max(board))
        disp('cluster')
        disp(curr_cluster)
        
        cluster = (board == curr_cluster);

        %FP cluster size
        cluster_size = sum(sum(cluster));
        cluster_stats{ch,cluster_count+1} = cluster_size;

        %MM cluster size
        curr_cluster_t = NaN(size(correct_t));
        curr_cluster_t(logical(cluster)) = correct_t(cluster);
%         if sum(sum(curr_cluster_t(cluster)<0))>=1 && sum(sum(curr_cluster_t(cluster)>=0))>=1 %check that it has both neg and pos
%             neg_curr_t = curr_cluster_t<0;
%             neg_curr_cluster_t = bwlabel(neg_curr_t);
%             for neg_cluster = 1:max(max(neg_curr_cluster_t))
%                 cluster_size_neg_t = sum(sum(abs(curr_cluster_t(neg_curr_cluster_t == neg_cluster))));
%                 cluster_stats_t{ch,cluster_count+1} = cluster_size_neg_t;
%                 cluster_count = cluster_count + 1;
%             end
% 
%              pos_curr_t = curr_cluster_t>=0;
%             pos_curr_cluster_t = bwlabel(pos_curr_t);
% 
%             for pos_cluster = 1:max(max(pos_curr_cluster_t))
%                 cluster_size_pos_t = sum(sum(abs(curr_cluster_t(pos_curr_cluster_t == pos_cluster))));
%                 cluster_stats_t{ch,cluster_count+1} = cluster_size_pos_t;
%                 cluster_count = cluster_count + 1;
%             end
%         else

        cluster_size_t = sum(sum(abs(correct_t(cluster))));
        cluster_stats_t{ch,cluster_count+1} = cluster_size_t;
        cluster_count = cluster_count + 1;
        end

    end
    if max(max(board)) == 0 %deal with 0 edge case
        %cluster_stats{ch,cluster_count+1}= sum(sum(board));
        %cluster_size = 0;
    end
end