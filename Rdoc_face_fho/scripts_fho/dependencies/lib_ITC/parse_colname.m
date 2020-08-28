%work with 4p5Hz etc 20121107

function [frequency, time_start,time_end,type] = parse_colname(colname)

    temp = find(colname=='_');
    pos1 = temp(1);
    pos2 = find(colname=='z');
    pos3 = temp(2);
    pos4 = length(colname)-2;
    type = colname(1:temp-1);
    frequency_temp = colname(pos1+1:pos2-2);
    l = length(frequency_temp);
    if l > 1
        if strcmp(frequency_temp(l-1),'p') == 1
            frequency = str2double(frequency_temp(1):frequency_temp(l-2)) + 0.5;
        end
    else
        frequency = str2double(frequency_temp);
    end
    
    time_start = str2double(colname(pos2+1:pos3-1));
    time_end = str2double(colname(pos3+1:pos4));
end