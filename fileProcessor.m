function [AllData] = fileProcessor(Input_File)

AllData = [];

if isempty(Input_File)
    [FileName, FileNamePath]=uigetfile('*.csv','Select file(s)','multiselect','on');
    FileNameCellArray = strcat(FileNamePath, FileName);
    
    if (ischar(FileNameCellArray))
        HowManyFiles = 1;
        allData_struct = importdata(FileNameCellArray);
        AllData = allData_struct.data;
    else
        HowManyFiles = length(FileNameCellArray);
        for n = 1: length(FileNameCellArray)
            allData_struct = importdata(FileNameCellArray{n});
            AllData = vertcat(AllData, allData_struct.data);
        end
    end    
else
    %For char
    HowManyFiles = 1;
    allData_struct = importdata(Input_File);
    AllData = allData_struct.data;
end

end