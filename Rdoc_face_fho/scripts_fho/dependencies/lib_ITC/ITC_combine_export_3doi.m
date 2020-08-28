function doi =  ITC_combine_export_3doi(doi1,doi2,doi3)
    if strcmp(doi1.id{1},doi2.id{1})~=1 || strcmp(doi1.id{1},doi3.id{1})~=1
        fprintf('different subject list, cannot combine.Abort!\n');
        doi=[];
        return
    end
    doi.data_2d = [doi1.data_2d doi2.data_2d doi3.data_2d];
    doi.id = doi1.id;
    doi.label = doi1.label;
    n = length(doi1.label);
    for i = 1:length(doi2.label)
        doi.label(n+i,1) = doi2.label(i,1);
    end
    n = length(doi1.label) + length(doi2.label);
    for i = 1:length(doi3.label)
        doi.label(n+i,1) = doi3.label(i,1);
    end
    
    d = dataset({doi.data_2d,doi.label{:}},'obsnames',doi.id);
    export(d,'file','export.txt');

end