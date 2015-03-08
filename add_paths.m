function add_paths()
    thePath = genpath(pwd);
    dirs = strsplit(thePath, ':');
    i = 1;

    while i <= length(dirs)
        git = 0;

        dir = dirs{i};
        subDirs = strsplit(dir, '/');
        for j = 1:length(subDirs)
            subDir = subDirs{j};
            if strcmp(subDir, '.git')
                git = 1;
            end
        end

        if git == 1
            dirs(i) = [];
        else
            i = i + 1;
        end
    end

    disp('Adding the following directories to the path: ');
    for i = 1:length(dirs)
        disp(dirs{i});
    end
    
    thePath = [sprintf('%s:', dirs{1:end-1}), dirs{end}];
    
    addpath(thePath);
end