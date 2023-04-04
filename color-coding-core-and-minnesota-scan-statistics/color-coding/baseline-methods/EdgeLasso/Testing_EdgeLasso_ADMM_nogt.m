clear all
close all
dirname='../../data/citHepPh/'
files = dir(strcat(dirname, '*.txt'));
format short g
index=1;
result={}
% lambdas
% neast 0.001
% traffic 0.001
lambda = 0.001

for file =files'
    %csv = load(file);
    fprintf('%s\n',file.name)
    filepath=strcat(dirname, file.name)
    [computingTime,bjscore]=APDM_EdgeLasso_ADMM_nogt(filepath, lambda);
    result{index}(2)=str2double(num2str(computingTime,'%1.6f'));
    result{index}(1)=str2double(num2str(bjscore,'%1.6f'));
    savePath=strcat('result/','EdgeLasso_citHepPh.txt')
    fileID=fopen(savePath,'a')
    fprintf(fileID,'%s,%1.6f,%1.6f\n',file.name,result{index}(1),result{index}(2));
    fclose(fileID);
    index=index+1;
end
exit;
