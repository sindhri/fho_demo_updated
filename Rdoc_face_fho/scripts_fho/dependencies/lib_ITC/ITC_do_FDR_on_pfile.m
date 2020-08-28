%20120821, uses dataset
%universal, but need everything that to be FDRed be on one row

function p_all_adj = ITC_do_FDR_on_pfile(filename)
    if nargin == 0
        filename = uigetfile('.txt','select the file with p values');
    end
    
    fprintf('%s\n',filename);
    %read data
    t = dataset('file',filename,'delimiter','\t');
    colnames = get(t,'VarNames');
    n_data_columns = length(colnames) - 1;    
    category_names = t.(colnames{1});
    n_category = length(category_names);
    %"cond","age","sex","cond*age","cond*sex",
    %"age*sex","cond*age*sex", 
    
    p_all = zeros(n_category,n_data_columns);
    
    for i = 1:n_data_columns
        p_all(:,i) = t.(colnames{i+1});
    end
    
    
    
    %FDR with printout
    p_all_adj = zeros(size(p_all));

    for i = 1:n_category 
        category_name = category_names{i};
        fprintf(['\n' category_name '\n']);
        p_list = p_all(i,:);
        [h,~,p_list_adj] = fdr_bh(p_list,0.05,'pdep','yes');
        p_all_adj(i,:) = p_list_adj;
        if find(h==1,1)
            fprintf('*******Significance found!****************\n');
        end            
    end
    fprintf('\n');
    
    
    
    %write new p into a new file
    p_all_adj = [zeros(n_category,1), p_all_adj];
    d = dataset({p_all_adj,colnames{:}});
    d.(colnames{1}) = t.(colnames{1});
    exported_filename = [filename(1:length(filename)-4) '_FDR.txt'];
    export(d,'file',exported_filename);
    %[exported_filename,pathname] = uiputfile('*.txt','save the post FDR data as: ');
    %export(d,'file',[pathname exported_filename]);
    
    ITC_visualization('',exported_filename);
end