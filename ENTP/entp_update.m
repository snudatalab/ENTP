function [ As, Bs, Cnew, Ps, Qs, Us, Vs, F, G ] = entp_update(Xcurr, As, Bs, Ps, Qs, Us, Vs, F, G, currIdxs, lambda)

numA = length(As);
numB = length(Bs);
% N = numA+numB+1;
R = size(Bs{1},2);

% Pre-computations
if numA==0
    Kall = ones(1,R);
    Ha = ones(R,R);
else
    Ks = getKhatriRaos(As);
    Kall = khatrirao(Ks{1}, As{1});
    Ha = getHadamard(As, 'gram');
end

[currBs, prevBs] = getMatRows(Bs, currIdxs);
HbGram = getHadamard(currBs, 'gram');
HbDirect = getHadamard(currBs, 'direct');

if numB==1
    Hbprev = zeros(R,R);
else
    Hbprev = getHadamard(prevBs, 'gram');
end

% Update the temporal "trend" mode
[Cnew, F, G] = updateC(Xcurr, As, Bs, F, G, Kall, Ha, HbGram, HbDirect, lambda);

% Update the temporal "periodic" mode
[Bs, Us, Vs] = updateBs(Xcurr, As, Bs, Cnew, Us, Vs, Kall, Ha, Hbprev, HbGram, HbDirect, currIdxs, lambda);

% Update the non-temporal mode
if numA>0
    [As, Ps, Qs] = updateAs(Xcurr, As, Bs, Cnew, Ps, Qs, Ks, Ha, HbGram, HbDirect, lambda);
end

end
