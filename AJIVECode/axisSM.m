function vax = axisSM(xmat,ymat,alpha) ; 
% AXISSM, sets graphics AXIS
%   Steve Marron's matlab function
%     For convenient (and useful) setting of graphics axes.
%     Basically uses range of input data, 
%     with proportion alpha added beyond each end.
%     Can either apply to current axes,
%     or be output as a vector for later (or multiple) use.
%     Will add and subtract alpha when all numbers are the same
% Inputs:
%   xmat   - xdata matrix, can be any shape
%   ymat   - (optional) ydata matrix, can be any shape,
%                including empty.
%                Can't set axes when this is not given,
%                or is empty
%   alpha  - (optional) proportion of data to add at each end
%                (default = 0.05)
% Output:
%   vax    - Vector of axis limits, as: [left,right,bottom,top]
%                (unless ymat not specified or empty,
%                    then only [left,right])
%                Changes axis properties of current graph,
%                when not specified.

%    Copyright (c) J. S. Marron 2002


%  Initialize
%
if nargin == 1 ;
  numlim = 1 ;
  ymat = [] ;
  alpha = 0.05 ;
elseif nargin == 2 ;
  numlim = 2 ;
  alpha = 0.05 ;
else ;
  numlim = 2 ;
end ;

if isempty(ymat) ;
  numlim = 1 ;
end ;



%  Do main calculations
%
left = min(min(xmat)) ;
right = max(max(xmat)) ;
range = right - left ;

if range > 0 ;
  left = left - alpha * range ;
  right = right + alpha * range ;
else ;
  left = left - alpha ;
  right = right + alpha ;
end ;  

vax = [left, right] ;


if numlim > 1 ;

  bottom = min(min(ymat)) ;
  top = max(max(ymat)) ;
  range = top - bottom ;

  if range > 0 ;
    bottom = bottom - alpha * range ;
    top = top + alpha * range ;
  else ;
    left = left - alpha ;
    right = right + alpha ;
  end ;  

  vax = [vax, bottom, top] ;
  
end ;



%  Reset current axis if needed
%
if nargout == 0 ;
  if numlim == 2 ;
    axis(vax) ;
  else ;
    disp('!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!') ;
    disp('!!!  Error from axisSM.m:       !!!') ;
    disp('!!!  Can''t reset axes without   !!!') ;
    disp('!!!  both sets of data input    !!!') ;
    disp('!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!') ;
  end ;
end ;



