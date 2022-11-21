clear all; close all;

particles = 49;
density = 0.5;
radius = 0.5;
[coords Lx Ly] = hcp(particles,density,radius);

plotConfig(coords,Lx,Ly,radius);

steps = 5000;
maxDr = 0.05;
simFreq = 100;

h.count = 0;
h.range = [0,Lx];
h.increment = Lx / 10;
h.histFreq = 1000;
h.saveFileName = 'HDhist.dat';

for step=1:steps
    
    for part=1:particles
        
        rTrial = coords(:,part) + maxDr*(rand(2,1)-0.5);
        
        check = checkCollision(coords,rTrial,part,particles);
        
        if (rTrial(1)>0 && rTrial(1)<Lx && rTrial(2)>0 && rTrial(2)<Ly && check)
            
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

bar(h.values,h.histo);