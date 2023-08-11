function [proportions_out,bin_count_out,total_dist] = calculate_phase_bias_proportion_pac(channels,sub_amp_dist,idxs,varargin)
% Inputs:
% channels --> Indices of channels/electrodes for your net 
% sub_amp_dist --> 
% idxs --> map of indexes where amp_dist reached a given significance threshold, the code will only count the phase biases for these positions
% of the amp_dist
%check whether total dist is redundant

%Deal with Inputs
if nargin==4
    bins_idx = varargin{1};
else
    bins_idx = [1:size(sub_amp_dist,3)];
end

alpha = linspace((-17/18) * pi, (17/18) * pi,18);
[y1, y2, y3] = ind2sub([size(sub_amp_dist,1) size(sub_amp_dist,2) length(channels)],idxs); %gets row/col/third where cluster was sig (idx)

% ASD
curr = sub_amp_dist(:,:,:,channels,:);
count = 0;
total_dist = 0;
proportions = zeros(size(curr,5),size(alpha,2));
prop_count = zeros(1,size(curr,5));
bin_count_correction = zeros(size(curr,5),1);
for p = 1:size(curr,5)
    if isnan(curr(1,1,1,1,p))
        continue;
    end
    bin_count = 0;
    count = count + 1;
    
    for i = 1:size(y1,1) %give this var a meaningful name
        
        % literally go through and find the max at each point for each
        % participant
        bins = squeeze(curr(y1(i),y2(i),bins_idx,y3(i),p)); %tells you for every bin or selected bin, what the amp_dist was
        
        %check for bad channels 
        if sum(isnan(bins)) == size(curr,3)
            bin_count_correction(p,1) = bin_count_correction(p,1) +1;
            continue
        end

        [~, idx] = max(mean(bins,2)); % finds across those bins, which value was the max, and at what bin (degree) it occurred
        proportions(p,idx) = proportions(p,idx) + 1; %store a count for that specific bin/degree
        prop_count(p) = prop_count(p) + 1;
        bin_count = bin_count + bins;

    end
     %get participant ave - may be redundant check later
        %check if all clusters came from bad channel - if so fix so it
        %doesn't create a nan to add to total dist
        if bin_count_correction(p,1) == length(y1); bin_count_correction(p,1) = bin_count_correction(p,1)+1; end
        total_dist = total_dist + (bin_count/(length(y1)-bin_count_correction(p,1)));
end
if size(curr,5)==1; bin_count_out = bin_count/(length(y1)-bin_count_correction); else bin_count_out = [];end %only designed for 1 participant at a time
proportions_out = mean(proportions ./ prop_count'); %shows for every bin, how many times the max value occured for said participant and freq/channel pair
total_dist = total_dist/size(sub_amp_dist,5);     % average phase bin magnitude over all participants for the cluster
