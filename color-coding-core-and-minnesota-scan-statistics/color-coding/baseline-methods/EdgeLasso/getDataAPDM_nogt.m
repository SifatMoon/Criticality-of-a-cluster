function [ pvalue,A,Xv,B,I,label] = getDataAPDM_nogt( path,threshold)
%GETDATA Summary of this function goes here
%   Detailed explanation goes here
%N=12527;
[p_value,edges,label]=APDM_Reader_nogt(path);
Xm=abs(p_value);
pvalue=p_value;
N=length(Xm);
I=speye(N);
Xv=zeros(N,1);

for z=1:length(Xm)
     if Xm(z)<threshold
         Xv(z)=1;        
     end
 end

A=sparse(N,N);
[temp,edgeN]=size(edges);
for i=1:edgeN
    x=edges{i}(1);
    y=edges{i}(2);
    A(x+1,y+1)=1;
    A(y+1,x+1)=1;
end

% B=|E|*|V| Matrix
fprintf('edgeN : %d, N : %d',edgeN,N);
%B=sparse(zeros(edgeN,N));
B=sparse(edgeN,N);
trA=triu(A);
[x,y]=find(trA');
edgeIndex={};

%get edge indices 
for q=1:length(x)
    edgeIndex{q}=[y(q),x(q)];
end

% generate B matrix
for w=1:length(edgeIndex)
    ep=rand(1);
    if ep>0.5
        ep=1;
    else 
        ep=-1;
    end
    em=-ep;
    B(w,edgeIndex{w}(1))=ep;
    B(w,edgeIndex{w}(2))=em;
end

fprintf('number of true abnormal nodes : %d\n',sum(Xv));
end

