function [computingTime,bjscore] = APDM_EdgeLasso_ADMM_nogt(filename,lda)
startTime=tic;
%x : 1XN is p-value array
%B : |E|XN edge matrix P800 last paragraph
%I : NXN identity maxtrix 
%label : true subset nodes
parameter_1 = 0.15;
[p_value,A,x,B,I,label]=getDataAPDM_nogt(filename,parameter_1);
x_hat = x;
p = 1;
alphaMax = 0.15;
s = size(B);
y = zeros(s(1),1);
size(B);
size(x_hat);
z = B*x_hat;
error = 10000;
x_hat_prev = x;
p = 1;
p_max=10;
lambda=lda;
iter1 = 1;
threshold=0.2
while error > 0.1 && iter1 < 500
    % temp=norm(X-X_hat,2)+lambda(i)*norm(B*X_hat);
    x_hat=(I + p*B'*B)\(x + p*B'*z - B'*y);
    %x_hat
    z = Svp(B*x_hat + y/p,lambda, p);
    y = y + p*(B*x_hat - z); %equation
	if iter1>10
        error = sum(abs(x_hat_prev - x_hat));
    end
    %error = sum(abs(x_hat_prev - x_hat));
	p=min(p_max,1.1*p);
    iter1 = iter1 + 1;
    x_hat_prev = x_hat;
    %error
    sum(abs(B * x_hat));
end
fprintf('Finished in %d iterations \n',iter1);        
Md=x_hat;
Vl=[];
N=length(x_hat);
for q=1:N
    if Md(q) > threshold
         Vl=[Vl q];
    end
 end
 none_zero=sum(Md);
nl=length(Vl);
Vm=zeros(nl);
for p=1:nl
    for w=1:nl
         Vm(p,w)=A(Vl(p),Vl(w));
    end
end
[nC,s,mem]=networkComponents(Vm);
Sl={} ;
for p=1:length(mem)
     ls=mem{p};
     for r=1:length(ls)
         Sl{p}(r)=Vl(ls(r));
     end
 end
[S_star]=CostF(Sl);
sort(S_star);
bjscore = berkJones(S_star,p_value,alphaMax); 
%bjscore = 0
%for i=1:length(S_star)
%    bjscore = bjscore + p_value(S_star(i))
%bjscore = bjscore / sqrt(length(S_star))
computingTime=toc(startTime);
end

