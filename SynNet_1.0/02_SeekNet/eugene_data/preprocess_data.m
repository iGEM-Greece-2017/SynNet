clear;
load('MDA-231/MDA231-raw_counts.mat');
%inmiR=  innerjoin(miRprofileparental, miRprofilespheroid,...
%                  'Keys',{'miRseq','miR'});
outmiR= outerjoin(miRprofileparental, miRprofilespheroid,...
                  'Keys',{'miRseq','miR'},'MergeKeys',true);

% Add MCF-7 to the sample
load('MCF-7/MCF7-raw_counts.mat');
outmiR.Properties.VariableNames{2}= 'expr_par_MDA231';
outmiR.Properties.VariableNames{4}= 'expr_sph_MDA231';
outmiR= outerjoin(outmiR, miRprofilespheroid,...
                  'Keys',{'miRseq','miR'},'MergeKeys',true);
outmiR= outerjoin(miRprofileparental, outmiR,...
                  'Keys',{'miRseq','miR'},'MergeKeys',true);
outmiR.Properties.VariableNames{2}= 'expr_par_MCF7';
outmiR.Properties.VariableNames{6}= 'expr_sph_MCF7';
% Normalize NaN -> 1
outmiR{isnan(outmiR{:,'expr_par_MDA231'}), 'expr_par_MDA231'}= 1;
outmiR{isnan(outmiR{:,'expr_sph_MDA231'}), 'expr_sph_MDA231'}= 1;
outmiR{isnan(outmiR{:,'expr_par_MCF7'}), 'expr_par_MCF7'}= 1;
outmiR{isnan(outmiR{:,'expr_sph_MCF7'}), 'expr_sph_MCF7'}= 1;

% which miRs aren't included in each case?
% mirkey_s= miRprofilespheroid.miRseq + miRprofilespheroid.miR;
% mirkey_p= miRprofileparental.miRseq + miRprofileparental.miR;
% p_nots= setdiff(mirkey_p,mirkey_s);
% s_notp= setdiff(mirkey_s,mirkey_p);
% p_nots= unique(regexprep(p_nots,'^.*mir','mir'));
% s_notp= unique(regexprep(s_notp,'^.*mir','mir'));

% save results
save('MDA231_MCF7-preprocessed_counts.mat','outmiR');

%% Format data for SynNet
mircounts_synnet= table(outmiR.miRseq + outmiR.miR, outmiR.expr_par_MCF7, outmiR.expr_sph_MCF7,...
    outmiR.expr_par_MDA231, outmiR.expr_sph_MDA231,...
    'VariableNames',{'UniqueID', 'parental_MCF7', 'spheroid_MCF7',...
                     'parental_MDA231','spheroid_MDA231'});
annot_synnet= table({'parental_MCF7';'spheroid_MCF7';
                     'parental_MDA231';'spheroid_MDA231'},[0;1;0;1],...
    'VariableNames',{'UniqueID','AnnotationID'});
 
writetable(mircounts_synnet,'mircounts-MDA231_MCF7.csv','Delimiter','\t');
writetable(annot_synnet,'annot-MDA231_MCF7.csv','Delimiter','\t');