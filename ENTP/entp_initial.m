function [ As, Bs, C, Ps, Qs, Us, Vs ] = entp_initial(Xinit, R, numA, numB)

dims = size(Xinit);
N = length(dims);

assert(numA+numB+1==N, 'Tensor order not matching');

% CP decompsotion of the initial data
estXinit = cp_als(tensor(Xinit), R, 'tol', 1e-8, 'printitn', 1, 'maxiters', 100);
allFactors = estXinit.U;
for i=1:N
    allFactors{i} = allFactors{i}*diag(estXinit.lambda.^(1/N));
As = allFactors(1:numA);
Bs = allFactors(numA+1:numA+numB);
C = allFactors{end};

% Compute the auxiliary matrices for As and Bs (the first N-1 modes).
Ks = getKhatriRaos([As; Bs]);
Hb = getHadamard([Bs; C], 'gram');
for i=1:numA
    Ha = getHadamard(As, 'gram');
    n = i;
    Xn = reshape(permute(Xinit, [n, 1:n-1, n+1:N]), dims(n), []);
    Ps{i} = Xn*khatrirao(C, Ks{n});
    Qs{i} = Hb.*Ha./(As{i}'*As{i});
end
for i=1:numB
    n = numA+i;
    Xn = reshape(permute(Xinit, [n, 1:n-1, n+1:N]), dims(n), []);
    Us{i} = Xn*khatrirao(C, Ks{n});
    Vs{i} = Hb./(Bs{i}'*Bs{i});
end

if numA==0
    Ps = {};
    Qs = {};
end

end
