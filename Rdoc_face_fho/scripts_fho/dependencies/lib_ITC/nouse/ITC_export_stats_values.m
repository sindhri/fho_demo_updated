%export the p and t values after posthoc tests to text files
%before this step, the values were exported by R
%in the very beginning, ITC/ERSP values were expoted in a similar way
%but with more complicated colnames and longer time period

function ITC_export_stats_values(data,times,freqs,category_names)