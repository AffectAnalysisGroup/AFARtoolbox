function myWriteVideo(vo,img)
    [fpath,fname,ext] = fileparts(vo);
    if isunix & ext == '.mp4'
        vo = fullfile(fpath,fname,'.avi');
    end
    writeVideo(vo,img);
end



