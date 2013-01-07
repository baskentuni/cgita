function [corrected_vertices ] = process_pmod_vertice(point_mat, handles)
             
if (point_mat(end,1)~=point_mat(1,1))||(point_mat(end,2)~=point_mat(1,2))
    point_mat(end+1,:) = point_mat(1,:);
end

xV = handles.Primary_image_obj.pmod_xV;
yV = handles.Primary_image_obj.pmod_yV;
zV = handles.Primary_image_obj.pmod_zV;

dx = (diff(xV(1:2)));
dy = (diff(yV(1:2)));
point_mat2(:,1) = (point_mat(:,1) - (xV(1)))/dx  ;
point_mat2(:,2) = (point_mat(:,2) - (yV(1)))/dy  ;
%point_mat2(:,1) = (point_mat(:,1) - (yV(1)))/dy  ;
%point_mat2(:,2) = (point_mat(:,2) - (xV(1)))/dx  ;

mask = roipoly_modified(zeros(length(xV), length(yV)), point_mat2(:,1)-0.5, point_mat2(:,2)-0.5);
%mask = roipoly_modified(zeros(length(yV), length(xV)), point_mat2(:,1)-0.5, point_mat2(:,2)-0.5);

B=bwboundaries(mask, 4, 'noholes');

if length(B) <1
    corrected_vertices = [];
else
    B = B{1};
    
    corrected_vertices = zeros(size(B,1),2);
    
    for i = 1:size(B,1)
        %corrected_vertices(i, :) = [xV(B(i,2)) yV(B(i,1))];
        corrected_vertices(i, :) = [xV(B(i,1)) yV(B(i,2))];
        %corrected_vertices(i, :) = [yV(B(i,2)) xV(B(i,1))];
    end
    corrected_vertices(:,3) = point_mat(1,3);
end

if size(corrected_vertices,1) == 2
    if sum(abs(corrected_vertices(1,:) - corrected_vertices(2,:))) == 0;
        corrected_vertices = corrected_vertices(1,:);
    end
end

%corrected_vertices = corrected_vertices(:,[2 1 3]);
return;

%mask = roipoly_modified(zeros(length(xV)-1, length(yV)-1), point_mat2(:,1)-0.5, point_mat2(:,2)-0.5);
