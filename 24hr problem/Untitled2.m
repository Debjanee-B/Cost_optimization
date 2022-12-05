n = 1;
for i = 1:1:23
    for j = 1:1:24
        flex(j, i) = Pflex(n);
        n = n+1;
    end
end
for i = 1:1:23
    for j = 1:1:24
        if (j >= 13 && j <= 16)
            flexi(j,i) = flex(c, i) +flex(c+1, i) + flex(c+1, i) + flex(c+3, i) +flex(c+4, i);
            c = c+6;
        else
            flexi(j, i) = 0;
        end
    end
    c = 1;
end
Pflex_n = reshape(flexi, [552,1]);     