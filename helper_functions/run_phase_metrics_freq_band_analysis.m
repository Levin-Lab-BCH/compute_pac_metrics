function [outcomes] = run_phase_metrics_freq_band_analysis(lf_labels,hf_labels,freq_table,chan_labels,chans,outcomes,comodulogram_column_headers,comodulogram_row_headers,order_dist,order,groups,amp_dist,MI_norm,alpha)

all_lf_hfs = strcat(lf_labels,hf_labels);
lf_hfs = unique(all_lf_hfs);
overlap_label = {strcat(groups{1,1},'_only'),'overlap'};

%measures = {strcat('Strength_',overlap_label{1,1}),strcat('PhaseBias_',overlap_label{1,1}),strcat('PhaseBins_',overlap_label{1,1}) ...
         %   strcat('Strength_',overlap_label{1,2}),strcat('PhaseBias_',overlap_label{1,2}),strcat('PhaseBins_',overlap_label{1,2})};

measures = {strcat('Strength'),strcat('PhaseBias'),strcat('PhaseBins'),strcat('PhasBias_NoCircMean')}; 
outcomes = update_outcomes_table(outcomes,chan_labels,lf_hfs,measures);
% want PAC strength and phase bias
lfs =get_freq_idxs(freq_table,lf_labels,comodulogram_column_headers);
hfs = get_freq_idxs(freq_table,hf_labels,([comodulogram_row_headers']));
pos_alpha_idxs = find(rad2deg(alpha)>0);
for index = 1:size(outcomes,1)
    %disp(index)
   
    id = outcomes.Participant(index);
    dx = check_dx(id{1,1},outcomes);
    %disp(id);

    [continue_flag,curr_dist,curr_MInorm_temp] = get_curr_dist_norm(dx,order_dist, order, groups,amp_dist,MI_norm,id);

    if continue_flag
        continue
    end
    
    %g1_only_curr_MInorm = curr_MInorm_temp .* g1_nog2_clusters;
    %overlap_curr_MInorm = curr_MInorm_temp .* g1_g2_overlap_clusters;
    
  %  for overlap =  1:2
     %   if overlap == 1
     %   curr_MInorm = g1_only_curr_MInorm;
     %  % curr_dist = g1_only_curr_dist;
     %   elseif overlap == 2
     %  % curr_dist = overlap_curr_dist;
     %   curr_MInorm = overlap_curr_MInorm;
     %   end

        %%curr_MInorm(curr_MInorm == 0) = NaN; changes any non-sig clusters to NaN
        curr_MInorm = curr_MInorm_temp;
   % if continue_flag; continue ;end

    for c = 1:length(chans)
        chan = chans{c}; 
        %disp(chan_labels{c});
        
        for f = 1:length(lfs)
            lf = lfs{f};
            hf = hfs{f};
            
            %disp(lf_labels{f});
            %disp(hf_labels{f});
             phase_bins = nan([18,length(hf)*length(lf)*length(chan)]);
                phase_bias_ration = nan([1,length(hf)*length(lf)*length(chan)]);
            % identify the MInorm - curr_MInorm
            pac_strength = nanmean(curr_MInorm(hf,lf,chan),'all');
            
           % if nansum(pac_strength) == 0 no longer rel - was used when
           % masking for sig clusters
           %     continue
            %end
            phases = nan([1,length(hf)*length(lf)*length(chan)]);
            count = 1;
            for l = 1:length(lf)
                for h = 1:length(hf)
                    for ch = 1:length(chan)
                       % if nansum(squeeze(curr_dist(hf(h),lf(l),:,chan(ch)))) == 0 %checks if there were no sig clusters, skips this one
                       %     count = count + 1;
                       %     continue
                       % end
                        phases(count) = circ_mean(alpha',squeeze(curr_dist(hf(h),lf(l),:,chan(ch))));
                        phase_bins(:,count) = squeeze(curr_dist(hf(h),lf(l),:,chan(ch)));

                        phase_bias_ratio(count) = (sum(squeeze(curr_dist(hf(h),lf(l),pos_alpha_idxs,chan(ch))))/sum(squeeze(curr_dist(hf(h),lf(l),:,chan(ch)))))-0.5;

if isnan(phases(count)) && sum(isnan(phase_bins(:,count))) ~= 18
    a = 5;
end

                        count = count + 1;

                    end
                end
            end
            phase_bins = nanmean(phase_bins,2);
            phasebias = circ_mean((phases(~isnan(phases)))');
            ave_phasebias_ratio = nanmean(phase_bias_ratio,2);
            % save in output table
            %outcomes{index,(strcmp(outcomes.Properties.VariableNames,[chan_labels{c},'_',lf_labels{f},hf_labels{f},'_Strength_',overlap_label{overlap}]))} = pac_strength;
           % outcomes{index,(strcmp(outcomes.Properties.VariableNames,[chan_labels{c},'_',lf_labels{f},hf_labels{f},'_PhaseBias_',overlap_label{overlap}]))} = phasebias;
           % outcomes{index,(strcmp(outcomes.Properties.VariableNames,[chan_labels{c},'_',lf_labels{f},hf_labels{f},'_PhaseBins_',overlap_label{overlap}]))} = [phase_bins'];

             outcomes{index,(strcmp(outcomes.Properties.VariableNames,[chan_labels{c},'_',lf_labels{f},hf_labels{f},'_Strength']))} = pac_strength;
            outcomes{index,(strcmp(outcomes.Properties.VariableNames,[chan_labels{c},'_',lf_labels{f},hf_labels{f},'_PhaseBias']))} = phasebias;
            outcomes{index,(strcmp(outcomes.Properties.VariableNames,[chan_labels{c},'_',lf_labels{f},hf_labels{f},'_PhaseBins']))} = [phase_bins'];
            outcomes{index,(strcmp(outcomes.Properties.VariableNames,[chan_labels{c},'_',lf_labels{f},hf_labels{f},'_PhasBias_NoCircMean']))} = [ave_phasebias_ratio];

            clear pac_strength phases phasebias phase_bins
        end   
    end
   % end

% we want whole head, anterior, and posteror (excluding P3 and P4)
% electrodes

% average phase bias
% for each participant, compute circ mean for each included frequency pair
% (weight from amplitude distribution)
% then circ mean for all pairs of interest (weight 1)
% mean angle 

% average MInorm
% average within participant
end