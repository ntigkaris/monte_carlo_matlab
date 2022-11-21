function plotConfig(coords,Lx,Ly,radius)

    if nargin < 4

        radius = 0.25;

    end

    cla;
    hold on;

    outlineX = [0 Lx Lx 0 0];
    outlineY = [0 0 Ly Ly 0];
    plot(outlineX,outlineY);

    particles = size(coords,2);

    for part=1:particles

        plotCircle(coords(1,part),coords(2,part),radius);

    end

    axis equal;
    axis([-0.5 Lx+0.5 -0.5 Ly+0.5]);

    drawnow;

end