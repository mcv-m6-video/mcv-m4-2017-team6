%% Mean-Shift Video Tracking
% by Sylvain Bernhardt
% July 2008
%% Description
% This is a simple example of how to use
% the Mean-Shift video tracking algorithm
% implemented in 'MeanShift_Algorithm.m'.
% It imports the video 'Ball.avi' from
% the 'Videos' folder and tracks a selected
% feature in it.
% The resulting video sequence is played after
% tracking, but is also exported as a AVI file
% 'Movie_out.avi' in the 'Videos' folder.

clear all
close all

%% Import movie
% and time it with tic/toc
tic
[Length,height,width,Movie]=...
    Import_mov('trafficUAB/video/video.avi');
[Length2,height2,width2,Movie2]=...
    Import_mov('trafficUAB/video/segmentationUAB.avi');
toc

%% Play the movie
% % Put the figure in the center of the screen,
% % without axes and menu bar.
% scrsz = get(0,'ScreenSize');
% figure('Position',[scrsz(3)/2-width/2 scrsz(4)/2-height/2 width height],...
%     'MenuBar','none');
% axis off
% % Image position inside the figure
% set(gca,'Units','pixels','Position',[1 1 width height])
% % Play the movie
% movie(Movie);

%% Variables 
index_start = 78;
% Similarity Threshold
f_thresh = 0.16;
% Number max of iterations to converge
max_it = 5;
% Parzen window parameters
kernel_type = 'Gaussian';
radius = 1;

%% Target Selection in Reference Frame
[T,x0,y0,H,W] = Select_patch(Movie(index_start).cdata,0);
pause(0.2);

%% Run the Mean-Shift algorithm
% Calculation of the Parzen Kernel window
[k,gx,gy] = Parzen_window(H,W,radius,kernel_type,0);
% Conversion from RGB to Indexed colours
% to compute the colour probability functions (PDFs)
[I,map] = rgb2ind(Movie(index_start).cdata,65536);
Lmap = length(map)+1;
T = rgb2ind(T,map);
% Estimation of the target PDF
q = Density_estim(T,Lmap,k,H,W,0);
% Flag for target loss
loss = 0;
% Similarity evolution along tracking
f = zeros(1,(Length-1)*max_it);
% Sum of iterations along tracking and index of f
f_indx = 1;
% Draw the selected target in the first frame
Movie(index_start).cdata = Draw_target(x0,y0,W,H,...
    Movie(index_start).cdata,2);
%%%% TRACKING
WaitBar = waitbar(0,'Tracking in progress, be patient...');
% From 1st frame to last one
 mkdir('trafficUAB/gifs')
filename2 = 'trafficUAB/gifs/traffic2.gif'; % Specify the output file name
filename = 'trafficUAB/gifs/traffic1.gif'; % Specify the output file name
for t=78:Length-1
    % Next frame
    I2 = rgb2ind(Movie(t+1).cdata,map);
    % Apply the Mean-Shift algorithm to move (x,y)
    % to the target location in the next frame.
    [x,y,loss,f,f_indx] = MeanShift_Tracking(q,I2,Lmap,...
        height,width,f_thresh,max_it,x0,y0,H,W,k,gx,...
        gy,f,f_indx,loss);
    % Check for target loss. If true, end the tracking
    if loss == 1
        break;
    else
        % Drawing the target location in the next frame
        Movie(t+1).cdata = Draw_target(x,y,W,H,Movie(t+1).cdata,2);
         Movie2(t+1).cdata = Draw_target(x,y,W,H,Movie2(t+1).cdata,2);
         [imind2,cm2] = rgb2ind(Movie2(t+1).cdata ,256);
         [imind,cm] = rgb2ind(Movie(t+1).cdata ,256);
          if t == 78;
              imwrite(imind,cm,filename,'gif', 'Loopcount',inf);
              imwrite(imind2,cm2,filename2,'gif', 'Loopcount',inf);
          else
              imwrite(imind,cm,filename,'gif','WriteMode','append','DelayTime',0);
              imwrite(imind2,cm2,filename2,'gif','WriteMode','append','DelayTime',0);
          end
        
        % Next frame becomes current frame
        y0 = y;
        x0 = x;
        % Updating the waitbar
        waitbar(t/(Length-1));
    end
end
close(WaitBar);
%%%% End of TRACKING

%% Export/Show the processed movie
% Export the video sequence as an AVI file in the Videos folder
% WaitBar = waitbar(0,'Exporting the output AVI file, be patient...');
% movie2avi(Movie,'Videos\Movie_out','Quality',50);
% waitbar(1);
% close(WaitBar);

% Put a figure in the center of the screen,
% without menu bar and axes.
scrsz = get(0,'ScreenSize');
figure(1)
set(1,'Name','Movie Player','Position',...
    [scrsz(3)/2-width/2 scrsz(4)/2-height/2 width height],...
    'MenuBar','none');
axis off
% Image position inside the figure
set(gca,'Units','pixels','Position',[1 1 width height])
% Play the movie
movie(Movie);

%% End of File
%=============%