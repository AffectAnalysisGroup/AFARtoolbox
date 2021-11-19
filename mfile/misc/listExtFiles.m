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
          dir_content = dir(target_path);
          for item_index = 1 : length(dir_content)
              dir_item = dir_content(item_index);
              full_path_fname = fullfile(dir_item.folder,dir_item.name);
              if ismember(dir_item.name,["." ".."]) 
                  continue
              end
              sub_file_list = listExtFiles(full_path_fname,target_ext);
              file_list     = [sub_file_list file_list];
          end
      end

  else
      dir_content = dir(target_path);
      for item_index = 1 : length(dir_content)
          dir_item  = dir_content(item_index);
          if dir_item.isdir % if the item is a dir, pass
              continue
          end
          [~,~,ext] = fileparts(dir_item.name);
          if ismember(ext,target_ext) % check extension
              full_path_fname = fullfile(dir_item.folder,dir_item.name);
              file_list = [full_path_fname file_list];
          end
      end

end

