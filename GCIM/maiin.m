clear all; close all;

L = 10;
maxpart = L*L;
particles = maxpart;
temperature = 2.53;
mu = -2;
fugacity = exp(mu/temperature);
steps = 10000;
addremoveSteps = 100;
simFreq = 100;

occupy = zeros(L,L);
coords = zeros(2,particles);
placedpart = 0;

for x=1:L
    for y=1:L
        if placedpart < particles
            placedpart = placedpart + 1;
            coords(:,placedpart) = [x,y]';
            occupy(x,y) = 1;
        end
    end
end

E = 0;
for x=1:L
    for y=1:L
        E = E + occupy(x,y)*neighbor(x,y,occupy,L);
    end
end
E = E/2; % overcounted site interactions by 2, thus halve the energy

LatConfig(coords,particles,L);
pause(1);

h = struct;
h.count = 0;
h.range = [0,1];
h.increment = 0.025;
h.histFreq = 1000;
h.saveFileName = 'GCIMhist.dat';
sampleStart = 1000;
avgc = 0;
sampleCount = 0;
%%
for step=1:steps
  
    for i=1:addremoveSteps %%?
      
        if rand<0.5
          
            x = ceil(rand*L);
            y = ceil(rand*L);
            
            if occupy(x,y)==0
              
                dE = neighbor(x,y,occupy,L);
                
                if rand < exp(-dE/temperature)*fugacity*maxpart/(particles+1)
                  
                    E = E + dE;
                    particles = particles + 1;
                    coords(:,particles) = [x,y]';
                    occupy(x,y) = 1;
                    
                end
            end
           
        else
            
            if particles > 0
              
                part = ceil(rand*particles);
                xpart = coords(1,part);
                ypart = coords(2,part);
                
                dE = neighbor(xpart,ypart,occupy,L);
                
                if rand < exp(-dE/temperature)*particles/(maxpart*fugacity)
                  
                    E = E - dE;
                    occupy(xpart,ypart) = 0;
                    coords(:,part) = coords(:,particles);
                    particles = particles - 1;
                    
                end
            end
            
        end
        
    end
    
    if particles > 0
        
        for i=1:maxpart
            
            part = ceil(rand*particles);
            xpart = coords(1,part);
            ypart = coords(2,part);
            xnew = ceil(rand*L);
            ynew = ceil(rand*L);
            
            if occupy(xnew,ynew)==0

                dE = neighbor(xnew,ynew,occupy,L) - neighbor(xpart,ypart,occupy,L);

                if rand < exp(-dE/temperature)
                    E = E + dE;
                    occupy(xpart,ypart) = 0;
                    coords(:,part) = [xnew,ynew]';
                    occupy(xnew,ynew) = 1;
                end
            end
           
        end
        
    end
    
    if mod(step,simFreq)==0
      
        LatConfig(coords,particles,L);
        pause(1);
%         if step==steps
%            pause;
%         end
        
    end
    
    if step > sampleStart
      
        avgc = avgc + particles/maxpart;
        sampleCount = sampleCount + 1;
        h = histogram(h, particles/maxpart);
        
    end
    
end

avgc = avgc / sampleCount;
clf;
h.histo = h.histo/(h.count*h.increment);
bar(h.values,h.histo);
