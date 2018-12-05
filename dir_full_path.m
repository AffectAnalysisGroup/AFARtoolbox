function full_path = dir_full_path(folder_name)
	if ~isfolder(folder_name)
		error('Given folder_name is not valid.\n');
	end
	folder_info = what(folder_name);
	full_path   = folder_info.path;
end