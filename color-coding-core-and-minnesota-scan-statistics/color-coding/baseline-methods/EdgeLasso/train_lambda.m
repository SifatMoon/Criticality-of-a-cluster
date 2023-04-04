clear all
close all
dirname='./training/'
files = dir(strcat(dirname, '*.apdm'));
format short g
index=1;
lambdas = [0.001, 0.003, 0.01, 0.03, 0.1, 0.3, 1]
best_score = 0
best_lda = 0

for i=1:length(lambdas)
    lambda=lambdas(i)
    fprintf('best lambda so far is %1.6f', best_lda)
    score = 0
    for file =files'
        %csv = load(file);
        fprintf('%s\n',file.name)
        filepath=strcat(dirname, file.name)
        %[computingTime,bjscore]=APDM_EdgeLasso_ADMM_nogt(filepath, lambda);
        [computingTime,bjscore]=APDM_EdgeLasso_ADMM_param(filepath, lambda);
        result{index}(1)=str2double(num2str(computingTime,'%1.6f'));
        result{index}(2)=str2double(num2str(bjscore,'%1.6f'));
        score = score + result{index}(2)
    end
    score = score / length(files)
    if score > best_score
        best_score = score
        best_lda = lambda
    end
end
fprintf('best score is %1.6f for lamda=%1.6f\n', best_score, best_lda)
exit;
