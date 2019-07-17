fout= fopen('usedMirSeqs-caco2_miratlas.fa','w');
for i= 1:size(all_data,1)
  fprintf(fout, ">%s\n%s\n", all_data{i,'miRNAName'}, all_data{i,'Sequence'});
end
fclose(fout);
