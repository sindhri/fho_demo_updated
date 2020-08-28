%need to think about how to add group info there
%20150608
function doi =  ITC_combine_export_2doi(doi1,doi2)
    if strcmp(doi1.id{1},doi2.id{1})~=1
        fprintf('different subject list, cannot combine.Abort!\n');
        doi=[];
        return
    end
    doi.data_2d = [doi1.data_2d doi2.data_2d];
    doi.id = doi1.id;
    doi.label = doi1.label;
    n = length(doi1.label);
    for i = 1:length(doi2.label)
        doi.label(n+i,1) = doi2.label(i,1);
    end
    
    d = dataset({doi.data_2d,doi.label{:}},'obsnames',doi.id);
    export(d,'file','export.txt');

end