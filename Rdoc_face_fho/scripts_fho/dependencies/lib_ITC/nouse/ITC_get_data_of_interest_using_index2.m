
function [data_of_interest_mean,data_of_interest_max] = ITC_get_data_of_interest_using_index2(data, ...
    index_time_of_interest, index_frequency_of_interest)

n_time_of_interest = size(index_time_of_interest,1);
n_frequency_of_interest = size(index_frequency_of_interest,1);
data_of_interest_mean = zeros(n_frequency_of_interest,n_time_of_interest,...
    size(data,3),size(data,4));
data_of_interest_max = zeros(n_frequency_of_interest,n_time_of_interest,...
    size(data,3),size(data,4));


for i = 1:n_time_of_interest
    t1 = index_time_of_interest(i,1);
    t2 = index_time_of_interest(i,2);
    if t1==0 && t2 == 0
        continue;
    end
    for j = 1:n_frequency_of_interest
        f1 = index_frequency_of_interest(j,1);
        f2 = index_frequency_of_interest(j,2);
        if f1==0 && f2==0
            continue;
        end
        data_of_interest_mean(j,i,:,:) = mean(mean(data(f1:f2,t1:t2,:,:),2),1);
        data_of_interest_max(j,i,:,:) = max(max(data(f1:f2,t1:t2,:,:),[],2),[],1);
    end
end

end