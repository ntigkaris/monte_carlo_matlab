function [coords Lx Ly] = hcp(particles,density,radius)
  
    intRoot = floor(sqrt(particles));
    
    if (sqrt(particles) - intRoot) > 1e-7
      
        coords = zeros(2,particles);
        Lx = 0.0;
        Ly = 0.0;
        return
        
    end

    sepDist = sqrt(2*pi*radius*radius/(density*sqrt(3)));
    
    Lx = sepDist * sqrt(particles);
    Ly = Lx*sqrt(3)/2;
    
    xPos = linspace(sepDist/2, Lx-sepDist/2, sqrt(particles));
    yPos = (sqrt(3)/2)*xPos;
    
    [X,Y] = meshgrid(xPos,yPos);
    X(1:2:end,:) = X(1:2:end,:) + sepDist/2;
    coords = [reshape(X,1,numel(X));reshape(Y,1,numel(Y))];
    
end