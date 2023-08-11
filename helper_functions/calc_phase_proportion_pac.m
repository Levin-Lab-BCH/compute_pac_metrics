function [bins_region]= calc_phase_proportion_pac(curr_amp_dist,idxs)

bins_region = zeros([size(curr_amp_dist,5) size(curr_amp_dist,3)]);
channel_correction = zeros(size(curr_amp_dist,5),size(curr_amp_dist,4));

alpha = linspace((-17/18) * pi, (17/18) * pi,18);
[hf, lf, ch] = ind2sub([size(curr_amp_dist,1) size(curr_amp_dist,2) size(curr_amp_dist,4)],idxs); %gets row/col/third where cluster was sig (idx) - if freq band/hypothesis driven, idxs should be all positions

for p = 1:size(curr_amp_dist,5)
    for i = 1:size(hf,1)
               
                curr_bins = squeeze(curr_amp_dist(hf(i),lf(i),:,ch(i),p));
                                %check if channel is full of nans (e.g was a bad channel)
                if sum(isnan(curr_bins)) == size(curr_amp_dist,3)
                    channel_correction(p,ch) = channel_correction(p,ch)+1;
                    continue
                end
                bins_region(p,:) = bins_region(p,:) + (curr_bins == max(curr_bins)*1)';
    end
end
bins_region = bins_region ./ (size(hf,1)-sum(channel_correction>0,2)); %(size(curr_amp_dist,1)*size(curr_amp_dist,2)*(size(curr_amp_dist,4)-(sum(channel_correction>0,2))));
end