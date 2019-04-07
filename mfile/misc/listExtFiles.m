function file_list = listExtFiles(target_path, target_ext, varargin)
% listExtFiles lists all the files with the target_ext in the target_path
%   target_path: target paths.
%   target_ext: list of all target extensions. The extenions start with '.'
%   'recursion': if recursion = 1, search the target path recursively.
%                Default is false.
%   'keywords': if keywords is nonempty, include the files with keywords
%               included in the name. (To be implemented)

  p = inputParser;
  addParameter(p,'recursion',false);
  addParameter(p,'keywords','');
  parse(p,varargin{:});
  searchRecursively = p.Results.recursion;
  keyWords = p.Results.keywords;
  
  file_list = string([]);
  if searchRecursively
      if isfile(target_path) % base case
          [~,~,ext] = fileparts(target_path)
          if ismember(ext,target_ext) % check extension
              file_list = [target_path file_list];
          end
      else % recursive step
          for item_index = 1 : length(dir_content)
              sub_file_list = listExtFiles(dir_content(item_index),target_ext);
              file_list     = [sub_file_list file_list];
          end
      end

  else
      dir_content = dir(target_path);
      for item_index = 1 : length(dir_content)
          dir_item  = dir_content(item_index);
          [~,~,ext] = fileparts(dir_item);
          if ismember(ext,target_ext) % check extension
              file_list = [dir_item file_list];
          end
      end

end

