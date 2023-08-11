function [dx,index] = check_dx(id,outcomes,varargin)
%Checks a reference outcomes table to see if id is present and what the
%diagnosis is 

%first deal with _pac_results.mat replacement
id = strrep(id,'_pac_results.mat','');
% outcome sheet should match beapp file name exactly - commenting this out if strcmp(id(1:2),'TD'); idxs = 1:5; elseif(strcmp(id(1:3),'RTT')) ;idxs=1:6;else ;idxs= 1:length(id); end %idxs = 1:8; end abcct
%id = id(idxs); 
 [~,index] = ismember(id,outcomes.Participant);
 if index == 0
     try
     [~,index] = ismember(strrep(id,'_','-'),outcomes.Participant);
     catch
         error(strcat('Could not find: ', id,'in outcomes participant column, please check outcomes sheet'))
     end
 end

 try 
dx = outcomes.Group_Num(index);
 catch ME
     disp(dx)
     error(strcat('Could not find: ', id,'in outcomes participant column, please check outcomes sheet'))
 end

