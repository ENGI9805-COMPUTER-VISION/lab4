function [point] = mapping(localrel2,row,col,c)

    vote = zeros(row,col);
    margin = 4;
    
    for i=1:c
        disp(i);
        l1 = round(localrel2(i,1)-margin);
        r1 = round(localrel2(i,1)+margin);

        l2 = round(localrel2(i,2)-margin);
        r2 = round(localrel2(i,2)+margin);

        if(l1 < 1)
            l1 = 1;
        end
        if(l2 < 1)
            l2 = 1;
        end
        if(r1 < 1)
            r1 = 1;
        end
        if(r2 < 1)
            r2 = 1;
        end

        if(l1 > row)
            l1 = row;
        end
        if(l2 > col)
            l2 = col;
        end
        if(r1 > row)
            r1 = row;
        end
        if(r2 > col)
            r2 = col;
        end

        vote(l1:r1,l2:r2) = vote(l1:r1,l2:r2) + ones(r1-l1+1,r2-l2+1);
    end

    [M,Ix] = max(vote);
    [M,Iy] = max(M);
    Ix = Ix(Iy);
    
    point = [Ix,Iy];
end