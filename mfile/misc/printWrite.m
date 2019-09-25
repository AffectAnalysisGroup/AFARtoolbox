function printWrite(msg,fid)
    % Windows' path has '\' which can cause issue in fprintf
    if fid > 0  % valid fid
        fprintf(fid,msg);
    else
        fprintf(msg);
    end
end
