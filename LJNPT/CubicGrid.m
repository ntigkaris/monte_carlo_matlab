function [coords L] = CubicGrid(particles,density)

    coords = zeros(3,particles);
    L = (particles/density)^(1.0/3);

    L0 = 2;
    
    while (L0^3 < particles)
      
        L0 = L0 + 1;
        
    end

    index = [0, 0 ,0]';

    for part=1:particles

        coords(:,part) = (index + [0.5,0.5,0.5]')*(L/L0);
        index(1) = index(1) + 1;
        
        if (index(1) == L0)
            
            index(1) = 0;
            index(2) = index(2) + 1;

            if (index(2)==L0)

                index(2) = 0;
                index(3) = index(3) + 1;

            end

        end

    end
end