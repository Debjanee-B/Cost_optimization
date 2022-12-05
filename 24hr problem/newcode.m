N = numel(Ppv);
C = 81;
socini = 0.9;
Pshift = zeros(24,1);
for t = 1:1:N
    if t==1
        soc(t) = socini;
        if (Ppv(t) >= Pflex(t) + Pinflex(t) + Pshift(t))
                if (t >= 13 || t <= 16)
                    
                    [Pgrid(t), Pbatt(t), cost, Pload(t)]  = battery( Ppv(t), Pev(t), Pinflex(t), Pflex(t) + Pshift,  Cgrid(t));
                    
                    
                    
                
        end
    end
end
