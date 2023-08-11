function [phase_prop_bins] = compute_phase_props(phase_prop_bins,amp_dist,groups, freq_table,lf_labels,hf_labels,comodulogram_row_headers,comodulogram_column_headers,region_table,curr_cluster,overlap);
if overlap ==2
    title_suffix = 'Overlap';
elseif overlap == 1
    title_suffix = [groups{1} '_Only_'];
end

for curr_group = 1:length(groups)
    % mask for significant clusters
   for region = 1:length(region_table.Properties.VariableNames) % loop over regions
    curr_chans = region_table{1,region_table.Properties.VariableNames(region)};
    x = curr_cluster(:,:,curr_chans);
    idxs = find(x ~= 0);
    if isempty(idxs) %if no clusters are signifcant for this region, don't generate plot
        phase_prop_bins.(strcat(title_suffix,region_table.Properties.VariableNames{region})).(groups{1,curr_group}) = NaN;
    else
            %first do across all frequencies (data driven approach)
       phase_prop_bins.(strcat(title_suffix,region_table.Properties.VariableNames{region})).(groups{1,curr_group}) = calc_phase_proportion_pac(amp_dist.(groups{1,curr_group})(:,:,:,curr_chans,:),idxs);
    end
   
    %then do it across specific frequency bands (hyp driven approach)
    cluster_freqband = ones(size(curr_cluster)); %makes sure that you look at all positions for freq band analysis not just signficant clusters
    for freq = 1:length(lf_labels)
        lfs = get_freq_idxs(freq_table,lf_labels(freq),comodulogram_column_headers);
        hfs = get_freq_idxs(freq_table,hf_labels(freq),[comodulogram_row_headers']);
        x = cluster_freqband(lfs{1,1},hfs{1,1},curr_chans);
        idxs = find(x ~= 0);
        if isempty(idxs) %if no clusters are signifcant for this region, don't generate plot
            phase_prop_bins.(strcat((region_table.Properties.VariableNames{region}),'_',lf_labels{freq},hf_labels{freq})).(groups{1,curr_group}) = NaN;
            continue
        end
        phase_prop_bins.(strcat((region_table.Properties.VariableNames{region}),'_',lf_labels{freq},hf_labels{freq})).(groups{1,curr_group}) = calc_phase_proportion_pac(amp_dist.(groups{1,curr_group})(lfs{1,1},hfs{1,1},:,curr_chans,:),idxs);
    end
   end
   %add whole and make variables by group
end