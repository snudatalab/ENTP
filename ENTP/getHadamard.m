function [ H ] = getHadamard(mats, method)

if strcmp(method, 'gram')
    for i=1:length(mats)
        mats{i} = mats{i}'*mats{i};
    end
else
    assert(strcmp(method, 'direct'), 'Method Not supported.')
end

H = mats{1};
for i=2:length(mats)
    H = H.*mats{i};
end

end

