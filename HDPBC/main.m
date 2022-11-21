clear all; close all; clc;

particles = 16;
density = 0.7;
radius = 0.5;
[coords Lx Ly] = hcp(particles,density,radius);

plotConfig(coords,Lx,Ly,radius);

steps = 15000;
maxDr = 0.1;
simFreq = 100;

h.count = 0;
h.range = [0,Lx];
h.increment = Lx / 10;
h.histFreq = 1000;
h.saveFileName = 'HDPBChist.dat';

for step=1:steps
    
    for part=1:particles
        
        rTrial = coords(:,part) + maxDr*(rand(2,1)-0.5);
        rTrial = PBC(rTrial,Lx,Ly);
        check = checkCollision(coords,rTrial,part,particles);
        
        if (check)
            
            coords(:,part) = rTrial;
            
        end
        
        h = histogram(h,coords(1,part));
        
    end
    
    % every 100 steps
    if (mod(step,simFreq)==0)
      
        plotConfig(coords,Lx,Ly,radius);
        
    end
    
end

clf;
figure(1)
bar(h.values,h.histo);

%

rD = struct;
figure(2)
rD = rdist(rD,coords,Lx,Ly);