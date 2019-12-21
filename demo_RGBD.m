%Step 1. 读取点云和彩色图像数据
no_ntp={};ni=1;
bnt_file='bs000_CAU_A22A25_0.bnt';
[X,Y,Z,RX,RY,FLAG] = read_bnt2D(bnt_file);
Z(~FLAG) = min(Z(FLAG));
%调整尺寸，保证彩色图像尺寸与点云一致
image = imread(strrep(bnt_file,'bnt','png'));
image = imrotate(imresize(image,[size(X,2),size(X,1)]),-90,'bilinear');
%读取鼻尖点，用以人脸球形裁剪
lm3=fopen(strrep(bnt_file,'bnt','lm3'),'r');
line=fgetl(lm3);
while ~strcmp(line,'Nose tip')&&ischar(line)
    line=fgetl(lm3);
end
if ischar(line)==0
    no_ntp{ni}=wrl_list{wrl_i};
    ni=ni+1;
    disp(wrl_list{wrl_i});
end
landmark=str2num(fgetl(lm3));
fclose(lm3);
%转换2D depth/color image 至N*3的点云形式
xo=landmark(1);
yo=landmark(2);
zo=landmark(3);
pc_depth=zeros(3,size(Z,1)*size(Z,2));
pc_i=1;
for x=1:size(Z,1)
    for y=1:size(Z,2)
        %pc_depth(:,pc_i)=[Y(x,y) X(x,y) Z(x,y) image(x,y,1) image(x,y,2) image(x,y,3)];
        pc_depth(:,pc_i)=[X(x,y) Y(x,y)  Z(x,y)];
        pc_i=pc_i+1;
    end
end
pc_color=zeros(3,size(image,1)*size(image,2));
pc_i=1;
for x=1:size(image,1)
    for y=1:size(image,2)
        pc_color(:,pc_i)=[image(x,y,1) image(x,y,2) image(x,y,3)];
        pc_i=pc_i+1;
    end
end
%球形裁剪：半径为r，以鼻尖点为中心
r=90; 
x_dis=(double(xo)-pc_depth(2,:)).*(double(xo)-pc_depth(2,:));
y_dis=(double(yo)-pc_depth(1,:)).*(double(yo)-pc_depth(1,:));
z_dis=(double(zo)-pc_depth(3,:)).*(double(zo)-pc_depth(3,:));

pc_depth(3,x_dis+y_dis+z_dis>r*r)=min(min(Z));   
vertex=pc_depth(1:3,pc_depth(3,:)>min(min(Z)));  
vertex_color=uint8(pc_color(1:3,pc_depth(3,:)>min(min(Z))));  
%Step 2. 旋转XYZ点云，并据此投影XYZ点云和RGB点云至X-Y平面
%旋转XYZ点云
vertex_rotate=(vertex'*RotationMatrix(0,30/180*pi,0))';
pcshow(vertex_rotate',vertex_color');

data=vertex_rotate';
color=vertex_color';
size_x=uint8((max(data(:,1))-min(data(:,1)))/1);
size_y=uint8((max(data(:,2))-min(data(:,2)))/1);
%投影
[depth_image,color_image]=transPoints2Image(data,color,size_x,size_y);
%后处理
depth_image=imrotate(depth_image,90,'bilinear');
color_image=imrotate(color_image,90,'bilinear');

depth_image=medfilt2(depth_image);
color_image(:,:,1)=medfilt2(color_image(:,:,1));
color_image(:,:,2)=medfilt2(color_image(:,:,2));
color_image(:,:,3)=medfilt2(color_image(:,:,3));
%展示
figure(1);
depth_image = imresize(depth_image,[size(depth_image,1)*2,size(depth_image,2)*2]);
imshow(depth_image);
figure(2);
color_image = imresize(color_image,[size(color_image,1)*2,size(color_image,2)*2]);
imshow(color_image);