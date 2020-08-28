%20130625
%use data_struct.id as subject_list, so need to use a cell array
%20140801, added extra name
function [data_2d, label] = ITC_export_data_of_interest_cell(data,time_of_interest,...
    frequency_of_interest,cond_names,type,subject_list,permutation,extra_name)

if nargin == 6
    permutation = 'y';
    extra_name = '';
end

if nargin == 7
    extra_name = '';
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
    new_size= nf*nt*nc;
else
    new_size = nt*nc;
end


data_2d = zeros(ns,new_size);

m = 0;
label = cell(1,new_size);

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

d = dataset({data_2d,label{:}},'obsnames',subject_list);
%[exported_filename,pathname] = uiputfile('*.txt','save the exported data as: ');
%export(d,'file',[pathname exported_filename]);
exported_filename = ['export_' type extra_name '.txt'];
export(d,'file',exported_filename);

end

function temp = convert_frequency(f)
    temp = num2str(f);
    temp2 = find(temp=='.',1);
    if ~isempty(temp2)
        temp(temp2)='p';
    end
end