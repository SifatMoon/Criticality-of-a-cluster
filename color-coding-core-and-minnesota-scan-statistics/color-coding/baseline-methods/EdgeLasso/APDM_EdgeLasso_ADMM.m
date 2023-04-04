function [pre,rec,fmeasure,acc,computingTime,bjscore] = APDM_EdgeLasso_ADMM(filename,threshold)
startTime=tic;
%x : 1XN is p-value array
%B : |E|XN edge matrix P800 last paragraph
%I : NXN identity maxtrix 
%label : true subset nodes
parameter_1 = 0.5;
[p_value,A,x,B,I,label]=getDataAPDM(filename,parameter_1);
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
lambda=0.25;
iter1 = 1;
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
computingTime=toc(startTime);
inters=intersect(S_star,label);
uni=union(S_star,label);
pre=length(inters)/length(S_star);
rec=length(inters)/length(label);
acc=length(inters)/length(union);
fmeasure=2*( pre*rec/(pre+rec) );
if pre < 1e-6 && rec < 1e-6
    fmeasure = 0.0 ;
end
fprintf('Intersect len: %d ; Actual_in len: %d ; result len: %d\n',length(inters),length(label),length(S_star));
fprintf('precision: %f ; recall: %f ; fmeasure: %f ; accuracy: %f ; bjscore: %f\n',pre,rec,fmeasure,acc,bjscore);
end

