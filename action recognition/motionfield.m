
function [ output_args ] = motionfield( videos)
%MOTIONFIELD Summary of this function goes here
%   Detailed explanation goes here

nFrames = videos.NumberOfFrame;
vidHeight = videos.Height;
vidWidth = videos.Width;

mov(1:nFrames) = ...
    struct('cdata', zeros(vidHeight, vidWidth, 3, 'uint8'),...
           'colormap', []);

for ii=1:nFrames
I = videos.read(ii);
%[H,V] = edgemap(I,level);
BW=edge(I(:,:,1),'sobel');

BW=uint8(BW*255);
 mov(ii).cdata = repmat(BW,[1,1,3]);
end
disp('ready to play movie...');
% Size a figure based on the video's width and height.
hf = figure;
set(hf, 'position', [150 150 vidWidth vidHeight])

% Play back the movie once at the video's frame rate.
movie(hf, mov, 1, videos.FrameRate);




end

