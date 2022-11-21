clear all; close all;

L = 10;
maxpart = L^2;
particles = 10;
steps = 50000;
addremoveFrac = 0.5;
simFreq = 1000;
mu = -2;
temperature = 2.0; %2.8
fugacity = exp(mu/temperature);

occupy = zeros(L,L);
coords = zeros(2,particles);

placedparticles = 0;

for x=1:L
    for y=1:L
        if (placedparticles < particles)
            placedparticles = placedparticles + 1;
            coords(:,placedparticles)=[x,y]';
            occupy(x,y) = 1;
        end
    end
end

LatConfig(coords,particles,L);
pause(1);

h = struct;
h.count =0;
h.range=[0,1];
h.increment=0.025;
h.histFreq = 1000;
h.saveFileName = 'GCABhist.dat';

sampleStart = 1000;
avgc = 0;
sampleCount = 0;

for step=1:steps
    
    if (rand < addremoveFrac)
        
        if (rand<0.5)
            
            if (rand < fugacity * maxpart/(particles+1))
              
                xnew = ceil(rand*L);
                ynew = ceil(rand*L);

                if (occupy(xnew,ynew)==0)
                  
                    particles = particles + 1;
                    coords(:,particles) = [xnew , ynew]';
                    occupy(xnew,ynew) = 1;
                    
                end
                
            end
            
        else
            
            if (rand < particles/(maxpart*fugacity))
              
                if ( rand < particles/maxpart )
                  
                    part = ceil(rand*particles);
                    occupy(coords(1,part),coords(2,part)) = 0;
                    coords(:,part) = coords(:,particles);
                    particles = particles - 1;
                    
                end
            end
        end
    end
    
    if (particles > 0)
      
        for i = 1:maxpart
          
            part = ceil(rand*particles);
            xnew = ceil(rand*L);
            ynew = ceil(rand*L);
        
            if ( occupy(xnew,ynew) == 0 )
              
                occupy(coords(1,part),coords(2,part)) = 0;
                coords(:,part) = [xnew,ynew]';
                occupy(xnew,ynew) = 1;
                
            end
            
        end
        
        if ( mod(step,simFreq) == 0 )
          
            LatConfig(coords,particles,L);
            pause(1);
            %if step==steps
            %    pause;
            %end
            
        end
        
        if ( step > sampleStart )
          
            avgc = avgc + particles/maxpart;
            sampleCount = sampleCount + 1;
            h = histogram(h,particles/maxpart);
            
        end
        
    end
    
end
    
avgc = avgc / sampleCount;
clf

h.histo = h.histo/(h.count*h.increment);
bar(h.values,h.histo);

theor = exp(-2*maxpart*(h.values - 0.5).^2)*sqrt(2*maxpart/pi);
hold on
plot(h.values,theor,'r');
legend('Simulation','Theoretical distribution');