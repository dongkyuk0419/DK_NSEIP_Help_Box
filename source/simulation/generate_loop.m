function [xsamp] = generate_loop(N,R,origin,angle,inversion,noise,plot,mode)
% This function generates a loop in R^3 space using the provided parameters
%   N: number of points
%   R: radius of the loop
%   origin: the center point of the loop
%   angel: elevation of the loop from the xy plane
%   inversion: 1 - invert the loop for the z axis; 0 - nothing
%   noise: additive noise of standard deviation of "noise" to all xyz.
%   plot: 1 - plot the xsamp
%   mode: 1 - random (default); 0- uniform
%   
%   xsamp: output coordinate of the dimension [N,3]
    if mode==1
        degsamp = rand(N,1)*2*pi;
    else
        degsamp = linspace(0,2*pi*(1-1/N),N).';
    end
    Rsamp = ones(N,1)*R;
    Rot = [1,0,0;0,cos(angle),-sin(angle);0,sin(angle),cos(angle)];
    temp = [Rsamp.*cos(degsamp),Rsamp.*sin(degsamp),zeros(N,1)];
    temp = temp-origin;
    xsamp = (Rot*temp.').';
    if (inversion)
        for i = 1:N
            if (xsamp(i,3)<0)
                xsamp(i,3) = -xsamp(i,3);
            end
        end
    end
    xsamp = xsamp + noise*randn(N,3);
    if plot
        figure;
        plot3(xsamp(:,1),xsamp(:,2),xsamp(:,3),'.')
    end
end