function row_joint = AJIVEJointSelectMJ(datablock, vecr, dataname, boundp, threp, nresample, iplot)
% function for selecting number of joint components of a set of datablocks
% use Wedin's perturbation bound
% Inputs:
%   datablock        - cells of data matrices {datablock 1, ..., datablock k}
%                    - Each data matrix is a d x n matrix that each row is
%   vecr             - a vector of selected ranks for each data matrix 
%   dataname         - cells of names for each datablock
%   boundp           - Additional interested percentiles of perturbation bounds; 
%                      default is [] and [50 5 95] percentiles are given for sure;
%   threp            - Percentile of perturbation bounds used for deciding
%                      the joint rank; defaule is 50 i.e. median.  
%   nresample        - number of re-samples in the AJIVE step 2 for
%                      estimating the perturbation bounds; default value is 1000;
%   iplot            - binary number to indicate whether to visualize the joint rank selection  
% Output:
%   row_joint        - estimate of joint row space 

%    Copyright (c) Meilei Jiang, Qing Feng, Jan Hannig & J. S. Marron 2017

k = length(datablock);

% step 1: low rank svd of each data block separately

V = cell(1,k);

union = zeros(sum(vecr), size(datablock{1}, 2)); % stack of row space basis vectors

for ib = 1:k
    [~,~,V{ib}]=svds(datablock{ib},vecr(ib));
    if ib == 1
        union(1:vecr(ib), :) = V{ib}';
    else
        union((sum(vecr(1:(ib-1))) + 1):sum(vecr(1:ib)), :) =  V{ib}';       
    end
end

% step 2 SVD on concatenated row basis matrix
boundp = unique([[50, 5, 95] boundp], 'stable');
if ~any(threp == boundp)
    disp(['Note: bound percentile ' num2str(threp) 'for rank selection is not computed']);
    disp(['Add ' num2str(threp) ' into the field boundp otherwise median is used']);
    threp = 50;
end

s_union = svd(union) ;
[~,~,v_union]=svd(union);
v_union=v_union';

% compute perturbation bound for each data block
% append customized percentile with default

bound = zeros(k, nresample);
for ib = 1:k
    % perturbation bound of SVD of each data block (Wedin)
    bound(ib,:) = SVDBoundWedin(datablock{ib}, vecr(ib), nresample); 
    fprintf('The SVD perturbation angle for %s: %.2f \n', dataname{ib}, prctile(bound(ib,:), 100 - threp) )
end;

% bound on squared singular value (s_union^2)
normbd = prctile(sum(cosd(bound).^2, 1), boundp); 

% use selected bound percentile for rank selection 
rjoint = sum(s_union.^2>normbd(boundp==threp));
if rjoint >= min(vecr)
    rjoint = min(vecr);
    disp('Note: maximal number of the joint components reached; consider reducing the number of selected signal components');      
end

row_joint = v_union(1:rjoint, :);
disp(['Proposed Joint rank:' num2str(rjoint)]);

% visulize the joint rank selection 
if iplot == 1
    figure;
    plot(s_union.^2, 'marker', 'o', 'linewidth', 1.5, 'color','blue');
    hold on;
    ylim([0 k]);
    XL = get(gca,'XLim');
    line(XL,[normbd(1), normbd(1)], 'color','red','linestyle','--',  'linewidth', 1.2);
    line(XL,[normbd(2), normbd(2)], 'color','black','linestyle','--',  'linewidth', 1);
    line(XL,[normbd(3), normbd(3)], 'color','black','linestyle','--',  'linewidth', 1);
    if length(normbd)>3
        for i=4:length(normbd)
            line(XL,[normbd(i), normbd(i)], 'color','green','linestyle','--',  'linewidth', 1);
        end
    end;
    xlabel('Component Index');
    ylabel('Squared Singular Values');
    title('Joint Component Selection', 'Fontsize',14);
    savestr = 'AJIVEStep2JointRankSelection';
    orient landscape;
    print('-dpsc', savestr);
end

snormbd = sqrt(normbd);
if iplot == 1
    figure;
    plot(s_union, 'marker', 'o', 'linewidth', 1.5, 'color','blue');
    hold on;
    ylim([0 sqrt(k)]);
    XL = get(gca,'XLim');
    line(XL,[snormbd(1), snormbd(1)], 'color','red','linestyle','--',  'linewidth', 1.2);
    line(XL,[snormbd(2), snormbd(2)], 'color','black','linestyle','--',  'linewidth', 1);
    line(XL,[snormbd(3), snormbd(3)], 'color','black','linestyle','--',  'linewidth', 1);
    if length(snormbd)>3
        for i=4:length(snormbd)
            line(XL,[snormbd(i), snormbd(i)], 'color','green','linestyle','--',  'linewidth', 1);
        end
    end;
    xlabel('Component Index');
    ylabel('Singular Value');
    title('Joint Component Selection - Singular Value', 'Fontsize',14);
    savestr = 'AJIVEStep2JointRankSelectionSigVal';
    orient landscape;
    print('-dpsc', savestr);
end


