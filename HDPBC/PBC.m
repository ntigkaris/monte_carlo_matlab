function r = PBC(r,Lx,Ly)

    if (r(1) > Lx)
      
        r(1) = r(1) - Lx;
        
    elseif (r(1) < 0 )
        
        r(1) = r(1) + Lx;
        
    end

    if (r(2) > Ly)
      
        r(2) = r(2) - Ly;
        
    elseif (r(2) < 0 )
        
        r(2) = r(2) + Ly;
        
    end

end