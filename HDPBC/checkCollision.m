function check = checkCollision(coords,rTrial,partmoving,particles)

    check = true;
    
    for part=1:particles
        
        if (part~=partmoving)
            
            dr = coords(:,part) - rTrial;
            dotdr = dot(dr,dr);
            
            if  (dotdr < 1)
                
                check = false;
                break;
                
            end
            
        end
        
    end
    
end