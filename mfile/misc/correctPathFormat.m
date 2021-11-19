function path_std = correctPathFormat(path_orig)
% this function eliminates the evil back slash in Windows path names.
% Replacing them in window's path names doesn't affect MATLAB scripts.

if isunix
    path_std = path_orig;
else
    path_std = strrep(path_orig,'\','/');
end

end
