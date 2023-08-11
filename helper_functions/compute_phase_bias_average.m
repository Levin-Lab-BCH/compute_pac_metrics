%% Phase bias - tasks the raw amp_dist and generates phase bias matrices for individuals and group averages
function [phase_bias_avg,phase_matrices] = compute_phase_bias_average(alpha,amp_dist,comodulogram_row_headers,comodulogram_column_headers,comodulogram_third_dim_headers,groups)
% make the posterior and anterior channel averages over all distributions
phase_matrices.(groups{1,1}) = zeros(length(comodulogram_row_headers),length(comodulogram_column_headers),length(comodulogram_third_dim_headers),size(amp_dist.(groups{1,1}),5));
phase_matrices.(groups{1,2}) = zeros(length(comodulogram_row_headers),length(comodulogram_column_headers),length(comodulogram_third_dim_headers),size(amp_dist.(groups{1,2}),5));
if size(amp_dist.(groups{1,1}),5)>=size(amp_dist.(groups{1,2}),5); iterator = size(amp_dist.(groups{1,1}),5); else; iterator = size(amp_dist.(groups{1,2}),5); end
for p = 1:iterator %iterate for group that has greater number of participants 
   % disp(p)

    for hf = 1:length(comodulogram_row_headers)

        for lf = 1:length(comodulogram_column_headers)

            for ch = 1:length(comodulogram_third_dim_headers)
                for curr_group = 1:2
                    if p > size(amp_dist.(groups{1,curr_group}),5)
                        continue
                    else
                      phase_matrices.(groups{1,curr_group})(hf, lf, ch, p) = circ_mean(alpha',squeeze(amp_dist.(groups{1,curr_group})(hf,lf,:,ch,p)));
                    end
                end
            end
        end
    end
end

%% average across all groups

phase_bias_avg.(groups{1,1})= zeros(length(comodulogram_row_headers),length(comodulogram_column_headers),length(comodulogram_third_dim_headers));
phase_bias_avg.(groups{1,2}) = zeros(length(comodulogram_row_headers),length(comodulogram_column_headers),length(comodulogram_third_dim_headers));
for hf = 1:length(comodulogram_row_headers)
    
    for lf = 1:length(comodulogram_column_headers)
        
        for ch = 1:length(comodulogram_third_dim_headers)
           curr_group_1 =  phase_matrices.(groups{1,1})(hf,lf,ch,:);
           curr_group_2 = phase_matrices.(groups{1,2})(hf,lf,ch,:);
           phase_bias_avg.(groups{1,1})(hf, lf, ch) = circ_mean(squeeze(curr_group_1(~isnan(curr_group_1))));
            phase_bias_avg.(groups{1,2})(hf, lf, ch) = circ_mean(squeeze(curr_group_2(~isnan(curr_group_2))));
            
        end
    end
end