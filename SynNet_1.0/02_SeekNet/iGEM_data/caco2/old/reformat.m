% If there's both a starred and an unstarred version, the unstarred becomes "*-5p" and the starred "*-3p"
% If only the starred version, it also becomes "*-3p"
mirname= miRdatacontrols{:,1};
for i= 1:length(starnames)
  j= find(strcmp(mirname,starnames(i))); jstar= find(strcmp(mirname,join([starnames(i),"*"],'')));
  mirname(j)= join([starnames(i),"-5p"],'');
  mirname(jstar)= join([starnames(i),"-3p"],'');
end
