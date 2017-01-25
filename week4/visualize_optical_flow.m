function [ output_args ] = visualize_optical_flow(u, v, image)
    % Visualize optical flow with quiver
    downsample = 10; % Show 1 optical flow vectors every 'downsample' pixels
    for i=1:size(u, 1)
       for j=1:size(u,2)
           if(mod(j,downsample) ~= 0 || mod(i,downsample)~=0)
               u(i,j) = 0;
               v(i,j) = 0;
           end
       end
    end
    imshow(image);
    hold on
    quiver(1:size(u,2), 1:size(u,1), u, v,20);
    set(gca,'Ydir','reverse')
    hold off
end

