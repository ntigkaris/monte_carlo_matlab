function dr = PBC(dr,L)

    for dimension=1:3

        if (dr(dimension) > L)

            dr(dimension) = dr(dimension) - L;

        elseif (dr(dimension) < 0)

            dr(dimension) = dr(dimension) + L;

        end

     end

end