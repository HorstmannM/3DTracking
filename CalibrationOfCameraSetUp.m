%CALIBRATION OF CAMERA SET UP
%clear everything before start
clear rpi1                  %just clear raspi red
clear rpi2                  %just clear raspi green
clear                       %clear all
clear cam1                  %just clear raspi-cam red
clear cam2                  %just clear raspi-cam green
clc                         %clear command window

%set up connection
rpi1 = raspi('192.168.178.22', 'pi', 'raspberry');
rpi2 = raspi('192.168.178.23', 'pi', 'raspberry');

%add new raspi
% targetupdater

cam1 = cameraboard(rpi1, 'Resolution', '1920x1080', 'FrameRate', 30, 'Rotation', 180, 'Brightness', 50, 'Contrast', 50,  'ExposureMode', 'backlight', 'Sharpness', 100);
cam2 = cameraboard(rpi2, 'Resolution', '1920x1080', 'FrameRate', 30, 'Rotation', 180, 'Brightness', 50, 'Contrast', 50,  'ExposureMode', 'backlight', 'Sharpness', 100);

%____________________________________________________________________________________
%checking cameras
%Livestream for checking cam red
for i = 1:10
    img1 = snapshot(cam1);
    imagesc(img1);
    drawnow; 
end
axis equal
 %Livestream for checking cam green
 figure;
for i = 1:10
    img2 = snapshot(cam2);
    imagesc(img2);
 drawnow;  
end
axis equal

% ------------------------------------------------------------------------------------
% CALIBRATION
% taking snapshots for the calibration (~80 per camera), including images
% of the checkerboard on the outside of the aquaria (for the calibration of
% the origin)
figure;
img_CAM1=snapshot(cam1);
imagesc(img_CAM1);
timecode1=datetime('now', 'Format', 'd_MM_y_HH_mm_ss');      %capture the time at start of recording
Filename_cal1=sprintf('calib1_%s.png', timecode1);
imwrite(img_CAM1,Filename_cal1);   %grab image for calibration
axis equal

img_CAM2=snapshot(cam2);
imagesc(img_CAM2);
timecode1=datetime('now', 'Format', 'd_MM_y_HH_mm_ss');      %capture the time at start of recording
Filename_cal2=sprintf('calib2_%s.png', timecode1);
imwrite(img_CAM2, Filename_cal2);   %grab image for calibration
axis equal

%open the camera calibrator app, load the images and calibrate. We had good
%experiences with Mean Error (Px) of about 0.43 as maximum and overall mean
%error rates of 0.33 px


% Prior calibrations for Pi red

%load the camera parameters exported from the 'Camera Calibrator App' for
%both cameras. In the following they are called 'cameraParams_red' and
%'cameraParams_green'

% define the camera position (from the 3D plot of the calibration)
figure; showExtrinsics(cameraParams_200918_red,'cameraCentric');

% attention, coordinates may be swappped! (read numbers from the data cursor
% dialogue and fill them in here, adjusted for the camera position)
cam1x=-82.26;
cam1y=-323.7;
cam1z=24.31;

% import image with chess board in front from Camera red into Matlab to calibrate lengths etc.
J1=imread('calib1_20_09_2018_10_09_46.png'); 
% undistort image according to camera parameters
[J1,~] = undistortImage(J1,cameraParams_200918_red);
% plot the undistorted image
figure;
image(J1)
axis equal
xlabel('X')
ylabel('Y')

% define the origin (just once for a steadily positioned camera)

message = sprintf('Please click on the origin (the lower right checkerboard-crossing) in this picture of Camera Pi_red. Press "Start" to begin, "Cancel" in any other case.');
questdlg(message, 'Define Origin Camera 1', 'Start', 'Cancel', 'Start');

[originX1,originY1]=ginput(1);

% capture two x-y-coordinates from the image with the help of crosshairs to
% determine the scaling factor

message = sprintf('Define a length of 1.01 cm by two clicks in the neighbouring edges of a checkerboard square in the picture of Camera Pi_red. Press "Start" to begin, "Cancel" in any other case.');
questdlg(message, 'Define Length (1.01 cm/Checkerboard-Square) Camera 1', 'Start', 'Cancel', 'Start');

[X1,Y1]=ginput(2);

% calculate the length of a mm in pixels
d_1 = ((X1(1) - X1(2)) ^ 2 + (Y1(1) - Y1(2)) ^ 2) ^ 0.5;
d_mm_1=d_1/10.1;



% Prior calibrations for Pi green

% define the camera position (from the 3D plot of the calibration)
figure; showExtrinsics(cameraParams_200918_green,'cameraCentric');

% attention, coordinates may be swappped!
cam2x=309.6;
cam2y=77.32;
cam2z=24.78;

% import image from Camera green into Matlab to calibrate lengths etc.
J2=imread('calib2_20_09_2018_10_11_50.png'); 
% undistort image according to camera parameters
[J2,newOrigin] = undistortImage(J2,cameraParams_200918_green);
% plot the undistorted image
figure;
image(J2)
axis equal
xlabel('X')
ylabel('Y')

% define the origin (just once for a steadily positioned camera)
message = sprintf('Please click on the origin (the lower left checkerboard-crossing) in this picture of Camera Pi_green. Press "Start" to begin, "Cancel" in any other case.');
questdlg(message, 'Define Origin Camera 2', 'Start', 'Cancel', 'Start');

[originX2,originY2]=ginput(1);

% capture two x-y-coordinates from the image with the help of crosshairs to
% determine the scaling factor
message = sprintf('Define a length of 1.01 cm by two clicks in the neighbouring edges of a checkerboard square in the picture of Camera Pi_green. Press "Start" to begin, "Cancel" in any other case.');
questdlg(message, 'Define Length (1.01 cm/Checkerboard-Square) Camera 2', 'Start', 'Cancel', 'Start');

[X2,Y2]=ginput(2);

% calculate the length of a mm in pixels
d_2 = ((X2(1) - X2(2)) ^ 2 + (Y2(1) - Y2(2)) ^ 2) ^ 0.5;
d_mm_2=d_2/10.1;


%correct the clicked origins for the real origin on the outer lower right corner of the aquarium, seen from Pi_red
originX1=originX1+4*d_mm_1;
originY1=originY1+19.5*d_mm_1;
originX2=originX2-4*d_mm_2;
originY2=originY2+29.5*d_mm_2;

%the first second of each video is often too bright, so skip the first
%30 frames later on
firstFrame=30;

%rename camera parameters (adjust the name of your saved camera-parameters)
cameraParams_red=cameraParams_200918_red;
cameraParams_green=cameraParams_200918_green;


%delete unnecessary variables
clear rpi1
clear rpi2
clear cam1
clear cam2
clear cameraParams_200918_red
clear cameraParams_200918_green

%Save the workspace with all calibrations
save('cameraCalibrations_200918.mat')