function [r c] = mask2poly(mask)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
% edge_img = edge_dean(mask);
% vertice1 = zeros(sum(edge_img(:)), 2);
% counter = 0;
% for idx1 = 1:size(edge_img, 1)
%     for idx2 = 1:size(edge_img, 2)
%         if edge_img(idx1,idx2)
%             counter = counter + 1;
%             vertice1(counter, :) = [idx1 idx2];
%         end
%     end
% end
% 
% sorted = zeros(sum(edge_img(:)), 2);
% sorted(1, :) = vertice1(1, :);
% 
% ref_pos = vertice1(1, :);
% vertice1(1, :) = [NaN NaN];
% counter = 1;
% 
% while (counter < size(sorted, 1))
%     counter = counter+1;
%     [dummy idx] = min(sum(((vertice1 - repmat(ref_pos, [size(vertice1, 1) 1])).^2)'));
%     sorted(counter, :) = vertice1(idx, :);
%     ref_pos = vertice1(idx, :);
%     vertice1(idx, :) = [NaN NaN];
% end

B = bwboundaries(mask, 8, 'noholes'); sorted = B{1};
r = sorted(:,1);
c = sorted(:,2);

return;

