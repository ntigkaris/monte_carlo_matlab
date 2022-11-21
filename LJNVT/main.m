clear all; close all; clc

particles = 100;
density = 0.85;
temperature = 2.0;
beta = 1.0/temperature;
maxDr = 0.1;
steps = 10000;

[coords, L] = CubicGrid(particles,density);

energy = LJPotential(coords,L);

for step=1:steps
    
    for part=1:particles
        
        rTrial = coords(:,part) + maxDr*(rand(3,1) - 0.5);
        rTrial = DPBC(rTrial,L);
        dE = LJChange(coords,rTrial,part,L);
        
        if (rand < exp(-beta*dE))
            
            coords(:,part) = rTrial;
            energy = energy + dE;
           
        end
        
    end
    
end