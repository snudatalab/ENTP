function [ Ks ] = getKhatriRaos(mats)

N = length(mats);

if N==1
    R = size(mats{1}, 2);
    Ks{1} = ones(1, R);
else
    lefts = {mats{N}};
    rights = {mats{1}};
    
    if N>2
        for n=1:N-2
            lefts{n+1} = khatrirao(lefts{n}, mats{N-n});
            rights{n+1} = khatrirao(mats{n+1}, rights{n});
        end
    end
    
    Ks{1} = lefts{N-1};
    Ks{N} = rights{N-1};
    
    if N>2
        for n=2:N-1
            Ks{n} = khatrirao(lefts{N-n}, rights{n-1});
        end
    end
end

end

