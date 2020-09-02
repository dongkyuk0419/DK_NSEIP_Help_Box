function [figH] = easyplot3(data)
%EASYPLOT3 Summary of this function goes here
%   Detailed explanation goes here

figure;
figH = plot3(data(:,1),data(:,2),data(:,3),'.');

end

