%20180412
%1, first number
%2, anything until the first dot
%3, TS id is either H with a number, or everything before the second dot.
%4, anything before the second '_'
%5, first and second number combined as id, leigh data

%20180424, added in find_id removed treating i as number

function [id, session] = ITC_find_id(id_type, filename)

   switch id_type
        case 1 
            [id,session] = find_id(filename);
        case 2
            [id,session] = find_id2(filename);
        case 3
            [id,session] = find_id_TS(filename);
        case 4
            [id,session] = find_id4(filename);
        case 5
            [id,session] = find_id5(filename);
    end

end

%first number
function [id,session] = find_id(filename) 
    first = [];
    last = [];
    for i = 1:length(filename)
        if filename(i) == 'i';
            continue;
        end

        if ~isempty(str2num(filename(i))) && isempty(first)
            first = i;
            break
        end
    end
    for i = first+1:length(filename)
        if filename(i) == 'i';
            continue;
        end
        if isempty(str2num(filename(i))) && isempty(last)
            last = i-1;
            break
        end
    end
    id = filename(first:last);
    session = '1';
end

%first number and second number both serve as id
function [id_combined,session] = find_id5(filename) 
    first = [];
    last = [];
    for i = 1:length(filename)
        if filename(i) == 'i';
            continue;
        end
        if ~isempty(str2num(filename(i))) && isempty(first)
            first = i;
            break
        end
    end
    for i = first+1:length(filename)
        if filename(i) == 'i';
            continue;
        end
        if isempty(str2num(filename(i))) && isempty(last)
            last = i-1;
            break
        end
    end
    id = filename(first:last);
    
    filename = filename(last+2:length(filename));

    first = [];
    last = [];
    for i = 1:length(filename)
        if filename(i) == 'i';
            continue;
        end
        if ~isempty(str2num(filename(i))) && isempty(first)
            first = i;
            break
        end
    end
    for i = first+1:length(filename)
        if filename(i) == 'i';
            continue;
        end
        if isempty(str2num(filename(i))) && isempty(last)
            last = i-1;
            break
        end
    end
    id2 = filename(first:last);
    
    id_combined = [id '_' id2];
    session = '1';
end



%id is the digits before the first dot(.), 
%Works for TRP after replacing . with _
%does not work with stripped filename without any dot
%or filename with condition name in it

function [id,session]=find_id2(filename)
    dots = find(filename=='.');
    id = filename(1:dots(1)-1);
    session = '1';
end

%anything before the second '_'
%not working with original filename without two underscores
function [id,session]=find_id4(filename)
    underscores = find(filename=='_');
    id = filename(1:underscores(2)-1);
    session = '1';
end

%id is either H with a number, or everything before the second dot.
function [id,session]=find_id_TS(filename)
    if filename(3)=='H'
        id = find_id(filename);
        id = strcat('RDH',id);
        session = '1';
    else
        dots = find(filename=='.');
        id = filename(1:dots(1)-1);
        session = filename(dots(1)+1:dots(2)-1);
    end
end
