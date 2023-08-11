function [] = MInorm_av_clusters(TD_sig_clusters,ASD_sig_clusters)
%orignal script notes not needed for anything, in archive folder for now
ASD_TD_overlap_clusters = TD_sig_clusters .* ASD_sig_clusters;

ASD_noTD_clusters = ((ASD_sig_clusters - TD_sig_clusters) == 1)*1;

% ASD MInorm in ASD only clusters
for r = 1:size(ASD_MInorm,4)
    ASD_MInorm_ASDonly_clusters(:,:,:,r) = squeeze(ASD_MInorm(:,:,:,r)) .* ASD_noTD_clusters;      
end

% ASD MInorm in ASD and TD overlap clusters
for r = 1:size(ASD_MInorm,4) 
    ASD_MInorm_overlap_clusters(:,:,:,r) = squeeze(ASD_MInorm(:,:,:,r)) .* ASD_TD_overlap_clusters;      
end

% TD MInorm in ASD and TD overlap clusters

for r = 1:size(TD_MInorm,4)
    
    TD_MInorm_overlap_clusters(:,:,:,r) = squeeze(TD_MInorm(:,:,:,r)) .* ASD_TD_overlap_clusters;
       
end
