function [ As, Ps, Qs ] = updateAs(Xcurr, As, Bs, Cnew, Ps, Qs, Ks, Ha, HbGram, HbDirect, lambda)

numA = length(As);
numB = length(Bs);
N = numA+numB+1;
R = size(As{1},2);
dims = size(Xcurr);

h = Cnew.*HbDirect;

for i=1:numA
    n = i;
    Xn = reshape(permute(Xcurr, [n, 1:n-1, n+1:N]), dims(n), []);

    Ps{i} = Ps{i}+Xn*khatrirao(h,Ks{i});
    Qs{i} = Qs{i}+(Cnew'*Cnew).*HbGram.*Ha./(As{i}'*As{i});
    As{i} = Ps{i}/(Qs{i}+lambda*eye(R));
end

end
