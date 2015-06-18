function nOut = trimOutput(nTime)

nOut = nTime;

while nOut > 1000
    
    factor = nTime/1000;
    
    if round(factor) == factor
        
        nOut = nTime/factor;
        
    else
        
        if nOut < 2000
            
            nOut = nOut/2;
            
        elseif nOut < 5000
            
            nOut = nOut/5;
            
        else
            
            nOut = nOut/10;
            
        end
        
    end
    
end

end

