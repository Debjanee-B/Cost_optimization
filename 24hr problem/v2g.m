ev = struct('socar', {'0.31', '0.35', '0.5', '0.25', '0.29'} , 'socdes', {'0.85', '0.75', '0.80', '0.78', '0.72'}, 'tar', {'9', '10', '12', '1.5', '2'}, 'tdep', {'4', '0', '4', '0', '0'});

    for t = 1:1:24
    if t <= 12
        Pflex_n(t) = 0;
        
    elseif t>=13 && t<=16
        Pflex_n(t) = Pflex(count+1,1) + Pflex(count+2,1) + Pflex(count+3,1) + Pflex(count+4,1)+ Pflex(count+5,1)+Pflex(count+6,1);  
        count = count + 6;
    else
        Pflex_n(t) = 0;
    end
%case1
for c = 9:1:15
    
        
        
Pshift = 0;
count = 0;
count1 = 0;
count2 = 0;
dt = 1;

for t = 1:1:N
    
    if t == 1 
        
        soc_t(1) = socini;
        
     
         if (Pinflex(t) + Pflex_n(t) + Pev(t)) <= 4
         


            
                    %[Pgrid(t), Pbatt(t), cost(t), Pload(t)] = hr1_working(Ppv(t), Pev(t), Pinflex(t), Pflex_n(t) + Pshift, Cgrid(t));
                    [Pgrid(t), Pbatt(t), cost(t), Pload(t)]  = batterycharge( Ppv(t), Pev(t), Pinflex(t), Pflex_n(t) + Pshift,  Cgrid(t));
                    count = count + 1;
                     
                    soc_t(t+1) = soc_t(t) - dt.*(0.8*Pbatt(t)/(C)); 
                     
                    %soc_t(t+1) = soc_t(t) - dt.*((Pbatt(t)/C));
                    total_cost = total_cost + cost(t);
                    Pshift = 0;





            else

                    %[Pgrid(t), Pbatt(t), soc(t+1), cost(t), Pload(t)] = hr1_working(Ppv(t), Pev(t), Pinflex(t),  0 , soc(t), Cgrid(t));
                     [Pgrid(t), Pbatt(t), cost(t), Pload(t)]  = battery( Ppv(t), Pev(t), Pinflex(t), Pflex_n(t), Cgrid(t));
                     total_cost = total_cost + cost(t);
                    Pshift = Pshift + Pflex_n(t);
                   %soc_t(t+1) = soc_t(t) - dt.*((0.80*Pbatt(t)/C));
                    if Pbatt(t) <= 0
                                soc_t(t+1) = soc_t(t) - dt.*((Pbatt(t)*0.8)/C);
                    else
                                soc_t(t+1) = soc_t(t) - dt.*(Pbatt(t)/(0.8*C)); 
                    end
                    
            end
         
    elseif soc_t(t) <= 0.25
            
                        [Pgrid(t), Pbatt(t), cost(t), Pload(t)]  = batterycharge( Ppv(t), Pev(t), Pinflex(t), Pflex_n(t) + Pshift,  Cgrid(t));
                        count = count + 1;
                        soc_t(t+1) = soc_t(t) - dt.*((0.80*Pbatt(t)/C));
                        total_cost = total_cost + cost(t);
                        Pshift = 0;





                    
            
        
              
        elseif soc_t(t) >= 1
                    
                  [Pgrid(t), Pbatt(t), cost(t), Pload(t)]  = batterydischarge( Ppv(t), Pev(t), Pinflex(t), Pflex_n(t) + Pshift,  Cgrid(t));
                   count = count + 1;
                   soc_t(t+1) = soc_t(t) - dt.*(Pbatt(t)/(0.8*C));
                   total_cost = total_cost + cost(t);
                                  





             
       else
              
         if (Pinflex(t) + Pflex_n(t) + Pev(t)) <= 4
         


            
                    %[Pgrid(t), Pbatt(t), cost(t), Pload(t)] = hr1_working(Ppv(t), Pev(t), Pinflex(t), Pflex_n(t) + Pshift, Cgrid(t));
                    [Pgrid(t), Pbatt(t), cost(t), Pload(t)]  = batterycharge( Ppv(t), Pev(t), Pinflex(t), Pflex_n(t) + Pshift,  Cgrid(t));
                    count = count + 1;
                     
                    soc_t(t+1) = soc_t(t) - dt.*(0.8*Pbatt(t)/(C)); 
                     
                    %soc_t(t+1) = soc_t(t) - dt.*((Pbatt(t)/C));
                    total_cost = total_cost + cost(t);
                    Pshift = 0;





            else

                    %[Pgrid(t), Pbatt(t), soc(t+1), cost(t), Pload(t)] = hr1_working(Ppv(t), Pev(t), Pinflex(t),  0 , soc(t), Cgrid(t));
                     [Pgrid(t), Pbatt(t), cost(t), Pload(t)]  = battery( Ppv(t), Pev(t), Pinflex(t), Pflex_n(t), Cgrid(t));
                     total_cost = total_cost + cost(t);
                    Pshift = Pshift + Pflex_n(t);
                   %soc_t(t+1) = soc_t(t) - dt.*((0.80*Pbatt(t)/C));
                    if Pbatt(t) <= 0
                                soc_t(t+1) = soc_t(t) - dt.*((Pbatt(t)*0.8)/C);
                    else
                                soc_t(t+1) = soc_t(t) - dt.*(Pbatt(t)/(0.8*C)); 
                    end
                    
            end
        end
                           
            
              
        
           
         end