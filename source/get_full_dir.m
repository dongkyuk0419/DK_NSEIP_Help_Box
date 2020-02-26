function [fullpathlist] = get_full_dir(subject_DIR)
%GET_FULL_DIR This function returns all Path Names
%   usage: fullpathlist = get_full_dir(subject_DIR);
%       fullpathlist{1} = returns the first day, first session
    fullpathlist = {};
    folder = dir(subject_DIR);
    counter = 1;
    for i = 1:length(folder)
        if folder(i).name(1) == '1' || folder(i).name(1) == '2'
            subfolder = dir(fullfile(folder(i).folder,folder(i).name));
            for ii = 1:length(subfolder)
                if subfolder(ii).name(1) == '0'
                    fullpathlist{counter} = fullfile(subfolder(ii).folder,subfolder(ii).name);
                    counter = counter + 1;
                end
            end
        end
    end
    fullpathlist = fullpathlist.';
end

