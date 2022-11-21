function neigh = neighbor(xpart,ypart,occupy,L)

    if xpart ==1
        left = L;
    else
        left = xpart-1;
    end

    if xpart == L
        right = 1;
    else
        right = xpart+1;
    end

    if ypart==1 
        up = L;
    else
        up = ypart-1;
    end

    if ypart==L
        down = 1;
    else
        down = ypart+1;
    end

    neigh = occupy(left,ypart) + occupy(right,ypart) + occupy(xpart,down) + occupy(xpart,up);
    
end