function [cluster_dist,cluster_dist_t] = run_PAC_permutations(curr_MI_raw,curr_MI_surr,curr_flip_idxs,curr_same_idxs,overwrite_unique_combs)
% 1000 iterations

% initialize cluster distribution
cluster_dist = [];
cluster_dist_t = [];
count = 1;
%initialize random dist
flip_idxs = {};
same_idxs = {};
count = 0;

N = (size(curr_MI_surr,4)) ;%+ (size(curr_MI_raw,4));
%  for combs = 1:N/2
%     max_combs = max_combs + factorial(N)/(factorial(N/2)*factorial(N/2));
%  end

max_combs = factorial(N)/(factorial(floor(N/2))*(factorial(floor(N/2))));
all = cat(4,curr_MI_raw,curr_MI_surr);

while count < max_combs && count < 1000
%for round = 1:1000;%1000
    % randomly pick a number of participants to flip
    num_flip = randi([1 min(size(curr_MI_raw,4),size(curr_MI_surr,4))]);
  % %yb edited to only flip at max half the participants
   num_flip = randi([1 floor(min(size(curr_MI_raw,4)/2,size(curr_MI_surr,4)/2))]);
    disp('Flip #:')
    disp(num_flip);
%num_flip = N/2; % always have equal parts
    % randomly select participants to flip

   % idxs = linspace(1,length(MI_surr),length(MI_surr));
   idxs = linspace(1,min(size(curr_MI_raw,4),size(curr_MI_surr,4)),min(size(curr_MI_raw,4),size(curr_MI_surr,4))); 
   
  % idxs = linspace(1,size(all,4),size(all,4));
   idxs = randperm(length(idxs));
    %flip_idxs = idxs(1:num_flip);
    %same_idxs = idxs(num_flip+1:end);

    %yb adding for abcct verification
    if ~overwrite_unique_combs & any((cell2mat(cellfun(@(x) isequal(sort(idxs(1:num_flip)),sort(x)),flip_idxs,'UniformOutput',false))) & (cell2mat(cellfun(@(x) isequal(sort(idxs(num_flip+1:end)),sort(x)),same_idxs,'UniformOutput',false))))  % if these values have been flipped already, skip this round
        max_combs = max_combs + 1;
        continue
    else
            count  = count+1;
    flip_idxs{count} = idxs(1:num_flip);
    same_idxs{count} = idxs(num_flip+1:end);
    end
   % flip_idxs = curr_flip_idxs{round,:};
   % same_idxs = curr_same_idxs{round,:};

    sim_MI_raw = cat(4, curr_MI_raw(:,:,:,same_idxs{count}),curr_MI_surr(:,:,:,flip_idxs{count}));
   sim_MI_surr = cat(4, curr_MI_raw(:,:,:,flip_idxs{count}),curr_MI_surr(:,:,:,same_idxs{count}));

    %yb adding pulling from all 
   % sim_MI_raw = all(:,:,:,same_idxs{count});
   % sim_MI_surr = all(:,:,:,flip_idxs{count});


    % compute significant values
[curr_sig_points,~,curr_t_values,~] = create_PAC_clusters(sim_MI_surr,sim_MI_raw);
    % zero out pairs with overlapping frequencies
    
    % 11.15.20: no need to zero out
%     ASD_curr(1:6,:,:) = 0;
%     ASD_curr(7,3:end,:) = 0;
%     ASD_curr(8,5:end,:) = 0;
%     ASD_curr(9,7:end,:) = 0;
%     ASD_curr(10,9:end,:) = 0;
% 
%     TD_curr(1:6,:,:) = 0;
%     TD_curr(7,3:end,:) = 0;
%     TD_curr(8,5:end,:) = 0;
%     TD_curr(9,7:end,:) = 0;
%     TD_curr(10,9:end,:) = 0;

    % compute clusters
 [~,perm_cluster_dist,perm_cluster_dist_t]=characterize_PAC_clusters (curr_sig_points,curr_t_values,size(curr_MI_raw,1),size(curr_MI_raw,2),size(curr_MI_raw,3));
  
 %get rid of empty cells
 perm_cluster_dist = perm_cluster_dist(~cellfun('isempty',perm_cluster_dist));
 perm_cluster_dist_t = perm_cluster_dist_t(~cellfun('isempty',perm_cluster_dist_t));

       try
         cluster_dist = cat(2,cluster_dist,perm_cluster_dist);
         cluster_dist_t = cat(2,cluster_dist_t,perm_cluster_dist_t);
          if length(perm_cluster_dist(~cellfun('isempty',perm_cluster_dist))) == 0
              a = 5;
          end

        %cluster_dist = cat(2,cluster_dist,perm_cluster_dist);

       catch
           a=5
       end

%    disp(round);
disp(['count:'])
disp(count)
    clearvars num_flip  idxs ...
         sim_MI_raw ...
        sim_MI_surr curr_sig_points temp_cluster_dist perm_cluster_stats
end
a = 5;