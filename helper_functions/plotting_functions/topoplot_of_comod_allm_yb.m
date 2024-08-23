function topoplot_of_comod_allm_yb(savestr,save_loc,group,colors)
close all
% cmin = 0.00000;
% cmax = .000025;
if isempty(group)
    group_lab = '';
else
    group_lab = strcat(group,'_');
end

cmin = -.001;
cmax = .001; % 1.1 8.9
ch_x = normalize([4,6,2.2,3.4,6.6,7.8,2.9,7.1,2.1,5,7.9,3.8,6.2,1.7,8.3,3.5,6.5,5],'range');

ch_x = normalize([4.3,5.7,2.7,3.9,6.1,7.3,3.4,6.6,2.6,5,7.4,4.3,5.7,2,8,3.9,6.1,5],'range');
ch_x([14 15])= ch_x([14 15]) + ([.05 -.05]);
ch_y = normalize([8.7,8.7,7.95,6.7,6.7,7.95,4.9,4.9,1.95,2.5,1.95,1,1,4.6,4.6,2.7,2.7,7.1],'range');
chan_pos = [ch_x',ch_y'];
new_chan_pos = (chan_pos + .2) / 1.2;

chan_strs = {'FP1', 'FP2', 'F7', 'F3', 'F4', 'F8', 'C3', 'C4', 'T5',  'Pz','T6','O1', 'O2', 'T3', 'T4', 'P3', 'P4', 'Fz'};
cd(save_loc)
h3 = figure(1); %create new figure
caxis([cmin, cmax]);
%h3.Color = 'gray';
h3.Units = 'inches';
h3.OuterPosition = [0.25 0.25 11 11];
%cb = colorbar("AxisLocation",'out')
set(gca,'visible','off')
hold on
chan = 1;
subplot_idx = 1;

%first gen colorbar
figure(1)
ax = axes();
ax.Color = [.94 .94 .94] ; %set box to same color as background 
c = colorbar(ax);
ax.Visible = 'off';

% varies by plot type
if strcmp(savestr,'_strength_contrast.png')
colormap(redblue(200));
caxis([-0.5 .5]);
elseif strcmp(savestr,'_clusters.png')
     c.TickLabels = {'None','','TD','','RTT','','Both'};
     %c.TickLabels = {'None','','ASD','','TD','','Both'};
     caxis([0 3])
     %cmap = [1 1 1; 0.4660 0.6740 0.1880; 0.8500 0.3250 0.0980; 0.9290 0.6940 0.1250];
     cmap = [1 1 1; colors{1,2}; colors{1,1}; colors{1,3}];
     colormap(ax,cmap)
elseif strcmp(savestr,'_clusters_tscore_thresh.png')
     c.TickLabels = {'None','','TD','','RTT','','Both'};
     %c.TickLabels = {'None','','ASD','','TD','','Both'};
     caxis([0 3])
    % cmap = [1 1 1; 0.4660 0.6740 0.1880; 0.8500 0.3250 0.0980; 0.9290 0.6940 0.1250];
     cmap = [1 1 1; colors{1,2}; colors{1,1}; colors{1,3}];
     colormap(ax,cmap)
elseif strcmp(savestr,'_compare_sig_clusters.png')
    colormap( ax , pink );
    set(gca,'CLim',[0 1])
    c.TickLabels = {'None','','','','','','','','','','Sig'};
elseif strcmp(savestr, '_strength_clusters_w_boundaries.png')
    set(gca,'ColorMap',pink)
    caxis([0, 2]);
elseif strcmp(savestr, '_cluster_phase_allfreqpairs.png')
    colormap pink
    set(gca,'CLim',[-pi pi])
end
% same by plot type
ax.Position = [    0.20    ax.Position(2:end)];
set(gca,'Visible','off')

% im = imread(strcat("colorbar",(savestr)));
% fig2 = figure(2);
% imshow(im)
% ax1 = gca; % get handle to axes of figure
% figure(1)
%         %s1 = subplot(5,5,subplot_idx); %create and get handle to the subplot axes
% fig1 = get(ax1,'children'); %get handle to all the children in the figures
% fig1.CData = flipud(fig1.CData);
% 
% ax = axes();
%          copyobj((flipud(fig1)),ax); %copy children to new parent axes i.e. the subplot axes
% ax.Position = [    0.20    ax.Position(2:end)];
% set(gca,'Visible','off')
while chan < size(chan_strs,2)+1
   
   % if ~(subplot_idx == 1 || subplot_idx == 3 || subplot_idx == 5 || subplot_idx==13 || subplot_idx ==21 ||subplot_idx==23 || subplot_idx==25)
      % annotation(h3,'textbox',[new_chan_pos(chan,1)-.1, new_chan_pos(chan,2)-.02 0 0],'String',chan_strs{1,chan},'FitBoxToText','on','EdgeColor','none','FontSize',12);
               %annotation('textbox',[new_chan_pos(chan,1), new_chan_pos(chan,2) 0 0],'String',chan_strs{1,chan},'FitBoxToText','on','EdgeColor','none','FontSize',12);

%       h1 = openfig(strcat('RTT_',chan_strs{1,chan},savestr),'reuse'); % open figure
        try
        im = imread(strcat(group_lab,chan_strs{1,chan},savestr));
        catch ME
            if strcmp(ME.message,['File',' "',strcat(group_lab,chan_strs{1,chan},savestr),'" does not exist.'])
                warning(ME.message)
                disp('skipping visualization')
                chan = chan+1;
                continue
            end
        end
        fig2 = figure(2);
        imshow(im) ;
        ax1 = gca; % get handle to axes of figure
        figure(1)
        %s1 = subplot(5,5,subplot_idx); %create and get handle to the subplot axes
        fig1 = get(ax1,'children'); %get handle to all the children in the figures
        ax = axes('Position', [new_chan_pos(chan,1)-.2, new_chan_pos(chan,2)-.17 .17 0.17],'Title',ax1.Title);
        fig1.CData = flipud(fig1.CData);
        copyobj((flipud(fig1)),ax); %copy children to new parent axes i.e. the subplot axes
        title(ax, chan_strs{1,chan},'FontSize',14)
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
   % subplot_idx = subplot_idx+1;
end
h3.Name = group;
if isempty(group); savestr(1)=''; %remove underscore for saving; 
end
set(gcf,'InvertHardCopy','Off');
save_label = [group,strrep(savestr,'.png','')];
%saveas(h3,strcat(save_loc,filesep,save_label,'_comod_topoplot','.png'))
exportgraphics(h3,strcat(save_loc,filesep,save_label,'_comod_topoplot_1','.png'),'Resolution',1000);

close(h3)