Pinflex_re = reshape(Pinflex, [24, 30]);

flag = 0;
 j = 1;
for i = 1:1:30
    
    j = 1;
    flag = 0;
           
          while flag == 0 && j <25
            
                if j > 10 && j<20
                    if Pinflex_re(j,i) <= 10
                    low(i) = j;
                    high(i) = j+ 2;
                    flag = 1;

                    end
                end
                j = j+1;
           end
end

   

N = numel(Pev);
n = 1;
Pflex_t = reshape(Pflex, [24, 30]);

pflex = reshape(Pflex, [24, 30]);
n = 1;
flexsum = 0;
for i = 1:1:30
    for j = 1:1:24
        flexsum = flexsum + pflex(j, i);
       
    end
    flex(n) = flexsum;
    flexsum = 0;
    n = n+1;
end  
n = 1;
for i = 1:1:30
    for j = 1:1:24
        if j >= low(i) && j <= high(i)
            pflex(j, i) = flex(n)/3;
        else
            pflex(j, i) = 0;
        end
    end
    n = n+1;
end
Pflex_n = reshape(pflex, [720, 1]);
      
            
        

C =81;
total_cost = 0;
%Cgrid = [2.8 ;2.4 ;2.4 ;2.4 ;2.5 ;3.2 ;3.9 ;3.7; 3.2 ;2.7 ;2.7 ;2.7 ;2.6 ;2.6 ;2.7 ;2.9 ;3.4 ;4.6 ;8.9 ;7.8 ;4.8;3.7 ;3.5 ;3.4]; 
socini = 0.25;
soc_t = [0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0];

cnt = 1;
new =1;
c =1;



      
        
Pshift = 0;
count = 0;
count1 = 0;
count2 = 0;
dt = 1;

for ti = 1:1:24
    
    if ti == 1 
        
        soc_t(1) = socini;
        
     
         if (Pinflex(ti) + Pflex_n(ti) + Pev(ti)) <= Ppv(ti)
         


            
                    %[Pgrid(t), Pbatt(t), cost(t), Pload(t)] = hr1_working(Ppv(t), Pev(t), Pinflex(t), Pflex_n(t) + Pshift, Cgrid(t));
                    [Pgrid(ti), Pbatt(ti), cost(ti), Pload(ti)]  = batterycharge( Ppv(ti), Pev(ti), Pinflex(ti), Pflex_n(ti) ,  Cgrid(ti));
                    count = count + 1;
                     
                    soc_t(ti+1) = soc_t(ti) - dt.*(0.8*Pbatt(ti)/(C)); 
                     
                    %soc_t(t+1) = soc_t(t) - dt.*((Pbatt(t)/C));
                    total_cost = total_cost + cost(ti);
                    Pshift = 0;





            else

                    %[Pgrid(t), Pbatt(t), soc(t+1), cost(t), Pload(t)] = hr1_working(Ppv(t), Pev(t), Pinflex(t),  0 , soc(t), Cgrid(t));
                     [Pgrid(ti), Pbatt(ti), cost(ti), Pload(ti)]  = battery( Ppv(ti), Pev(ti), Pinflex(ti), Pflex_n(ti), Cgrid(ti));
                     total_cost = total_cost + cost(ti);
                   
                   %soc_t(t+1) = soc_t(t) - dt.*((0.80*Pbatt(t)/C));
                    if Pbatt(ti) <= 0
                                soc_t(ti+1) = soc_t(ti) - dt.*((Pbatt(ti)*0.8)/C);
                    else
                                soc_t(ti+1) = soc_t(ti) - dt.*(Pbatt(ti)/(0.8*C)); 
                    end
                    
            end
         
    elseif soc_t(ti) <= 0.25
            
                        [Pgrid(ti), Pbatt(ti), cost(ti), Pload(ti)]  = batterycharge( Ppv(ti), Pev(ti), Pinflex(ti), Pflex_n(ti),  Cgrid(ti));
                        count = count + 1;
                        soc_t(ti+1) = soc_t(ti) - dt.*((0.80*Pbatt(ti)/C));
                        total_cost = total_cost + cost(ti);
                        Pshift = 0;





                    
            
        
              
        elseif soc_t(ti) >= 1
                    
                  [Pgrid(ti), Pbatt(ti), cost(ti), Pload(ti)]  = batterydischarge( Ppv(ti), Pev(ti), Pinflex(ti), Pflex_n(ti),  Cgrid(ti));
                   count = count + 1;
                   soc_t(ti+1) = soc_t(ti) - dt.*(Pbatt(ti)/(0.8*C));
                   total_cost = total_cost + cost(ti);
                                  





             
       else
              
         if (Pinflex(ti) + Pflex_n(ti) + Pev(ti)) <= 4
         


            
                    %[Pgrid(t), Pbatt(t), cost(t), Pload(t)] = hr1_working(Ppv(t), Pev(t), Pinflex(t), Pflex_n(t) + Pshift, Cgrid(t));
                    [Pgrid(ti), Pbatt(ti), cost(ti), Pload(ti)]  = batterycharge( Ppv(ti), Pev(ti), Pinflex(ti), Pflex_n(ti) ,  Cgrid(ti));
                    count = count + 1;
                     
                    soc_t(ti+1) = soc_t(ti) - dt.*(0.8*Pbatt(ti)/(C)); 
                     
                    %soc_t(t+1) = soc_t(t) - dt.*((Pbatt(t)/C));
                    total_cost = total_cost + cost(ti);
                    Pshift = 0;





            else

                    %[Pgrid(t), Pbatt(t), soc(t+1), cost(t), Pload(t)] = hr1_working(Ppv(t), Pev(t), Pinflex(t),  0 , soc(t), Cgrid(t));
                     [Pgrid(ti), Pbatt(ti), cost(ti), Pload(ti)]  = battery( Ppv(ti), Pev(ti), Pinflex(ti), Pflex_n(ti), Cgrid(ti));
                     total_cost = total_cost + cost(ti);
                    Pshift = Pshift + Pflex_n(ti);
                   %soc_t(t+1) = soc_t(t) - dt.*((0.80*Pbatt(t)/C));
                    if Pbatt(ti) <= 0
                                soc_t(ti+1) = soc_t(ti) - dt.*((Pbatt(ti)*0.8)/C);
                    else
                                soc_t(ti+1) = soc_t(ti) - dt.*(Pbatt(ti)/(0.8*C)); 
                    end
                    
            end
        end
                           
            
              
        
           
end

 algo_totalcost = sum(cost);
 Pload = transpose(Pload);
              
        