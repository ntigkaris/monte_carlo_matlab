function c = plotCircle(x,y,r)

    theta = 0:pi/50:2*pi;
    xcircle = r*cos(theta) + x;
    ycircle = r*sin(theta) + y;
    c = plot(xcircle,ycircle);

end