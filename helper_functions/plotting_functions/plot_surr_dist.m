function [] = plot_surr_dist(MI_surr,comodulogram_row_headers,comodulogram_column_headers,groups)
count = 1; figure;
for hf = 1:length(comodulogram_row_headers)
    for lf = 1:length(comodulogram_column_headers)
        x = MI_surr.(groups{1,2})(hf,lf,1,:);
        subplot(length(comodulogram_row_headers),length(comodulogram_column_headers),count);
        histogram(x);
        count = count + 1;
    end
end