function [ Bs, Us, Vs ] = updateBs(Xcurr, As, Bs, Cnew, Us, Vs, Kall, Ha, Hbprev, HbGram, HbDirect, currIdxs, lambda)

numA = length(As);
numB = length(Bs);
% N = numA+numB+1;
R = size(Bs{1},2);

for i=1:numB
    % n = numA+i;
    Xn = reshape(Xcurr, 1, []);

    j = currIdxs(i);
    
    Bcurr_gram = Bs{i}(j,:)'*Bs{i}(j,:);
    Bprev_gram = Bs{i}(1:j-1,:)'*Bs{i}(1:j-1,:);
    if j==1
        Bprev_gram = Bprev_gram + 1;
    end
    
    Us{i}(j,:) = Us{i}(j,:)+Xn*khatrirao(Cnew.*HbDirect./Bs{i}(j,:), Kall);
    Vs{i} = Vs{i}+(Cnew'*Cnew).*((Hbprev./Bprev_gram)+(HbGram./Bcurr_gram));
    Bs{i}(j,:) = Us{i}(j,:)/((Vs{i}.*Ha)+(lambda*eye(R)));
end

end
