function [sig_points,pvalues,tvalues,df] = create_PAC_clusters(curr_MI_surr,curr_MI_raw)
% Author Yael Braverman (adapted/refactored from pac_analysis by Fleming)
% Call function to compute clusters:
%   Tests, For every channel, between every filtered low frequency signal and 
    % high frequency signal, a t-test was used to compare the MIraw values and
    % MI_surr across all files 
    %example: For a given channel, for participtnas 1-10, were the pairings between 8
    % and 20 hz significanlty different from a null distribution 
    % located in pac_with_surr

 %load('PAC_analysis_variables.mat') %shouldn't need to load this bc
 %variables already passed into function

sig_points = nan(size(curr_MI_surr,1),size(curr_MI_surr,2),size(curr_MI_surr,3));
pvalues = nan(size(curr_MI_surr,1),size(curr_MI_surr,2),size(curr_MI_surr,3));
tvalues = nan(size(curr_MI_surr,1),size(curr_MI_surr,2),size(curr_MI_surr,3));
df = nan(size(curr_MI_surr,1),size(curr_MI_surr,2),size(curr_MI_surr,3));

for hf = 1:size(curr_MI_surr,1)
        
    for lf = 1:size(curr_MI_surr,2)
        
        for ch = 1:size(curr_MI_surr,3)
            % Evaluate ASD
            x = squeeze(curr_MI_raw(hf, lf, ch,:));
            y = squeeze(curr_MI_surr(hf, lf, ch,:));

            [h,p,~,stats] = ttest2(x, y);
            % mark if significant
            sig_points(hf,lf,ch) = h;  
           tvalues(hf,lf,ch) = stats.tstat;    
          pvalues(hf,lf,ch) = p;    
        end

    end

end

% zero out pairs with overlapping frequencies
% 11.15.20: no need to do this

% TD_sig_points(1:6,:,:) = 0;
% TD_sig_points(7,3:end,:) = 0;
% TD_sig_points(8,5:end,:) = 0;
% TD_sig_points(9,7:end,:) = 0;
% TD_sig_points(10,9:end,:) = 0;
% 
% ASD_sig_points(1:6,:,:) = 0;
% ASD_sig_points(7,3:end,:) = 0;
% ASD_sig_points(8,5:end,:) = 0;
% ASD_sig_points(9,7:end,:) = 0;
% ASD_sig_points(10,9:end,:) = 0;


% zero out pairs with overlapping frequencies
% NOTE this wasn't commented for ASD vs td, check on htis
% compare_sig_points(1:6,:,:) = 0;
% 
% compare_sig_points(7,3:end,:) = 0;
% 
% compare_sig_points(8,5:end,:) = 0;
% 
% compare_sig_points(9,7:end,:) = 0;
% 
% compare_sig_points(10,9:end,:) = 0;