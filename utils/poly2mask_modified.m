function BW3 = poly2mask_modified(x,y,M,N)
%POLY2MASK Convert region-of-interest polygon to mask.
%   BW = POLY2MASK(X,Y,M,N) computes a binary region-of-interest mask,
%   BW, from a region-of-interest polygon, represented by the vectors X
%   and Y.  The size of BW is M-by-N.  Pixels in BW that are inside
%   the polygon (X,Y) are 1; pixels outside the polygon are 0.  The class
%   of BW is logical.
%
%   POLY2MASK closes the polygon automatically if it isn't already
%   closed.
%
%   Example
%   -------
%       x = [63 186 54 190 63];
%       y = [60 60 209 204 60];
%       bw = poly2mask(x,y,256,256);
%       imshow(bw)
%       hold on
%       plot(x,y,'b','LineWidth',2)
%       hold off
%
%   Or using random points:
%
%       x = 256*rand(1,4);
%       y = 256*rand(1,4);
%       x(end+1) = x(1);
%       y(end+1) = y(1);
%       bw = poly2mask(x,y,256,256);
%       imshow(bw)
%       hold on
%       plot(x,y,'b','LineWidth',2)
%       hold off
%
%   See also ROIPOLY.

%   Copyright 1993-2005 The MathWorks, Inc.
%   $Revision: 1.1.6.6 $  $Date: 2006/06/15 20:09:17 $

iptchecknargin(4,4,nargin,mfilename);
iptcheckinput(x,{'double'},{'real','vector','finite'},mfilename,'X',1);
iptcheckinput(y,{'double'},{'real','vector','finite'},mfilename,'Y',2);
iptcheckinput(M,{'double'},{'real','integer','nonnegative'},mfilename,'M',3);
iptcheckinput(N,{'double'},{'real','integer','nonnegative'},mfilename,'N',4);
if length(x) ~= length(y)
    error('Images:poly2mask:vectorSizeMismatch','%s',...
          'Function POLY2MASK expected its first two inputs, X and Y, to be vectors with the same length.');
end

if isempty(x)
    BW = false(M,N);
    return;
end

if (x(end) ~= x(1)) || (y(end) ~= y(1))
    x(end+1) = x(1);
    y(end+1) = y(1);
end
scale = 10;%31
[xe,ye] = poly2edgelist_modified(x,y,scale);
BW = edgelist2mask_modified(M*scale+1,N*scale+1,xe,ye,1);
BW = double(BW);
BW(end+1,:) = 0;
BW(:,end+1) = 0;
BW2 = zeros(M, N);
temp1 = ones(1,scale)/scale^2;
temp2 = ones(scale,1);
for idx1 = 1:M-1
    for idx2 = 1:N-1
        BW2(idx1+1,idx2+1) = temp1*BW((idx1-1)*scale+1+[1:scale],(idx2-1)*scale+1+[1:scale])  * temp2;
    end
end
total_n = round(sum(BW2(:)));
BW3 = zeros(size(BW2));
if total_n<1
    return;
end
vox_list = BW2(find(BW2>0));
sorted_list = sort(vox_list, 1,'descend');
vox_thresh = sorted_list(total_n);

BW3(find(BW2>=vox_thresh)) = 1;
return;