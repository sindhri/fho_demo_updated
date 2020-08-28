%data_4d format, freqs x times x cond x subj
%followed stPCA_procedure_data_4d

%baseline is always half of the data, based on the eeglab ITC calculation

%20130128, updated baseline, sometimes it's not half of the data
%baseline needs to be in terms of datapoint

function [FactorResults_tpca, ...
    FactorResults_stpca] = ITC_stpca(data_4d,n_tpca, n_spca,baseline)


%step 1: stacking data, converting 4d data to 3d
data_3d = data_stacking(data_4d);

%step 2: remove baseline for preparing PCA. at the 2nd dimension
ndatapoint = size(data_4d,2);
if nargin==3
    baseline = ndatapoint/2;
end
data_blr = data_3d(:,baseline+1:ndatapoint,:);

%step4: temporal PCA
nFactor = n_tpca;
FactorResults_tpca = ep_doPCA('temp','PMAX',3,'COV',nFactor,data_blr,'K');

%step5: spatial PCA
nFactor = n_spca;
%FactorResults_stpca = ep_doPCAst(FactorResults_tpca,...
%    'IMAX',1,'COV',nFactor,'K');

%update based on the new ep_pca function
FactorResults_stpca = ep_doPCAst(FactorResults_tpca,...
    'IMAX',1,'COV',nFactor,'K','spat');
