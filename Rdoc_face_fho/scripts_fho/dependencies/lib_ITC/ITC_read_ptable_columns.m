function [p_all, frequency, time_start, ...
    time_end, category_names,type]=ITC_read_ptable_columns(filename)
    
    if nargin==0
        filename = uigetfile('.txt','choose the p table file you want to convert');
    end
    t = dataset('file',filename,'delimiter','\t');
    
    colnames = get(t,'VarNames');
    n_data_columns = length(colnames)-1;
    category_names = t.(colnames{1}); 
    n_category = length(category_names); 
    %"cond","age","sex","cond*age","cond*sex",
    %"age*sex","cond*age*sex", 
    
    p_all = zeros(n_category,n_data_columns);

    frequency = 0;
    time_start = 0;
    time_end = 0;
    
    for i = 1:n_data_columns
        colname = colnames{i+1};
        [frequency(i),time_start(i),time_end(i),type]=parse_colname(colname);
        p_all(:,i) = t.(colname);
    end
end