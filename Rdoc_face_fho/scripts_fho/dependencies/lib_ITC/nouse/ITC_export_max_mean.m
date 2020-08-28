%20140528, added difference for 2 condition case

%20140524
%export both max and mean
%fixed a bug about permutation
%automatically named the exported file as export_mean/max_ERSP/ITC.txt

%export more than one data_struct?

%time_of_interest = [200,350];
%frequency_of_interest = [4,7;8,12;15,30];
%data is freqs x time x cond x subj

%20121118, added permutation input
%time frequency combination,
%permutation = 'y':every combination, 
%permutation = 'n':
%just time1+freq1, time2+freq2, etc. fewer combination is the default

%20121124, added type, might break some other program
%20140801, added extra name
%20140828, export structs for mean, max and export id list, added option
%for not generating text file. y or n for 'export_text'

function [struct_mean,struct_max,all_subject] = ITC_create_doi(IE_struct,...
    poi, IE_type, export_text,extra_filename)

if nargin == 4
    extra_filename = '';
end

times = IE_struct.times;
freqs = IE_struct.freqs;
category_names = IE_struct.category;
nc = length(category_names);
all_subject = IE_struct.id;

if strcmp(IE_type,'ERSP')==1
    data = IE_struct.ERSP;
else
    if strcmp(IE_type,'ITC')==1
        data = IE_struct.ITC;
    else
        fprintf('type needs to be either ERSP or ITC. Abort\n');
        return
    end
end

if nc==2
    data(:,:,3,:) = data(:,:,1,:)-data(:,:,2,:);
    category_names{3} = 'diff';
end

doi_mean = get_doi(data,poi,times,freqs,IE_type,'mean',category_names);
doi_max = get_doi(data,poi,times,freqs,IE_type,'max',category_names);

if export_text == 'y' 
    doi_export_2d_to_text(doi_mean,subject_list,extra_filename);
    doi_export_2d_to_text(doi_max,subject_list,extra_filename);
end

end



function doi = get_doi(data,poi,times,freqs,IE_type,result_type,cond_names)
[poi_index,poi_adjusted] = adjust_poi(poi,times,freqs);
doi = doi_get_data(data,poi_index,result_type);

doi.type = strcat(IE_type, '_', doi.type); %added IE type to mean/max
doi.poi = poi;
doi.poi_adjusted = poi_adjusted;
doi.poi_index = poi_index;
doi.cond_names = cond_names;

doi = doi_create_label_2d(doi);
doi_post_ttest(doi);
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
        fprintf('%f.1 to %f.1 Hz,%d to %d ms, \n',poi_adjusted(i,1),...
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
            doi_temp = mean(mean(data(f1:f2,t1:t2,:,:),2),1); %data nc *ns
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
[np,nc,ns] = size(data);

new_size = np*nc;
data_2d = zeros(ns,new_size);

m = 0;
label_nosubject = cell(1,new_size);
%label{1} = 'Subject';

for i = 1:np
    f1 = poi(i,1);
    f2 = poi(i,2);
    t1 = poi(i,3);
    t2 = poi(i,4);

    new = squeeze(data(i,:,:))'; %change into subj x cond by transpose        
        
        for n = 1:nc
            label_nosubject{m+n} = strcab(type, '_',...
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

fprintf([type ' ' cond_names{1} ' - ' cond_names{2} 'comparison: \n']);
np = size(poi,1);

for i = 1:np
    f1 = poi(i,1);
    f2 = poi(i,2);
    fprintf('frequency %.2f to %.2f Hz',f1,f2);
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
function doi_export_2d_to_text(doi,subject_list,extra_filename)
data_2d = doi.data;
type = doi.type;

label{1} ={'Subject'};
for i = 1:length(doi.label)
    label{i+1} = doi.label{i};
end

d = dataset({data_2d,label{:}},'obsnames',subject_list);
exported_filename = ['export_' type extra_filename '.txt'];
export(d,'file',exported_filename);

end