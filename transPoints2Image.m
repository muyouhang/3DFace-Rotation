function [depth_image,color_image] = transPoints2Image(data,color, size_x, size_y)
    
    x = data(:,1);
    y = data(:,2);
    z = data(:,3);
    r = color(:,1);
    g = color(:,2);
    b = color(:,3);

    max_x = max(x);
    min_x = min(x);
    max_y = max(y);
    min_y = min(y);
    min_z = min(z);
    max_z = max(z);
    range_x = max_x - min_x;
    range_y = max_y - min_y;
    color_image = zeros(size_x, size_y,3);
    depth_image = zeros(size_x, size_y);
    depth_image(:,:) = min_z;

    len = size(x, 1);
    min_z = 999;
    for i = 1:len
        X = floor((x(i)- min_x) / range_x * (size_x-1))+1;
        Y = floor((y(i)- min_y) / range_y * (size_y-1))+1;
        if z(i)>depth_image(X, Y)
            color_image(X,Y,:)=[r(i),g(i),b(i)];
        end
        depth_image(X, Y) = max(depth_image(X, Y), z(i));
        
        min_z = min(min_z, depth_image(X, Y));
    end
    range_z = max_z - min_z;
    depth_image = max(depth_image, min_z);
    depth_image = round((depth_image - min_z) / range_z * 255);
    depth_image = uint8(depth_image);
    color_image = uint8(color_image);
%     imshow(depth_image);
%     imshow(color_image);
%     imshow(ret);
end
