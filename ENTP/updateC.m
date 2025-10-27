function [ Cnew, F, G ] = updateC(Xcurr, As, Bs, F, G, Kall, Ha, HbGram, HbDirect, lambda)

numA = length(As);
numB = length(Bs);
% N = numA+numB+1;
R = size(Bs{1},2);

Xn = reshape(Xcurr, 1, []);

F = F+Xn*khatrirao(HbDirect, Kall);
G = G+HbGram;
Cnew = F/((G.*Ha)+(lambda*eye(R)));

end
