%input time range, [400,800]
%input chan range, [11,12,5,6]
%output the correlation of specific oscillation (obtained from prepare data for fullhead map)

function result = ITC_calculate_cor_in_time_chan(ALLEEG, time, chan, questionniare)

time_index = find_valid_pos(time, ALLEEG(1).times);
for i = 1:length(ALLEEG)
    data = mean(mean(ALLEEG(i).data(chan,time_index(1):time_index(2),:),1),2);
    [r,p] = corrcoef(data,questionniare);
    result.r(i) = r(1,2);
    result.p(i) = p(1,2);
    fprintf('time %d to %d ms, cond %d, p is %.3f\n',time(1),time(2),i,p(1,2));
end
end



function [items_pos, items_adjusted] = find_valid_pos(items,list)
    n = length(list);
    items_pos = round( (items-list(1))/(list(n)-list(1)) * (n-1))+1;
    items_pos(find(items_pos<1))=1;
    items_pos(find(items_pos>n))=n;
    items_adjusted = list(items_pos);
    
    for i = 1:size(items,1)
        for j = 1:size(items,2)
            if items(i,j)~=items_adjusted(i,j)
                fprintf('time %d adjusted to %d\n', items(i,j),items_adjusted(i,j));
            end
        end
    end
end