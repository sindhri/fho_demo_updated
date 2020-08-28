function [data_2d, label] = ITC_export_data_of_interest(data,time_of_interest,...
    frequency_of_interest,cond_names,type,subject_list,permutation)

if nargin == 6
    permutation = 'y';
end

[nf,nt,nc,ns] = size(data);

if isempty(cond_names)
    cond_names = cell(1,nc);
    for i = 1:nc
        cond_names{i} = ['cond' int2str(i)];
    end
end

if isempty(subject_list)
    subject_list = 1:ns;
end

if permutation == 'y'
    new_size= nf*nt*nc+1;
else
    new_size = nt*nc+1;
end


data_2d = zeros(ns,new_size);
data_2d(:,1) = subject_list;

m = 1;
label = cell(1,new_size);
label{1} = 'Subject';

for i = 1:nf
    f1 = frequency_of_interest(i,1);
    f2 = frequency_of_interest(i,2);
    
    for j = 1:nt
        if permutation == 'n' && i~=j
            continue;
        end
        t1 = time_of_interest(j,1);
        t2 = time_of_interest(j,2);

        new = squeeze(data(i,j,:,:))'; %subj x cond        
        
        for n = 1:nc
            label{m+n} = [ type '_' convert_frequency(f1) '_' convert_frequency(f2) 'Hz' int2str(t1) '_' int2str(t2) 'ms_' cond_names{n} ];
            data_2d(:,m+n) = new(:,n);
        end
        
        m = m + n;
    end
end

d = dataset({data_2d,label{:}});
[exported_filename,pathname] = uiputfile('*.txt','save the exported data as: ');
export(d,'file',[pathname exported_filename]);

end

function temp = convert_frequency(f)
    temp = num2str(f);
    temp2 = find(temp=='.',1);
    if ~isempty(temp2)
        temp(temp2)='p';
    end
end