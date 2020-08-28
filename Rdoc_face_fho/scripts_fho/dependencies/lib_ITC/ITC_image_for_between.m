%average the condition first before using the function
%data should be: times x freqs x subj
function ITC_image_for_between(times, freqs, data, between,cond_names)

    n = 1;
    data_plot = zeros(size(data,1),size(data,2),1);

    while(n<=max(between))
        data_plot(:,:,n) = mean(data(:,:,between == n),3);
        n = n + 1;
    end
    n = n - 1;

    limit = [min(min(min(data_plot))),max(max(max(data_plot)))];
    diff_limit = find_diff_limit(data_plot);

    for i = 1:n-1
        ITC_images_for_2cond(times, freqs, data_plot(:,:,[i,i+1]),... 
            {cond_names{i},cond_names{i+1}},limit, diff_limit);
    end

    if n-2>=1
        for i = 1:n-2
            ITC_images_for_2cond(times, freqs, data_plot(:,:,[i,i+2]),...
                {cond_names{i},cond_names{i+2}},limit, diff_limit);
        end
    end
end

%find the limit of difference on the last dimension, 3rd
function diff_limit = find_diff_limit(data)
    d = size(data,3);
    data_min = [];
    data_max = [];
    
    for i = 1:d-1
        temp = squeeze(data(:,:,i) - data(:,:,i+1));
        if isempty(data_min)
            data_min = min(min(temp));
        else
            data_min = min(min(min(temp)),data_min);
        end
        
        if isempty(data_max)
            data_max = max(max(temp));
        else
            data_max = max(max(max(temp)),data_max);
        end
    end
    
    if d>2
        for i = 1:d-2
            temp = squeeze(data(:,:,i) - data(:,:,i+1));
            if isempty(data_min)
                data_min = min(min(temp));
            else
                data_min = min(min(min(temp)),data_min);
            end

            if isempty(data_max)
                data_max = max(max(temp));
            else
                data_max = max(max(max(temp)),data_max);
            end
        end
    end
    diff_limit = [data_min, data_max];
end