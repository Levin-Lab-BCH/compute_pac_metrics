function [] = plot_g1_minus_g2_pac_strength(MI_norm,groups,chan_labels,save_dir)
%cd('/Volumes/LaCie/Levin/PAC/Images/T1 PAC Strength Contrast')
cd([save_dir filesep 'Images' filesep 'PAC Strength Contrast'])

for ch = 1:size(MI_norm.(groups{1,2}),3)%check this

    im = nanmean(MI_norm.(groups{1,2})(:,:,ch,:),4) - nanmean(MI_norm.(groups{1,1})(:,:,ch,:),4);% - squeeze(nanmean(E_BL_MInorm(:,:,:,ch),1));
    %disp(max(max(im)));
    %disp(min(min(im)));
    all = figure;
    hAxes = gca;
    
    imagesc(hAxes,flipud(im));
    colormap( hAxes , redblue(200));
    set(gca,'YTick',0);
    set(gca,'XTick',0); %xlabel('Phase Frequency (Hz)');ylabel('Amplitude Frequency (Hz)')
    caxis([-0.5, 0.5]);
    all.Name = strcat(chan_labels(ch),'_strength_contrast');
   % title(strcat('PAC Strength Contrast (',groups{1,2},' Minus ',' ',groups{1,1},')'))
   % colorbar
    set(gca,'visible','off')
    saveas(all,strcat(chan_labels(ch),'_strength_contrast','.png'));
    close(all);
    %check if this is needed? YB determined no so commented in case want in
    %future
    %colorbar
    %saveas(all,strcat(chan_labels(ch),'colorbar_strength_contrast.png'));
end

%save colorbar
ax = axes;
ax.Color = [.94 .94 .94] ; %set box to same color as background 
c = colorbar(ax);
ax.Visible = 'off';
colormap(redblue(200));
caxis([-0.5 .5]);
%cb = colorbar;
saveas(ax,strcat('colorbar_strength_contrast.fig'));

topoplot_of_comod_allm_yb('_strength_contrast.png',strcat(save_dir, filesep,'Images',filesep,'PAC Strength Contrast'),'')
