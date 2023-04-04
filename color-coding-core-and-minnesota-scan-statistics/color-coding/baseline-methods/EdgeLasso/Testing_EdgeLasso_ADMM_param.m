clear all
close all
dirname='../../data/northeastern-satscan/6three02-param-APDM/'
files = dir(strcat(dirname, '*.apdm'));
format short g
index=1;
result={}
% lambdas
% neast 1
% traffic 0.001
% twitter 0.03
lambda = 1

for file =files'
    %csv = load(file);
    fprintf('%s\n',file.name)
    filepath=strcat(dirname, file.name)
    [computingTime,bjscore]=APDM_EdgeLasso_ADMM_param(filepath, lambda);
    result{index}(2)=str2double(num2str(computingTime,'%1.6f'));
    result{index}(1)=str2double(num2str(bjscore,'%1.6f'));
    savePath=strcat('result/','EdgeLasso_neast-param.txt')
    fileID=fopen(savePath,'a')
    fprintf(fileID,'%s,%1.6f,%1.6f\n',file.name,result{index}(1),result{index}(2));
    fclose(fileID);
    index=index+1;
end
exit;
