function [] = prepare_pac_directories(save_dir,toggle_steps)
disp('Checking existing directories')
%hardcoded set of folders


pac_output_folders = {['Images' filesep 'Phase Bin Proportion'],['Images',filesep,'Cluster Maps'],['Images',filesep,'PAC Strength'],['Images',filesep,'PAC Strength Contrast'], ...
  'PAC analysis variables',['Images',filesep,'Extra',filesep 'STD maps'],['Images',filesep,'Extra',filesep ,'Phase bias maps'],['Images' filesep 'Extra' filesep 'Restricted ASD maps'], ['Images' filesep 'Extra' filesep 'Cluster Phase Maps'],['Images' filesep 'Extra' filesep 'Phase Bias Cluster Average'] ,...
  ['Images' filesep 'Extra' filesep 'Phase Bin Freqband Plots'], ['Images' filesep 'Freqband Polar Plots'] ,['Images' filesep 'Freqband Strength Plots'], ['Images' filesep 'Freqband Phase Bias Ratio Plots'], ['Images' filesep 'Cluster Phase Maps']};

for folder = 1:length(pac_output_folders)
    curr_folder = fullfile(save_dir,pac_output_folders{folder});
if ~isdir(curr_folder)
    mkdir(curr_folder)
    disp(['Created Directory: ',curr_folder])
end
    
end
disp('Done checking directories')

