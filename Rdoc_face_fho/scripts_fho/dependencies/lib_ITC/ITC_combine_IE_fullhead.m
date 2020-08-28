%add more subjects
%20180424, combine oscillation from the bomb project, full head
%so one more dimension

function IE = ITC_combine_IE_fullhead(IE1, IE2)
    [nfreq1,ntimes1,nchan1,ncond1,nsubj1] = size(IE1.ERSP); %nfreq x ntimes x nchan x ncond x nsubj
    [nfreq2,ntimes2,nchan2,ncond2,nsubj2] = size(IE2.ERSP);
    
    if nfreq1 ~=nfreq2
        fprintf('number of frequency no match, %d in IE1, vs %d in IE2, abort\n,',nfreq1,nfreq2);
        IE = [];
        return
    end

    if ntimes1 ~=ntimes2
        fprintf('number of time no match, %d in IE1, vs %d in IE2, abort\n,',ntimes1,ntimes2);
        IE = [];
        return
        end

    if nchan1 ~=nchan2
        fprintf('number of channel no match, %d in IE1, vs %d in IE2, abort\n,',nchan1,nchan2);
        IE = [];
        return
        end

    if ncond1 ~=ncond2
        fprintf('number of condition no match, %d in IE1, vs %d in IE2, abort\n,',ncond1,ncond2);
        IE = [];
        return
    end

    for i = 1:ncond1
        if ~strcmp(IE1.category_names{i},IE2.category_names{i})
            fprintf('condition names do not match, %s in 1 and %s in 2, abort.\n',...
                IE1.category_names{i}, IE2.category_names{i});
            IE = [];
            return
        end
    end
    IE = IE1;
    
    fprintf('working ......\n');
    for i = nsubj1+1:nsubj1+nsubj2
        fprintf('adding %d out of %d additional subjects......',i-nsubj1,nsubj2);
        IE.ERSP(:,:,:,:,i) = IE2.ERSP(:,:,:,:,i-nsubj1);
        IE.ITC(:,:,:,:,i) = IE2.ITC(:,:,:,:,i-nsubj1);
        IE.id{i} = IE2.id{i-nsubj1};
        fprintf('finished.\n');
    end
    
    if isfield(IE,'running_record');
       IE = rmfield(IE,'running_record');
    end

end