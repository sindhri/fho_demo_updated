
%data structure has changed, 
%now the input structure is freq x time x channel x condition x subj

%20171108 modify it so that it works from the whole frequency dataset ever
%then shrink it to just one frequency, keep freq x time x chan x cond,
%stefon's pipeline

function data_ave = ITC_fullhead_get_one_freq(IE_struct)



end



function doi = get_doi(IE_struct,poi,result_type,chan_cluster)

times = IE_struct.times;
freqs = IE_struct.freqs;
cond_names = IE_struct.category_names;
nc = length(cond_names);
subject_list = IE_struct.id;

%need to change, no frequency dimension
data = IE_struct.(IE_struct.oscillation_type);
[nfreqs,ntimes,nchan,ncond,nsubj] = size(data);
data2 = zeros(nfreqs,ntimes,ncond,nsubj);
data2(:,:,:,:) = data(:,:,:,1,:);
data = data2;
%now the dimension is freq x time x cond x subj. avoid using squeeze
%because if the ncond is 1, it would reduce that dimension as well

if nc==2
    data(:,:,3,:) = data(:,:,1,:)-data(:,:,2,:);
    cond_names{3} = 'diff';
end

[extra_filename,extra_label] = construct_extra_names(IE_struct.cluster.name,IE_struct.group_name);


[poi_index,poi_adjusted] = adjust_poi(poi,times,freqs);
doi = doi_get_data(data,poi_index,result_type);

doi.oscillation_type = IE_struct.oscillation_type;
doi.poi = poi;
doi.poi_adjusted = poi_adjusted;
doi.poi_index = poi_index;

doi.cond_names = cond_names;
doi.id = subject_list;
doi.extra_label = extra_label;
doi.extra_filename = extra_filename;
doi.cluster = IE_struct.cluster;
doi.group_name = IE_struct.group_name;

doi = doi_create_label_2d(doi);
if nc>1
    doi_post_ttest(doi);
end

end

%poi = [4,8,200,300;...
%4,8,400,500;]
%first two columns frequency, last two column time
function [poi_index,poi_adjusted] = adjust_poi(poi,times,freqs)

poi_adjusted = zeros(size(poi));
poi_index = zeros(size(poi));

for i = 1:size(poi,1)
    [poi_index(i,1:2),poi_adjusted(i,1:2),adjusted1] = adjust_range(poi(i,1:2),freqs);
    [poi_index(i,3:4),poi_adjusted(i,3:4),adjusted2] = adjust_range(poi(i,3:4),times);

    if adjusted1 == 1 || adjusted2 == 1
        fprintf('range of interest %d adjusted to:\n',i);
        fprintf('%.2f to %.2f Hz,%d to %d ms, \n',poi_adjusted(i,1),...
        poi_adjusted(i,2),poi_adjusted(i,3),poi_adjusted(i,4));
    end
end    
end


%internal function for adjust_poi
function [range_of_interest_index, ...
    range_of_interest_adjusted,adjusted]= adjust_range(range_of_interest,list)

range_of_interest_index = zeros(size(range_of_interest));

range_of_interest_adjusted = range_of_interest;

adjusted = 0;
for i = 1:size(range_of_interest,1) %rows
    for j = 1:size(range_of_interest,2) %columns
        target = range_of_interest(i,j);
        [index,target_adjusted] = find_index(target,list);
        range_of_interest_index(i,j)= index;
        range_of_interest_adjusted(i,j) = target_adjusted;
        if target ~= target_adjusted
            adjusted = 1;
        end
    end
end
end

%internal function for adjust_range
function [index, target_adjusted] = find_index(target, list)
index = 0;
for i = 1:length(list)-1
    diff = list(i)-target;
    if abs(list(i+1) - target) > abs(diff)
        index = i;
        target_adjusted = list(i);
        break;
    end
end
if index==0
    index = length(list);
    target_adjusted = list(length(list));
end
end

%get data for all rows of poi, getting either mean or max
%result_type is either mean or max
%doi is a struct
%doi.data is np x nc x ns
%doi.type identifies both ITC/ERSP and mean/max, for labelling purpose only 
function doi = doi_get_data(data,poi_index,result_type)

np = size(poi_index,1);
[~,~,nc,ns] = size(data);
doi.data = zeros(np,nc,ns);
doi.type = result_type;
doi.poi_index = poi_index;

for i = 1:np
    f1 = poi_index(i,1);
    f2 = poi_index(i,2);
    t1 = poi_index(i,3);
    t2 = poi_index(i,4);

    if strcmp(result_type,'mean')==1
        doi_temp = mean(mean(data(f1:f2,t1:t2,:,:),2),1); %data nc *ns
    else
        if strcmp(result_type,'max')==1
            doi_temp = max(max(data(f1:f2,t1:t2,:,:),[],2),[],1); %data nc *ns
        else
            fprintf('function not defined. Aborted\n');
            return
        end
    end
    doi.data(i,:,:) = doi_temp(1,1,:,:);
end
end

%create label and 2d data for all rows of poi
%IE_type is either ITC or ERSP
%result_type is either mean or max
%both types are only for labelling purpose

function doi = doi_create_label_2d(doi)

data = doi.data;
type = doi.type;
cond_names = doi.cond_names;
poi = doi.poi;
extra_label = doi.extra_label;
[np,nc,ns] = size(data);

new_size = np*nc;
data_2d = zeros(ns,new_size);

m = 0;
label_nosubject = cell(new_size,1);
%label{1} = 'Subject';

for i = 1:np
    f1 = poi(i,1);
    f2 = poi(i,2);
    t1 = poi(i,3);
    t2 = poi(i,4);

    if nc>1
        new = squeeze(data(i,:,:))'; %change into subj x cond by transpose        
    else
        new = squeeze(data(i,:,:));
    end
        for n = 1:nc
            label_nosubject{m+n,1} = strcat(extra_label, type, '_',...
            convert_frequency(f1), '_', convert_frequency(f2), 'Hz',...
            int2str(t1), '_', int2str(t2), 'ms_', cond_names{n});
            data_2d(:,m+n) = new(:,n);
        end
        
        m = m + n;
end
doi.data_2d = data_2d;
doi.label = label_nosubject;
end

%internal function
function temp = convert_frequency(f)
    temp = num2str(f);
    temp2 = find(temp=='.',1);
    if ~isempty(temp2)
        temp(temp2)='p';
    end
end


%compare all poi for the first two condition repeated measure t test
function doi_post_ttest(doi)

cond_names = doi.cond_names;
type = doi.type;
poi = doi.poi;
data = doi.data;

if strcmp(cond_names{2},'error')==1
    cond_names{2} = 'eerror';
end

fprintf([type ' ' cond_names{1} ' - ' cond_names{2} ' comparison: \n']);
np = size(poi,1);

for i = 1:np
    f1 = poi(i,1);
    f2 = poi(i,2);
    fprintf('frequency %.2f to %.2f Hz ',f1,f2);
    t1 = poi(i,3);
    t2 = poi(i,4);
    fprintf('time %d to %d ms\n',t1,t2);

    fprintf('%s\n',type);
    data1 = squeeze(data(i,:,:));
    [h,p,~,stats] = ttest(data1(1,:)',data1(2,:)');
    print_t_result(h,p,stats);
    fprintf('\n');
end
end

%export data_2d and label, added 'Subject' to label
function doi_export_2d_to_text(doi)
data_2d = doi.data_2d;
type = doi.type;
extra_filename = doi.extra_filename;

for i = 1:length(doi.label)
    label{i,1} = doi.label{i};
end

%d = dataset({data_2d,label{:}},'obsnames',doi.id);
d = dataset({data_2d,label{:}},'obsnames',doi.id);
exported_filename = ['export_' type extra_filename '.txt'];
export(d,'file',exported_filename);

end


function doi =  doi_combine_mean_max(doi_mean,doi_max)
    doi.data_2d = [doi_mean.data_2d doi_max.data_2d];
    doi.type = strcat(doi_mean.type, '_', doi_max.type);
    doi.id = doi_mean.id;
    doi.label = doi_mean.label;
    doi.extra_filename = doi_mean.extra_filename;
    n = length(doi_mean.label);
    for i = 1:length(doi_max.label)
        doi.label(n+i,1) = doi_max.label(i,1);
    end
end

function print_t_result(h,p,stats)
    if h==0
        fprintf('not significant.\n');
    else
        fprintf('significant.\n');
    end
    fprintf('t(%d)=%.3f, p=%.3f\n',stats.df,stats.tstat,p);
end