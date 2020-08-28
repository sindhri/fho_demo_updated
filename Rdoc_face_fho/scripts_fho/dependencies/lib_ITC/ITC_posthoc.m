%currently only written for within_level=2, between_level=3
%need major change to fit other models
%20121031, added between variable file
%20121108, added interaction
%20121109, added ts
%20130306, added ds

function [posthoc,freqs,times]= ITC_posthoc(n_level_within,n_level_between,...
    filename1,filename2,filename3)

    if nargin==2
        filename1 = uigetfile('.txt','select the file with post FDR p values');
        filename2 = uigetfile('.txt','select the file with original values');
        filename3 = uigetfile('.txt','select the between variable file');
    end
    
    
    criterion = 0.05;
    has_interaction = 0;
        
    original_cond_names = {'pre_nowin';'pre_win'};
    between_variable_name_in_between_file = {'Age_group'};

    category_between = {'age'};
    category_within = {'cond'};
    category_interaction = {'age:cond'};
    
    category_within_levels = {'Nowin';'Win'};
    category_between_levels = {'Young';'Middle';'Old'};
    category_within_comparisons = construct_comparisons(category_within_levels);
    category_between_comparisons = construct_comparisons(category_between_levels);
        

    fprintf('p value file is %s. \noriginal data file is %s\nbetween variable file is %s\n',...
    filename1,filename2,filename3);
    
    %read data
    %file with rowname can be directly read as dataset
    %otherwise use importdata, then build dataset
    A = importdata(filename2);
    dataset_values = dataset({A.data,A.colheaders{:}});
    datasetp = dataset('file',filename1,'delimiter','\t');
    colnames = get(datasetp,'VarNames');
    B = importdata(filename3);
    between = dataset({B.data,B.colheaders{:}});
    
    [~, frequency_rep, time_rep, ...
    ~, category_names,type]=ITC_read_ptable_columns(filename1);
    
    freqs = unique(frequency_rep);
    times = unique(time_rep);
    
    comparison_within = nchoosek(n_level_within,2);
    p_posthoc_within = ones(length(freqs),length(times),...
        comparison_within);
    t_posthoc_within = zeros(length(freqs),length(times),...
        comparison_within);
    d_posthoc_within = zeros(length(freqs),length(times),...
        comparison_within);
   
    comparison_between =  nchoosek(n_level_between,2);
    p_posthoc_between = ones(length(freqs),length(times),...
       comparison_between);
    t_posthoc_between = zeros(length(freqs),length(times),...
       comparison_between);
    d_posthoc_between = zeros(length(freqs),length(times),...
       comparison_between);
   
    comparison_interaction = n_level_between * comparison_within + n_level_within * comparison_between;
    p_posthoc_interaction = ones(length(freqs),length(times),...
        comparison_interaction);
    t_posthoc_interaction = zeros(length(freqs),length(times),...
        comparison_interaction);
    d_posthoc_interaction = zeros(length(freqs),length(times),...
        comparison_interaction);
    
    
    n_category = length(category_names);
    %"cond","age","sex","cond*age","cond*sex",
    %"age*sex","cond*age*sex", 
        
    for i = 1:n_category

        category = category_names{i};
        fprintf('\n\n************************************\n');
        fprintf('searching %s for significance....\n',category);
        for j = 2:length(colnames)
            colname = colnames{j};
            [frequency, time,~,~] = parse_colname(colname);
            frequency_position = find(freqs==frequency,1);
            time_position = find(times == time,1);
            p = datasetp.(colname)(i);
            if p < criterion
                if i==3
    %                pause;
                end
                fprintf('significance found in %s effect %s\n',...
                    category,colname);
                colnames_in_original = {[original_cond_names{1} '_' colname],...
                    [original_cond_names{2} '_' colname]};
                data = [dataset_values.(colnames_in_original{1}) ,...
                    dataset_values.(colnames_in_original{2})];
                fprintf('retrieve data from %s and %s', ...
                    colnames_in_original{1},colnames_in_original{2});
                if ~isempty(data)
                    fprintf(' succeed.\n');
                else
                    fprintf(' failed, abort\n');
                    return
                end
                between_variable_value = between.(between_variable_name_in_between_file{1});
                index = find_in_cell(category_between,category);
                if index == 0
                    index = find_in_cell(category_within,category);
                    if index == 0
                        index = find_in_cell(category_interaction,category);
                        if index == 0
                            fprintf('category name %s not in variable list,',category);
                            fprintf('check program\n');
                        else %interaction
                             has_interaction = 1;
                             [ps,ts,ds,category_interaction_comparisons] = do_interaction_posthoc(data,...
                                between_variable_value,category_within_levels,...
                                category_between_levels);
                            p_posthoc_interaction(frequency_position,time_position,:) = ps;
                            t_posthoc_interaction(frequency_position,time_position,:) = ts;
                            d_posthoc_interaction(frequency_position,time_position,:) = ds;
                        end
                    else %within
                        [ps,ts,ds] = do_within_posthoc(data,category_within_levels);
                        p_posthoc_within(frequency_position,time_position,:)=ps;
                        t_posthoc_within(frequency_position,time_position,:)=ts;
                        d_posthoc_within(frequency_position,time_position,:)=ds;
                    end
                else %between
                    [ps,ts,ds] = do_between_posthoc(data,between_variable_value,...
                        category_between_levels);
                    p_posthoc_between(frequency_position,time_position,:)=ps;
                    t_posthoc_between(frequency_position,time_position,:)=ts;
                    d_posthoc_between(frequency_position,time_position,:)=ds;
                end
                fprintf('\n')
            end
        end
    end
    
    posthoc.within_names = category_within_comparisons;
    posthoc.within_t = t_posthoc_within;
    posthoc.within_p = p_posthoc_within;
    posthoc.within_d = d_posthoc_within;

    posthoc.between_names = category_between_comparisons;
    posthoc.between_t = t_posthoc_between;
    posthoc.between_p = p_posthoc_between;
    posthoc.between_d = d_posthoc_between;

    if has_interaction == 1
        posthoc.interaction_names = category_interaction_comparisons;
        posthoc.interaction_t = t_posthoc_interaction;
        posthoc.interaction_p = p_posthoc_interaction;
        posthoc.interaction_d = d_posthoc_interaction;
    end
    
    posthoc.type = type;

end

function index = find_in_cell(list, target)
    index = 0;
    for i = 1:length(list)
        if strcmp(target, list{i}) == 1
            index = i;
            break;
        end
    end
end

function [ps,ts,ds] = do_within_posthoc(data,category_within_levels)
    [category_within_comparisons,selection] = construct_comparisons(category_within_levels);
    n=size(selection,1);
    ps=zeros(n,1);
    ts=zeros(n,1);
    ds=zeros(n,1);
    for i = 1:n
        c1 = selection(i,1);
        c2 = selection(i,2);
        data1 = data(:,c1);
        data2 = data(:,c2);
        [h,ps(i),~,stats] = ttest(data1,data2);
        d = calculate_effect_size(data1,data2,1);
        fprintf([category_within_comparisons{1} '   ']);
        print_t_result(h,ps(i),stats);
        ts(i) = stats.tstat;
        ds(i) = d;
    end
end

function [ps,ts,ds] = do_between_posthoc(data,between,category_between_levels)
    data = mean(data,2);
    [category_between_comparisons,selection] = construct_comparisons(category_between_levels);
    n=size(selection,1);
    ps = zeros(n,1);
    ts = zeros(n,1);
    ds = zeros(n,1);
    for i = 1:n
        c1 = selection(i,1);
        c2 = selection(i,2);
        data1 = data(between==c1);
        data2 = data(between==c2);
        [h,ps(i),~,stats] = ttest2(data1,data2);
        d = calculate_effect_size(data1,data2,2);
        fprintf([category_between_comparisons{i} '   ']);
        print_t_result(h,ps(i),stats);
        ts(i) = stats.tstat;
        ds(i) = d;
    end
end


function [ps,ts,ds,names] = do_interaction_posthoc(data,between,...
    category_within_levels,category_between_levels)
        within_l = category_within_levels;
        between_l = category_between_levels;
        [within_c,within_s] = construct_comparisons(within_l);
        [between_c,between_s] = construct_comparisons(between_l);
        n_interact_c = size(within_l,1)*size(between_c,1) + size(within_c,1)*size(between_l,1);
        
        ps = zeros(n_interact_c,1);
        ts = zeros(n_interact_c,1);
        ds = zeros(n_interact_c,1);
        names = cell(n_interact_c,1);
        fprintf('\nt tests on within variables in different between variable groups\n');
        for i = 1:size(between_l,1)
            for j = 1:size(within_c,1)
                position = (i-1)*size(within_c,1) + j;
                c1 = within_s(j,1);
                c2 = within_s(j,2);
                names{position} = [between_l{i} ':' within_c{j}];
                fprintf(['at ' names{position} '\n']);
                data1 = data(between==i,c1);
                data2 = data(between==i,c2);
                [h,ps(position,1),~,stats] = ttest(data1,data2);
                d = calculate_effect_size(data1,data2,1);
                print_t_result(h,ps(position,1),stats);
                ts(position,1) = stats.tstat;
                ds(position,1) = d;
            end
        end
        n = position;
        fprintf('t tests on bewteen variables in different within variables\n');

        for i = 1:size(within_l,1)   
            for j = 1:size(between_c,1)
                position = (i-1)*size(between_c,1)+j;

                c1 = between_s(j,1);
                c2 = between_s(j,2);
                data1 = data(between==c1,i);
                data2 = data(between==c2,i);
                [h,ps(n+position),~,stats] = ttest2(data1,data2);
                d = calculate_effect_size(data1,data2,2);
                names{n+position} = [within_l{i} ':' between_c{j}];
                fprintf(['at ' names{n+position} '\n']);
                ts(n+position) = stats.tstat;
                ds(n+position) = d;
                print_t_result(h,ps(n+position),stats);
            end
       end
            
 
end

%input young, middle, old
%output young-middle, middle-old, old-young
function [comparison_names,selection] = construct_comparisons(category_names)

    switch int2str(size(category_names,1))
        case '2'
            selection = [1,2];
        case '3'
            selection = [1,2;2,3;1,3];
        otherwise
            selection = [];
            comparison_names = '';
            fprintf('not implemented\n');
            return
    end
    
    n = size(selection,1);
    comparison_names = cell(n,1);
    for i = 1:n
        c1 = selection(i,1);
        c2 = selection(i,2);
        comparison_names{i} = [category_names{c1} '-' category_names{c2}];
    end
end

%type1, paird sample t test
%type2, independent t test
function d = calculate_effect_size(data1,data2,type)
    if type ==2
        x1 = mean(data1);
        x2 = mean(data2);
        s1 = std(data1);
        s2 = std(data2);
        n1 = length(data1);
        n2 = length(data2);
        s = sqrt((s1^2*(n1-1)+s2^2*(n2-1))/(n1+n2-2));
        d = (x1-x2)/s;
    else
        if type==1
            diff = data1-data2;
            d = mean(diff)/std(diff);
        end
    end
end
