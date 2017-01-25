function [ u, v ] = LucasKanade( im1, im2 )
%LUCASKANADE Summary of this function goes here
% From: https://es.mathworks.com/matlabcentral/fileexchange/48744-lucas-kanade-tutorial-example-1/content/LucasKanadeExample1/html/LKExample1.html
%   Detailed explanation goes here
    % Implementing Lucas Kanade Method
    ww = 45;
    w = round(ww/2);

    % Lucas Kanade Here
    % for each point, calculate I_x, I_y, I_t
    Ix_m = conv2(double(im1),double([-1 1; -1 1]), 'valid'); % partial on x
    Iy_m = conv2(double(im1), double([-1 -1; 1 1]), 'valid'); % partial on y
    It_m = conv2(double(im1), double(ones(2)), 'valid') + conv2(double(im2), -double(ones(2)), 'valid'); % partial on t
    u = zeros(size(im1));
    v = zeros(size(im2));

    % within window ww * ww
    for i = w+1:size(Ix_m,1)-w
       for j = w+1:size(Ix_m,2)-w
          Ix = Ix_m(i-w:i+w, j-w:j+w);
          Iy = Iy_m(i-w:i+w, j-w:j+w);
          It = It_m(i-w:i+w, j-w:j+w);

          Ix = Ix(:);
          Iy = Iy(:);
          b = -It(:); % get b here

          A = [Ix Iy]; % get A here
          nu = pinv(A)*b; % get velocity here

          u(i,j)=nu(1);
          v(i,j)=nu(2);
       end;
    end;

end

