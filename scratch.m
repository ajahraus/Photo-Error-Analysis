% Photogrammetry Script

close all
clear all
clc

%% 
I(1) =  ImageClass([0,0,0],[90,225,0],Camera());
I(2) =  ImageClass([0,1,0],[90,315,0],Camera());

I(1).displayImageInObjectSpace(1);
I(2).displayImageInObjectSpace(1);