clc;clear;close all;
addpath(genpath('.'));
addpath(genpath('library'))

%% Load data
dataset = 'PEMS';  % ['VicRoads', 'PEMS', 'Electricity']
order = 4;
[X, numA, numB] = getData(dataset, order);

% hyperparameter(s)
R = 5;
lambda = 1.0;
sparsityThres = 0.99;
% stream parameter(s)
dims = size(X);
tao = round(0.5*dims(end));
TT = dims(end)-tao;

%% Initialization
idx = repmat({':'}, 1, length(dims));
idx(end) = {1:tao};
Xinit = X(idx{:});
[As, Bs, C, Ps, Qs, Us, Vs] = entp_initial(Xinit, R, numA, numB);
clc;

%% New data stream
k = 1;
for t=1:TT
    idx = repmat({':'}, 1, length(dims));
    idx(end) = {1:tao+t};
    XtAll = X(idx{:});
    XtMask = true(size(XtAll));

    idx(end) = {tao+t};
    XtMask(idx{:}) = false;

    counts = cellfun(@(x) size(x, 1), Bs);
    idxTuple = arrayfun(@(c) 1:c, counts, 'UniformOutput', false);
    [idxGrids{1:numB}] = ndgrid(idxTuple{:});
    idxBs = arrayfun(@(i) cellfun(@(x) x(i), idxGrids), (1:numel(idxGrids{1}))', 'UniformOutput', false);

    F = zeros(1, R);
    G = zeros(R, R);

    for i=1:length(idxBs)
        currIdxs = idxBs{i};
        idx(numA+1:numA+numB) = num2cell(currIdxs);

        Xcurr = X(idx{:});

        if i==1
            Cnew = zeros(1,R);
        end

        if i==1 && nnz(Xcurr)/numel(Xcurr)>(1-sparsityThres)
            Cnew = C(end,:);
        end

        if nnz(Xcurr)/numel(Xcurr)>(1-sparsityThres)
            prevBs = getMatRows(Bs, currIdxs);
            estXprev = double(full(ktensor([As; prevBs(:); {Cnew}])));
            fitPred(k) = 1-(norm(tensor(Xcurr)-tensor(estXprev))/norm(tensor(Xcurr)));
        else
            fitPred(k) = 0;
        end

        tic;
        if nnz(Xcurr)/numel(Xcurr)>(1-sparsityThres)
            [As, Bs, Cnew, Ps, Qs, Us, tmpVs, F, G] = entp_update(Xcurr, As, Bs, Ps, Qs, Us, Vs, F, G, currIdxs, lambda);
            runtime = toc;

            currBs = getMatRows(Bs, currIdxs);
            estXcurr = double(full(ktensor([As; currBs(:); {Cnew}])));
            fitRT(k) = 1-(norm(tensor(Xcurr)-tensor(estXcurr))/norm(tensor(Xcurr)));
        else
            runtime = toc;

            fitRT(k) = 0;
        end
        time(k) = runtime;

        fprintf('[Update # %d] Accumulative Result \n', k)
        fprintf('Avg. running time: %d \n', mean(time))
        fprintf('Avg. real-time fitness: %d \n', mean(fitRT,"omitnan"))
        fprintf('Avg. prediction fitness: %d \n', mean(fitPred,"omitnan"))

        k = k+1;
    end

    C = [C; Cnew];
    Vs = tmpVs;
end

% We only measure the overall fitness once at the end in this demo.
% This is due to the huge time consumption.
fitOA = 1-(norm(tensor(X)-tensor(double(full(ktensor([As; Bs; C])))))/norm(tensor(X)));
fprintf('Final overall fitness: %d \n', fitOA)
