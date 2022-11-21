function LatConfig(coords,particles,L,newFig)

  if (nargin < 4)
    
      newFig = 1;
      
  end

  if newFig
    
      clf;
      
  end
  
  hold on

  for lat=0:L
    
      plotX = [0.5,L+0.5];
      plotY = [lat+0.5,lat+0.5];
      plot(plotX,plotY);
      
  end

  for lat=0:L
    
      plotX=[lat+0.5,lat+0.5];
      plotY=[0.5,L+0.5];
      plot(plotX,plotY);
      
  end

  radius = 0.4;

  for part=1:particles
    
      plotCircle(coords(1,part),coords(2,part),radius);
      
  end
  
  axis equal;

end