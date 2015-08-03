function [unsatFlag, CP] = processDrealOutput ()

% a(1,1) = zeros(1,1);
% b(1,1) = zeros(1,1);
% c(1,1) = zeros(1,1);

unsatFlag = 0;
fid = fopen ('output');

%flag = 0;
tline = fgetl(fid);
while ischar(tline)
    if (strcmp(tline, 'unsat'))
         unsatFlag = 1;
         break;
    end
    tline = fgetl(fid);
end
fclose (fid);


if (unsatFlag == 0)
    fid = fopen ('output');
    tline = fgetl(fid);
    while ischar(tline)
        %disp '22222222'
        %fprintf('(%s)\n', tline);
        n1 = regexp(tline, ' ');
        var = tline(3 : n1 - 1);
        val = tline(n1+1: length(tline) - 2);
        
        n2 = regexp(var, '[0-9]+');
        index = str2num(var(n2 : length(var)));
        var = var(1 : n2 - 1);
        
        n3 = regexp(val, '/');
        if (length(n3) ~= 0)
            val1 = val(4: length(val - 1));
            n4 = regexp(val1, ' ');
            val = str2num(val1(1 : n4-1)) / str2num(val1(n4+1:length(val1)-1));
        else
            val = str2num(val);
        end
        
        if (strcmp(var, 'x') || strcmp(var, 'y'))
            if (strcmp(var, 'x'))
                CP(index + 1).x = val;
            end
            if (strcmp(var, 'y'))
                CP(index + 1).y = val;
            end
        end
        
        tline = fgetl(fid);
    end
    fclose (fid);
else
    CP = struct([]);
end

%CP
%unsatFlag
end