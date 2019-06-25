function csv2mat(filepathname)
   if  nargin == 0
       [fname, pname] = uigetfile('.csv');
       filepathname = [pname, fname];
   end
   [pname, fname, ~] = fileparts(filepathname);
    oldpath = cd;
    data = csvread(filepathname);
    
    eval([fname '=' 'data;']);
    cd(pname);
    savename = [fname '.mat'];
    save(savename,fname);
    
    delete(filepathname);
    cd(oldpath);
end