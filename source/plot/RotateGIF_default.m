function RotateGIF_default(fileName,figH,varargin)
%ROTATEGIF_DEFAULT Summary of this function goes here
%   Detailed explanation goes here
    eleDeg = 45;
    if length(varargin) == 0
        k = [-1.3,1.3,-1.3,1.3,-1.3,1.3];
        axis (k)
    else
        switch varargin{1}
            case 'none'
                eleDeg = 15;
                
            otherwise
                k = varargin{1};
                axis (k)
        end
    end
    axis equal
    axisH = gca;
    aziDeg = (0:2:180).';
    timeGap = 1/30;
    RotateGIF(fileName, figH, axisH, aziDeg, eleDeg, timeGap)
end

