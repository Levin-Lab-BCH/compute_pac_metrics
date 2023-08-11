function [phase_stats] = compute_phase_prop_stats(phase_prop_bins,alpha,groups,save_dir)
curr_fields = fields(phase_prop_bins);
phase_stats.bin = ([1:18])';
phase_stats.alpha_deg = rad2deg(alpha)';
for i = 1:length(curr_fields)
   if any(isnan((phase_prop_bins.(curr_fields{i}).(groups{1,1})))) | any(isnan(phase_prop_bins.(curr_fields{i}).(groups{1,2})))
       temp = nan(1,18); continue; 
   end
    [~,temp] = (ttest2(phase_prop_bins.(curr_fields{i}).(groups{1,1}),phase_prop_bins.(curr_fields{i}).(groups{1,2})));
phase_stats.(curr_fields{i})=temp';
end
%need to change struct 2 table before saving? and check ttest can be
%vectorized
writetable(struct2table(phase_stats),strcat(save_dir,filesep,'Images',filesep,'Phase Bin Proportion',filesep,'phase_stats.xlsx'))
%writematrix(phase_stats,'/Volumes/LaCie/Levin/PAC/Images/Phase bin proportion/phase_stats.xlsx');