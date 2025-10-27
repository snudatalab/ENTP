function [ currs, prevs ] = getMatRows(mats, currIdxs)

currs = [];
prevs = [];
for i=1:length(mats)
    currs{i} = mats{i}(currIdxs(i),:);
    prevs{i} = mats{i}(1:currIdxs(i)-1,:);
end

end
