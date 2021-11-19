function printWrite(msg,fid,varargin)
p = inputParser;
default_no_action = false;
addOptional(p,'no_action',default_no_action);
parse(p,varargin{:});
no_action = p.Results.no_action;

% Windows' path has '\' which can cause issue in fprintf
if ~no_action
    if fid > 0  % valid fid
        fprintf(fid,msg);
    else
        fprintf(msg);
    end
end

end
