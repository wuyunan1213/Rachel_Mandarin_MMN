function playList = randomizePlayListRachel(dev_perc,dis_perc,N)

[nDev,dDev] = rat(dev_perc);
[nDis,dDis] = rat(dis_perc);
d = 5;%This doesn't change dynamically, need to edit for each change

for k = 1:ceil(N/d)
    rerunFlag = 1; m = 0;
    
    while(rerunFlag)
        m = m+1;
        temp = [1*ones(1,d-(nDev+nDis)),2*ones(1,nDev),3*ones(1,nDis)];
        temp = temp(randperm(d));
        
        if(dis_perc>0)
            if(min(diff(find(temp>1)))>2 && min(find(temp>1))>2)
                rerunFlag = 0;
            end
        else
            if(min(find(temp>1))>2) && isequal(temp(1:3),[1,1,1])
                rerunFlag = 0;
            end
        end
    end
    playList(1:d,k) = temp';
    
end

    playList = playList(:)';
return

