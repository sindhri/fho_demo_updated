%use index ib to limite cases in s
function s2 = ITC_limit_case(s,ib)
    
    
    names = fieldnames(s);
    for i = 1:length(names)
        temp = s.(names{i});
        s2.(names{i})= temp(ib);
    end

end