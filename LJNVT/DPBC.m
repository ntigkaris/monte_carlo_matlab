function dr = DPBC(dr,L)

    hL = L/2.0;

    for dimension=1:3

        if (dr(dimension) > hL)

            dr(dimension) = dr(dimension) - L;

        elseif (dr(dimension) < -hL)

            dr(dimension) = dr(dimension) + L;

        end

     end

end