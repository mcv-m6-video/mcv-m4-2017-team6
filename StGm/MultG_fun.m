% function to compute the multiple gaussian method
% based on work of David Martin Berregon.
%
%Input :
% Threshold : Threshold to assign pixels to a Gaussian model 
% Rho : Adaptation constant
% K : Number of Gaussian in the mixture
% THFG : % of weights corresponding to foreground objects
% T1 : Frame in the beginning
% T2 : Endng Frame
% video : 'highway', 'fall' or 'traffic'. The folder corresponding to these
% video have to be in the same folder than this function.

%Output :
%Sequence : the mask you obtain.

% Copyright �  2013  Lesley-Ann DUFLOT
% 
%     This program is free software: you can redistribute it and/or modify
%     it under the terms of the GNU General Public License as published by
%     the Free Software Foundation, either version 3 of the License, or
%     (at your option) any later version.
% 
%     This program is distributed in the hope that it will be useful,
%     but WITHOUT ANY WARRANTY; without even the implied warranty of
%     MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
%     GNU General Public License for more details.
% 
%     You should have received a copy of the GNU General Public License
%     along with this program.  If not, see <http://www.gnu.org/licenses/>.


function [Sequence] = MultG_fun(Threshold,T1,T2,K,Rho,THFG,video)

VideoInFolder = ['input']; 
Fold = [video];

% Initialization

 if 0<T1 && T1<10
    begin='in00000';
    else if 9<T1 && T1<100
            begin='in0000';
        else if 99<T1 && T1<1000
                begin='in000';
            else begin='in00';
            end
        end
 end
    
    Frame(:,:,1)=rgb2gray(imread(['./' Fold '/' VideoInFolder '/'  begin num2str(T1) '.jpg'])); 
    Frame(:,:,2)=rgb2gray(imread(['./' Fold '/' VideoInFolder '/'  begin num2str(T1) '.jpg'])); 
    Frame(:,:,3)=rgb2gray(imread(['./' Fold '/' VideoInFolder '/'  begin num2str(T1) '.jpg'])); 
    
[H,W,C]=size(Frame);
Frame=double(reshape(Frame,H*W,C));
[ws,sigmas,mus] = StGm( Frame,K,8);   % Initialization process

Sequence=zeros(H,W,T2-T1);

for t=T1:T2
    
   if 0<t && t<10
        begin='in00000';
    else if 9<t && t<100
            begin='in0000';
        else if 99<t && t<1000
                begin='in000';
            else begin='in00';
            end
        end
   end
    Frame=zeros(H,W,C);
    Frame(:,:,1)=rgb2gray(imread(['./' Fold '/' VideoInFolder '/'  begin num2str(t) '.jpg'])); 
    Frame(:,:,2)=rgb2gray(imread(['./' Fold '/' VideoInFolder '/'  begin num2str(t) '.jpg'])); 
    Frame(:,:,3)=rgb2gray(imread(['./' Fold '/' VideoInFolder '/'  begin num2str(t) '.jpg'])); 
    
    Frame1D=double(reshape(Frame,H*W,3));    
    % Update of mixture model
    [ ws,sigmas,mus,menors ] = StGm(Frame1D,K,8,0.05,Rho,Threshold,sigmas, mus,ws);   
    % Foreground/Background detection
    [ FG ]      = ForeGround(ws,menors,sigmas,K,THFG );                                 
    Tmp         = [repmat(reshape(FG,H,W),[1 1 3])*255 reshape(Frame,H,W,3)];
    Output(:,:) = Tmp(:,1:W,1);
    
    ind=t-T1+1;
    Sequence(:,:,ind) = Output(:,:);
    
end  