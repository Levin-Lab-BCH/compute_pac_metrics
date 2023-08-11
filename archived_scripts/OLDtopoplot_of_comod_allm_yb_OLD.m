function OLDtopoplot_of_comod_allm_yb_old(savestr,save_loc,group)
close all
% cmin = 0.00000;
% cmax = .000025;
if isempty(group)
    group_lab = '';
else
    group_lab = strcat(group,'_');
end

cmin = -.001;
cmax = .001;
ch_x = normalize([4,6,2.2,3.4,6.6,7.8,2.9,7.1,2.1,5,7.9,3.8,6.2,1.1,8.9,3.5,6.5,5],'range');
ch_y = normalize([8.7,8.7,7.95,6.7,6.7,7.95,4.9,4.9,1.95,2.5,1.95,1,1,4.6,4.6,2.7,2.7,7.1],'range');
chan_pos = [ch_x',ch_y'];
new_chan_pos = (chan_pos + .2) / 1.2;

chan_strs = {'FP1', 'FP2', 'F7', 'F3', 'F4', 'F8', 'C3', 'C4', 'T5',  'Pz','T6','O1', 'O2', 'T3', 'T4', 'P3', 'P4', 'Fz'};
cd(save_loc)
h3 = figure(1); %create new figure
caxis([cmin, cmax]);
%h3.Color = 'gray';
h3.Units = 'inches';
h3.OuterPosition = [0.25 0.25 10 10];
colorbar("AxisLocation",'out')
set(gca,'visible','off')
hold on
chan = 1;
subplot_idx = 1;
   %    annotation('textbox',[new_chan_pos-.1, new_chan_pos-.02 0 0],'String',chan_strs,'FitBoxToText','on','EdgeColor','none','FontSize',12);

while chan < size(chan_strs,2)+1
   % if ~(subplot_idx == 1 || subplot_idx == 3 || subplot_idx == 5 || subplot_idx==13 || subplot_idx ==21 ||subplot_idx==23 || subplot_idx==25)
      % annotation(h3,'textbox',[new_chan_pos(chan,1)-.1, new_chan_pos(chan,2)-.02 0 0],'String',chan_strs{1,chan},'FitBoxToText','on','EdgeColor','none','FontSize',12);
               %annotation('textbox',[new_chan_pos(chan,1), new_chan_pos(chan,2) 0 0],'String',chan_strs{1,chan},'FitBoxToText','on','EdgeColor','none','FontSize',12);

%       h1 = openfig(strcat('RTT_',chan_strs{1,chan},savestr),'reuse'); % open figure
        im = imread(strcat(group_lab,chan_strs{1,chan},savestr));
        fig2 = figure(2);
        imshow(im) ;
        ax1 = gca; % get handle to axes of figure
        figure(1)
        %s1 = subplot(5,5,subplot_idx); %create and get handle to the subplot axes
        fig1 = get(ax1,'children'); %get handle to all the children in the figures
        ax = axes('Position', [new_chan_pos(chan,1)-.5, new_chan_pos(chan,2)-.17 .17 0.17],'Title',ax1.Title);
        fig1.CData = flipud(fig1.CData);
        copyobj((flipud(fig1)),ax); %copy children to new parent axes i.e. the subplot axes
        title(ax, chan_strs{1,chan})
        ax.Title.Position(2) =  ax.Title.Position(2)-150;
       % caxis([cmin cmax])
        if chan == 1
           % set(h1,'visible','off')
            set(gca,'visible','off')
        else
            set(gca,'visible','off')
        end
        close(fig2)
                chan = chan+1;
        pause(.05)
  %  end
    subplot_idx = subplot_idx+1;
end
h3.Name = group;
saveas(h3,strcat(save_loc,filesep,group,'_comod_topoplot','.png'))
close(h3)