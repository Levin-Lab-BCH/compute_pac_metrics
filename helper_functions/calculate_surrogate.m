function [surr_comod]=calculate_surrogate(amp_dist,n_bins)
%Takes the amp_dist variable from beapp pac output file and computes a
%surrogate comodulogram based on shifting the amp_dist by a certain factor

  %surr_comod = nan(size(amp_dist{1},1),size(amp_dist{1},2),size(amp_dist{1},3),200);
 surr_comod = nan(size(amp_dist{1},1),size(amp_dist{1},2),size(amp_dist{1},4));
  %surr_comod = nan(size(amp_dist,1),size(amp_dist,2),size(amp_dist,4));

    amp_dist = amp_dist{:,:,:,:,:};

    % calculate surrogate comodulogram
    for chan = 1:size(amp_dist,4)
        if ~isnan(amp_dist(1,1,1,chan,1))
            for hf = 1:size(amp_dist,1)
                for lf =  1:size(amp_dist,2)
                    
                    % 9.10.20
                    surrs = nan(200,1);
                    
                    % surrogates start at 2
                    for surr = 2:size(amp_dist,5)
                        amp_dist(hf,lf,:,chan,surr) = amp_dist(hf,lf,:,chan,surr) ./ sum(amp_dist(hf,lf,:,chan,surr));
                        amplitude_dist = amp_dist(hf,lf,:,chan,surr);
                        amplitude_dist = squeeze(amplitude_dist)';
                        divergence_kl = sum(amplitude_dist .* log(amplitude_dist * n_bins));
                        % FP
                        %surr_comod(hf,lf,chan,surr-1) = divergence_kl / log(n_bins);
                        surrs(surr - 1) = divergence_kl / log(n_bins);
                    end
                    
                    surr_comod(hf, lf, chan) = nanmean(surrs);
                end
            end
        end

    end