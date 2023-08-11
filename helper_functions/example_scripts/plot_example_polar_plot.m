function [] = plot_example_polar_plot(alpha)
%%to do , save to folder if desired? 

%%

% thing to 
% x = [0.05, 0.08, 0.03, 0.055, 0.046, 0.033, 0.06, 0.063, 0.073, ...
%     0.04, 0.06, 0.07, 0.058, 0.086, 0.053, 0.043, 0.039, 0.067];

x = [0.05, 0.08, 0.07, 0.065, 0.076, 0.053, 0.03, 0.02, 0.018, ...
    0.02, 0.03, 0.035, 0.04, 0.03, 0.023, 0.033, 0.056, 0.067];


figure;
polarplot([alpha, alpha(1)],[x, x(1)],'.','MarkerSize',10);
rlim([0 .1]);
%print(gcf, '-dpng','-r300','/Users/flemingpeck/Dropbox (BCH)/BCH/Levin Lab/Lab Meetings/example_polarplot.png');

x_mean = circ_mean(alpha',x',1);
x_amp = circ_r(alpha',x',1);

figure;
polarplot(x_mean,x_amp,'.','MarkerSize',20);
%rlim([0 .1]);
%print(gcf, '-dpng','-r300','/Users/flemingpeck/Dropbox (BCH)/BCH/Levin Lab/Lab Meetings/example_averageangle.png');
