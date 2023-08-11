function [] =test_chan_order(flist)
% Author : Yael Braverman
% Tests whether all PAC files have channel in same order, throws warning
%message if not
FileName = flist;
Chans = NaN(length(flist),18);

chan_order = table(FileName, Chans);
chan_order.FileName = flist;

for f = 1:size(flist,1)
    
   % disp(f);
   % disp(flist{f});
    
    file = load(flist{f});
    
    chans = file.file_proc_info.beapp_indx{1,1};
    
    chan_order{f,2} = file.file_proc_info.beapp_indx{1,1};  
end
 unique_chans = unique(chan_order.Chans,'rows');
 if size(unique_chans)==size(chans)
   disp( 'Channels Consitent Across Files')
 else
    disp('Channels Incosistent, please inspect variable')
     open('chan_order')
end