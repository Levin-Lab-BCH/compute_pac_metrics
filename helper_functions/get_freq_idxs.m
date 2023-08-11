
function [freq_idxs] = get_freq_idxs(freq_table,freq_labels,comodulogram_headers)

for curr_freq = 1:length(freq_labels)

freq_idxs{curr_freq} = ...
find(comodulogram_headers >= freq_table.(freq_labels{curr_freq})(find(strcmp(freq_table.Properties.RowNames,'Minimum'))) ...
& comodulogram_headers <= freq_table.(freq_labels{curr_freq})(find(strcmp(freq_table.Properties.RowNames,'Maximum'))));

end