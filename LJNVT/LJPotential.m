function energy = LJPotential(coords,L)

    energy = 0;
    particles = size(coords,2);

    for partA = 1:particles-1
        for partB = (partA+1):particles

            dr = coords(:,partA) - coords(:,partB);
            dr = DPBC(dr,L);
            dr2 = sum(dot(dr,dr));

            % U(r)=4*e*[(s/r)^12 - (s/r)^6]
            % e=s=1
            % U(r)=4*[(1/r)^12 - (1/r)^6]

            inv_dr6 = 1.0/(dr2^3);
            inv_dr12 = 1.0/(dr2^6);
            energy = energy + (inv_dr12 - inv_dr6);
        end

    end

    energy = 4*energy;
end