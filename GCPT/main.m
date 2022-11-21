clear all; close all; clc

L = 10;
maxpart = L*L;
N0 = ceil(maxpart/2);
steps = 10000;
addremSteps = 100;
exchangeSteps = 100;
simFreq = 1000;

[temperature,mu] = meshgrid([1.03,1.51,1.67],[-1.97,-2.05,-2.01]);
Ncopy = numel(temperature);
temperature = reshape(temperature,1,Ncopy);
mu = reshape(mu,1,Ncopy);
fugacity = exp(mu./temperature);

occupy = zeros(L,L,Ncopy);
coords = zeros(2,maxpart,Ncopy);
E = zeros(1,Ncopy);
particles = ones(1,Ncopy)*N0;

placedpart = 0;
for x = 1:L
    for y = 1:L
        if(placedpart < N0)
            placedpart = placedpart+1;
            coords(:,placedpart,:) = repmat([x;y],1,Ncopy);
            occupy(x,y,:) = 1;
        end
    end
end

for n = 1:Ncopy
    for x = 1:L
        for y = 1:L
            E(n) = E(n)-occupy(x,y,n)*neighbor(x,y,occupy(:,:,n),L);
        end
    end
end
E = E/2;

MultiLatConfig(coords,particles,L)
pause(1);

h = struct();
for n = 1:Ncopy
    h(n).count = 0;
    h(n).range = [0,1];
    h(n).increment = 0.1;
    h(n).histFreq = 1000;
    h(n).saveFileName = 'GCPThist.dat';
    h(n).histo = 0;
    h(n).values = 0;
end

for step = 1:steps
    
    for subStep = 1:exchangeSteps
        
        n1 = ceil(rand*Ncopy);
        n2 = ceil(rand*Ncopy);
        
        E1 = E(n1);
        E2 = E(n2);
        dE = E2-E1;

        N1 = particles(n1);
        N2 = particles(n2);
        dN = N2-N1;
        
        dbeta = 1/temperature(n2)-1/temperature(n1);
        dfug = mu(n2)/temperature(n2)-mu(n1)/temperature(n1);
        
        
        if(rand<exp(dbeta*dE - dfug*dN))
            
            coordsTemp = coords(:,:,n1);
            coords(:,:,n1) = coords(:,:,n2);
            coords(:,:,n2) = coordsTemp;
            
            occupyTemp = occupy(:,:,n1);
            occupy(:,:,n1) = occupy(:,:,n2);
            occupy(:,:,n2) = occupyTemp;
            
            E(n1) = E2;
            E(n2) = E1;
            particles(n1) = N2;
            particles(n2) = N1;
            
        end
        
    end
    
    for n = 1:Ncopy
        
        for subStep = 1:addremSteps
            
            if( rand < 0.5)

                x = ceil(rand*L);
                y = ceil(rand*L);
                
                if(occupy(x,y,n) == 0)
                    
                    dE = -neighbor(x,y,occupy(:,:,n),L);
                    
                    if(rand < exp(-dE/temperature(n))*fugacity(n)*maxpart/(particles(n)+1))

                        E(n) = E(n)+dE;
                        particles(n) = particles(n)+1;
                        coords(:,particles(n),n) = [x,y]';
                        occupy(x,y,n) = 1;
                    end
                end
                
            else
                
                if(particles(n)>0)
                    
                    part = ceil(rand*particles(n));
                    xpart = coords(1,part,n);
                    ypart = coords(2,part,n);
                    
                    dE = neighbor(xpart,ypart,occupy(:,:,n),L);
                    
                    if(rand < exp(-dE/temperature(n))*particles(n)/(maxpart*fugacity(n)))

                        E(n) = E(n)+dE;
                        occupy(xpart,ypart,n) = 0;
                        coords(:,part,n) = coords(:,particles(n),n);
                        particles(n) = particles(n)-1;
                        
                    end
                end
            end
        end
        
        if(particles(n)>0)
            
            for subStep = 1:maxpart
                
                part = ceil(rand*particles(n));
                xpart = coords(1,part,n);
                ypart = coords(2,part,n);
                
                x = ceil(rand*L);
                y = ceil(rand*L);
                
                if(occupy(x,y,n) == 0)
                    
                    
                    dE = neighbor(xpart,ypart,occupy(:,:,n),L);
                    occupy(xpart,ypart,n) = 0;
                    occupy(x,y,n) = 1;
                    dE = dE-neighbor(x,y,occupy(:,:,n),L);
                    occupy(xpart,ypart,n) = 1;
                    occupy(x,y,n) = 0;
                    
                    if(rand<exp(-dE/temperature(n)))

                        E(n) = E(n)+dE;
                        occupy(xpart,ypart,n) = 0;
                        coords(:,part,n) = [x,y]';
                        occupy(x,y,n) = 1;
                    end
                end
            end
        end
    end
    
    if(mod(step,simFreq) == 0)
        MultiLatConfig(coords,particles,L)
        %if step==steps
        %    pause;
        %end
    end
    
    for n = 1:Ncopy
        h(n) = histogram(h(n),particles(n)/maxpart);
    end
    
end

clf;
nPlots = sqrt(Ncopy);

for n = 1:Ncopy
    subplot(nPlots,nPlots,n)
    bar(h(n).values,h(n).histo)
end