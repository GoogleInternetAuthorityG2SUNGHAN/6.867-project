words = importdata('text/results.txt');
labels = importdata('dow_2007.txt');

removelabel = [];

indices = [];
for i=1:length(labels.textdata)
    broken = 0;
    for j=1:length(words.textdata)
        if(strcmp(words.textdata(j), labels.textdata(i)))
            indices(end+1) = j;
            broken = 1;
            break
        end
    end
    if ~broken
        fprintf(2, 'No WSJ for %d\n', i);
        removelabel(end+1) = i;
    end
end

sparseX = sparse(words.data(indices, :));
Y = labels.data;
Y(removelabel, :) = [];

class0 = sparseX(find(Y - 1),:);
count0 = length(class0(:,1));
class0(class0 > 1) = 1;
class0 = full(sum(class0, 1))';

class1 = sparseX(find(Y + 1),:);
count1 = length(class1(:,1));
class1(class1 > 1) = 1;
class1 = full(sum(class1, 1))';

examples = cell(2);
examples{1} = create_nbtrain_struct(class0, count0);
examples{2} = create_nbtrain_struct(class1, count1);

clear words;
clear labels;