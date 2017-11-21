function HeatmapVisualQF(mdata, dataname)
% heat-map view of a data matrix 
% Input: data matrix
%        dataname: name of the data 
% Output: graphics only in the current axes

%    Copyright (c) Qing Feng Jan Hannig & J. S. Marron 2016

if nargin == 1;
    dataname = 'Data'; % set default value if no input
end

% set the color scheme 
b=0.99:-0.01:0;
bb=0:0.01:0.99;
blpha=[ones(length(b),1)*1 b' b'];bblpha=[bb' bb' ones(length(bb),1)*1 ];
map=[bblpha;[1 1 1]; blpha;];

%vax = axisSM(mdata, (mdata)') ;
limup= max(prctile(mdata(:), 85), prctile(-mdata(:), 85));
limd = min(prctile(mdata(:), 15), prctile(-mdata(:), 15));

figure;
imagesc(mdata);
ax = get(gca);
colormap(map);
caxis([limd, limup]);
%caxis([min(vax), max(vax)]);
set(gca, 'XTick', []) ; % remove X-axis
c=colorbar('southoutside', 'FontSize', 6); %add colorbar
title(dataname, 'FontSize', 14) ;  % Add title for subplot

