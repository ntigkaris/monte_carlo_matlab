function RD = rdist(RD,coords,Lx,Ly)
    
    particles = size(coords,2);
    partDens = particles/(Lx*Ly);
    RD.count = 0;
    RD.histFreq = 1000;
    max = sqrt((Ly*Ly)+(Lx*Lx))*0.3;
    RD.range = [0,max];
    RD.increment = RD.range(2)/10;

    for parta = 1:(particles-1)
        for partb = (parta+1):particles
            dr = coords(:,parta) - coords(:,partb);
            dr = PBC(dr,Lx,Ly);
            dr2 = sum(dot(dr,dr));
            r = sqrt(dr2);
            if (r < RD.range(2))
                RD = histogram(RD,r);
            end
        end
    end

    for bin = 1:size(RD.values,2)
        index = RD.values(bin);
        nindex = RD.increment + index;
        dindex2 = nindex^2 - index^2;
        RD.histo(bin) = RD.histo(bin) / (pi*dindex2*partDens);
    end

    RD.histo = 2.0*RD.histo/(0.95*particles);
    bar(RD.values,RD.histo);

end