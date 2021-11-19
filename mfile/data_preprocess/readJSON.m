json_fname = './aDBS002_10_17_prov.JSON';
fid = fopen(json_fname);
raw = fread(fid,inf);
str = char(raw');
fclose(fid);
val = jsondecode(str);
rating_final_time = [];


