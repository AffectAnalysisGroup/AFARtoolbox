function printWrite(msg,fid)
    if fid > 0  % valid fid
        fprintf(fid,msg);
    else
        fprintf(msg);
    end
end
