function [ X, numA, numB ] = getData(dataset, order)

if strcmp(dataset, 'VicRoads')
    fname = './data/VolumeData_tensor.mat';
    X = load(fname).data;
    X = permute(X, [1, 3, 2]);
    X = X(:,:,1:2030);

    if order==3
        numA = 1;
        numB = 1;
    elseif order==4
        X = reshape(X, 1084, 96, 7, 290);
        numA = 1;
        numB = 2;
    end
elseif strcmp(dataset, 'PEMS')
    fname = './data/PEMS_SF.mat';
    X = load(fname).data;
    X = X(:,:,1:448);

    if order==3
        numA = 1;
        numB = 1;
    elseif order==4
        X = reshape(X, 963, 144, 7, 64);
        numA = 1;
        numB = 2;
    end
elseif strcmp(dataset, 'Electricity')
    fname = './data/Electricity.mat';
    X = load(fname).data;
    X = X(:,:,2:1093);

    if order==3
        X = reshape(X, 370, 96, 1092);
        numA = 1;
        numB = 1;
    elseif order==4
        X = reshape(X, 370, 96, 7, 156);
        numA = 1;
        numB = 2;
    end
end

end

