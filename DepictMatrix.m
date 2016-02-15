function DepictMatrix(Matrix, XLabelCell, YLabelCell)

n = length(Matrix(:, 1));
m = length(Matrix(1, :));

imagesc(Matrix);
textStrings = num2str(Matrix(:),'%0.3f');  %# Create strings from the matrix values
textStrings = strtrim(cellstr(textStrings));  %# Remove any space padding

[x,y] = meshgrid(1:m, 1:n);   %# Create x and y coordinates for the strings
hStrings = text(x(:),y(:),textStrings(:),'HorizontalAlignment','center');
midValue = mean(get(gca,'CLim'));

textColors = repmat(Matrix(:) < midValue,1,3);

set(hStrings,{'Color'},num2cell(textColors,2)); 

set(gca,'XTick',1:m,...
        'XTickLabel', XLabelCell,...
        'YTick',1:n,...
        'YTickLabel', YLabelCell,...
        'TickLength',[0 0]...
        );
    
end