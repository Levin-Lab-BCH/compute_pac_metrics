function outcomes = update_outcomes_table(outcomes,regions,lf_hfs,measures)
count = 1;
% Build Fields in Region_LfHf_Measure format
for region = 1:length(regions)
    for lf_hf = 1:length(lf_hfs)
        for measure = 1:length(measures)
            fields{1,count} = strcat(regions{region},'_',lf_hfs{lf_hf},'_',measures{measure});
            count = count+1;
        end
    end
end

for field = 1:length(fields)
   % disp(field)
    if contains(fields{field},'PhaseBins')
            eval(['outcomes.','(fields{field})','=nan([size(outcomes,1),18]);'])
    else
        try
    eval(['outcomes.','(fields{field})','=nan([size(outcomes,1),1]);'])
        catch
            a = 5
        end
    end
end