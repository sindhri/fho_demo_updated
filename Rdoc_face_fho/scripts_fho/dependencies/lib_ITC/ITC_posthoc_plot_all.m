function ITC_posthoc_plot_all(posthoc,times,freqs,has_interaction)    

if nargin == 3
    has_interaction = 1;
end

ITC_posthoc_plot(posthoc.within_t,posthoc.within_p,posthoc.within_d,...
    posthoc.within_names,times,freqs,posthoc.type);
ITC_posthoc_plot(posthoc.between_t,posthoc.between_p,posthoc.between_d,...
    posthoc.between_names,times,freqs,posthoc.type);

if has_interaction ==1
    ITC_posthoc_plot(posthoc.interaction_t,posthoc.interaction_p,posthoc.interaction_d,...
    posthoc.interaction_names(1:3),times,freqs,posthoc.type);    
end