function doi = ITC_combine_export_2doi_add_case(doi1,doi2)
    if length(doi1.label) ~= length(doi2.label)
        fprintf('label length mismatch, abort\n');
    end
    
    doi = doi1;
    n1 = length(doi1.id);
    n2 = length(doi2.id);
   doi.data_2d = [doi1.data_2d; doi2.data_2d];
   for i = 1:n2
       doi.id{n1+i} = doi2.id{i};
   end
   
   d = dataset({doi.data_2d,doi.label{:}},'obsnames',doi.id);
    export(d,'file','export.txt');

end