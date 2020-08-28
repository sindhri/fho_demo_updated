%20130707
%input a 2-dimention data and label
%export a text file

function ITC_export_to_text_using_dataset(data_2d, label)

d = dataset({data_2d,label{:}});
[exported_filename,pathname] = uiputfile('*.txt','save the exported data as: ');
export(d,'file',[pathname exported_filename]);