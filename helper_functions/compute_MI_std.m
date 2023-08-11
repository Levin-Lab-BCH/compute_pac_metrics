
%% Standard deviations of ASD/RTT and TD
% For every channel, between every filtered low frequency signal and 
% high frequency signal, a t-test was used to compare the MIraw values 
% across all files and the ?(MIsurr) values across all files.
function [std_struct] = compute_MI_std(MI_raw,save_dir,groups)
cd([save_dir])
% located in pac_with_surr
load('PAC_analysis_variables.mat')
cd([save_dir filesep 'PAC analysis variables'])
std_struct.(groups{1,1}) = nan(size(MI_raw.(groups{1,1}),1),size(MI_raw.(groups{1,1}),2),size(MI_raw.(groups{1,1}),3));
std_struct.(groups{1,2}) = nan(size(MI_raw.(groups{1,2}),1),size(MI_raw.(groups{1,2}),2),size(MI_raw.(groups{1,2}),3));
for hf = 1:size(MI_raw.(groups{1,1}),1)
    
    for lf = 1:size(MI_raw.(groups{1,1}),2)
        
        for ch = 1:size(MI_raw.(groups{1,1}),3)

            std_struct.(groups{1,1})(hf, lf, ch) = nanstd(squeeze(MI_raw.(groups{1,1})(hf, lf, ch,:)));
            std_sturct.(groups{1,2})(hf, lf, ch) = nanstd(squeeze(MI_raw.(groups{1,2})(hf, lf, ch,:)));
            
            
        end

    end

end



