file = fopen('CSVNAMEHERE.csv', 'w');

for a=1:size(CELLVARIABLE,1)
    for b=1:size(CELLVARIABLE,2)
        var = eval('CELLVARIABLE{a,b}');
        try
            fprintf(file, '%s', var);
        end
        fprintf(file, ',');
    end
    fprintf(file, '\n');
end

fclose(file);
clear;