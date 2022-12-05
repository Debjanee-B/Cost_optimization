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
        if j >= 13 && j <=16
            pflex(j, i) = flex(n)/4;
        else
            pflex(j, i) = 0;
        end
    end
    n = n+1;
end
Pflex_n = reshape(pflex, [720, 1]);
