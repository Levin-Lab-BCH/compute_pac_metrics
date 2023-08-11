function [max_phase_bin,max_phase_value] = compute_max_phase_bin_and_val(amp_dist,groups)
max_phase_bin.(groups{1,1}) = nan(size(amp_dist.(groups{1,1}),1),size(amp_dist.(groups{1,1}),2),size(amp_dist.(groups{1,1}),3));
max_phase_bin.(groups{1,2}) = nan(size(amp_dist.(groups{1,2}),1),size(amp_dist.(groups{1,2}),2),size(amp_dist.(groups{1,2}),3));

max_phase_value.(groups{1,1}) = nan(size(amp_dist.(groups{1,1}),1),size(amp_dist.(groups{1,1}),2),size(amp_dist.(groups{1,1}),3));
max_phase_value.(groups{1,2}) = nan(size(amp_dist.(groups{1,2}),1),size(amp_dist.(groups{1,2}),2),size(amp_dist.(groups{1,2}),3));
for hf = 1:(size(amp_dist.(groups{1,1}),1))
    
    for lf = 1:(size(amp_dist.(groups{1,1}),2))
        
        for ch = 1:size(amp_dist.(groups{1,1}),3)
            
            % bins x participants)
            for group = 1:length(groups)

           %eval(['bins =
           %squeeze(',groups{group},'_amp_dist(hf,lf,:,ch,:));']) can
           %delete after testing looks ok
            bins = squeeze(amp_dist.(groups{group})(hf,lf,:,ch,:));
            [m, idx] = max(mean(bins,2));
            max_phase_bin.(groups{1,group})(hf,lf,ch) = idx; 
            max_phase_value.(groups{1,group})(hf,lf,ch) = m; 
            end
        end
    end
end