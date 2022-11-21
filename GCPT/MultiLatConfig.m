function MultiLatConfig(coords,particles,L)

    clf;

    Ncopy = length(particles);
    Nplots = ceil(sqrt(Ncopy));
    for n=1:Ncopy
        subplot(Nplots,Nplots,n)
        LatConfig(coords(:,:,n),particles(n),L,0);
    end

    drawnow;
    
end