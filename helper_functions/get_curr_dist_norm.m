function [continue_flag,curr_dist,curr_MInorm] = get_curr_dist_norm(dx,order_dist,order, groups,amp_dist,MI_norm,id)
%dx of 0 is TD dx of 1 is ASD
continue_flag = 0;

% if ~contains(id{1},'TD') && ~contains(id{1},'RTT')
%     idxs = 1:length(id{1});
% order_dist_temp.(groups{1,dx}) = cellfun(@(x) ((strrep(x,'_pac_results.mat',''))),order_dist.(groups{1,dx}),'UniformOutput',false);
% order_temp.(groups{1,dx}) = cellfun(@(x) ((strrep(x,'_pac_results.mat',''))),order.(groups{1,dx}),'UniformOutput',false);
% else
%     if dx == 1; idxs = 1:6; 
%     elseif dx == 2; idxs = 1:5;  
%     end
% order_dist_temp.(groups{1,dx}) = cellfun(@(x) ((x(idxs))),order_dist.(groups{1,dx}),'UniformOutput',false);
% order_temp.(groups{1,dx}) = cellfun(@(x) ((x(idxs))),order.(groups{1,dx}),'UniformOutput',false);
% end

order_dist_temp.(groups{1,dx}) = cellfun(@(x) ((strrep(x,'_pac_results.mat',''))),order_dist.(groups{1,dx}),'UniformOutput',false);
order_temp.(groups{1,dx}) = cellfun(@(x) ((strrep(x,'_pac_results.mat',''))),order.(groups{1,dx}),'UniformOutput',false);

idx = find(strcmp(order_dist_temp.(groups{1,dx}),id{1}));
idx_MInorm = find(strcmp(order_temp.(groups{1,dx}),id{1}));
if isempty(idx) && isempty(idx_MInorm)
    continue_flag = 1; curr_dist = []; curr_MInorm = [];
    disp(strcat('Could not find: ',id,' in list of files, check outcome sheet'))
    return
end
%curr_dist = squeeze(eval([groups{dx},'_amp_dist(:,:,:,:,idx)']));
try
curr_dist = squeeze(amp_dist.(groups{1,dx})(:,:,:,:,idx_MInorm));
catch
    a = 5
end
%curr_MInorm = squeeze(eval([groups{dx},'_MInorm(:,:,:,:,idx_MInorm)']));
curr_MInorm = squeeze(MI_norm.(groups{1,dx})(:,:,:,idx_MInorm));
if isnan(curr_dist(1,1,1,1))
    continue_flag = 1;
    return
end