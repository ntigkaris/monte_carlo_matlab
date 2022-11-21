clear all; close all;

particles = 100;
density = 0.85;
temperature = 2.0;
beta = 1.0/temperature;
pressure = 1.0;
maxDr = 0.1;
maxDv = 0.01;

steps = 10000;
sampleFreq = 10;
sampleCount = 0;

[coords L] = CubicGrid(particles,density);

energy = LJPotential(coords,L);

avgL = 0;

for step=1:steps
    
    if (rand*(particles+1) + 1 < particles)
        
        for part=1:particles
            
            rTrial = coords(:,part) + maxDr*(rand(3,1)-0.5);
            rTrial = DPBC(rTrial,L);
            dE = LJChange(coords,rTrial,part,L);
            
            if (rand < exp(-beta*dE))
                
                coords(:,part) = rTrial;
                energy = energy + dE;
                
            end
            
        end
        
    else
        
        % Frenkel & Smit 5.4.1 , 5.4.2
        oldV = L^3;
        lnvTrial = log(oldV) + (rand - 0.5)*maxDv;
        vTrial = exp(lnvTrial);
        newL = vTrial^(1.0/3);

        scaledcoords = coords*(newL/L);
        eTrial = LJPotential(scaledcoords, newL);

        weight = (eTrial - energy) + pressure*(vTrial - oldV) - (particles+1)*temperature*log(vTrial/oldV);
        
        if (rand < exp(-beta*weight))
            
            coords = scaledcoords;
            energy = eTrial;
            L = newL;
            
        end
        
    end
    
    if (mod(step,sampleFreq)==0)
        sampleCount = sampleCount + 1;
        avgL = avgL + L;
    end
    
end

avgL = avgL / sampleCount;