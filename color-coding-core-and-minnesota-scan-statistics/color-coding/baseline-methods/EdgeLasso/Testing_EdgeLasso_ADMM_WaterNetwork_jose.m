clear all
close all
files = dir('/home/jcadena/pcst-color-coding/data/water-data/WaterData/source_12500_without_noise/*.txt');
format short g
index=1;
result={}
for file =files'
    %csv = load(file);
    fprintf('%s\n',file.name)
    % Do some stuff
    filepath=strcat('/home/jcadena/pcst-color-coding/data/water-data/WaterData/source_12500_without_noise/',file.name)
    [pre,recall,fmeasure,acc,computingTime,bjscore]=APDM_EdgeLasso_ADMM(filepath, 0.5);
    result{index}(1)=str2double(num2str(pre,'%1.6f'));
    result{index}(2)=str2double(num2str(recall, '%1.6f'));
    result{index}(3)=str2double(num2str(acc, '%1.6f'));
    result{index}(4)=str2double(num2str(fmeasure,'%1.6f'));
    result{index}(5)=str2double(num2str(bjscore,'%1.6f'));
    result{index}(6)=str2double(num2str(computingTime,'%1.6f'));
    savePath=strcat('result/','EdgeLasso_source_12500_result.txt')
    fileID=fopen(savePath,'a')
    fprintf(fileID,'%1.6f %1.6f %1.6f %1.6f %1.6f %1.6f %s \n',result{index}(1),result{index}(2),result{index}(3),result{index}(4),result{index}(5),result{index}(6),file.name);
    fclose(fileID);
    index=index+1;
end

clear all
close all
files = dir('/home/jcadena/pcst-color-coding/data/water-data/WaterData/source_5420_without_noise/*.txt');
format short g
index=1;
result={}
for file =files'
    %csv = load(file);
    fprintf('%s\n',file.name)
    % Do some stuff
    filepath=strcat('/home/jcadena/pcst-color-coding/data/water-data/WaterData/source_5420_without_noise/',file.name)
    [pre,recall,fmeasure,acc,computingTime,bjscore]=APDM_EdgeLasso_ADMM(filepath, 0.5);
    result{index}(1)=str2double(num2str(pre,'%1.6f'));
    result{index}(2)=str2double(num2str(recall, '%1.6f'));
    result{index}(3)=str2double(num2str(acc, '%1.6f'));
    result{index}(4)=str2double(num2str(fmeasure,'%1.6f'));
    result{index}(5)=str2double(num2str(bjscore,'%1.6f'));
    result{index}(6)=str2double(num2str(computingTime,'%1.6f'));
    savePath=strcat('result/','EdgeLasso_source_5420_result.txt')
    fileID=fopen(savePath,'a')
    fprintf(fileID,'%1.6f %1.6f %1.6f %1.6f %1.6f %1.6f %s \n',result{index}(1),result{index}(2),result{index}(3),result{index}(4),result{index}(5),result{index}(6),file.name);
    fclose(fileID);
    index=index+1;
end

clear all
close all
files = dir('/home/jcadena/pcst-color-coding/data/water-data/WaterData/source_5421_without_noise/*.txt');
format short g
index=1;
result={}
for file =files'
    %csv = load(file);
    fprintf('%s\n',file.name)
    % Do some stuff
    filepath=strcat('/home/jcadena/pcst-color-coding/data/water-data/WaterData/source_5421_without_noise/',file.name)
    [pre,recall,fmeasure,acc,computingTime,bjscore]=APDM_EdgeLasso_ADMM(filepath, 0.5);
    result{index}(1)=str2double(num2str(pre,'%1.6f'));
    result{index}(2)=str2double(num2str(recall, '%1.6f'));
    result{index}(3)=str2double(num2str(acc, '%1.6f'));
    result{index}(4)=str2double(num2str(fmeasure,'%1.6f'));
    result{index}(5)=str2double(num2str(bjscore,'%1.6f'));
    result{index}(6)=str2double(num2str(computingTime,'%1.6f'));
    savePath=strcat('result/','EdgeLasso_source_5421_result.txt')
    fileID=fopen(savePath,'a')
    fprintf(fileID,'%1.6f %1.6f %1.6f %1.6f %1.6f %1.6f %s \n',result{index}(1),result{index}(2),result{index}(3),result{index}(4),result{index}(5),result{index}(6),file.name);
    fclose(fileID);
    index=index+1;
end
