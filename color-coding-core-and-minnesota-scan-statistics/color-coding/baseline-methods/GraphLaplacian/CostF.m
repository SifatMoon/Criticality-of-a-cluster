function [ S_star ] = CostF( Sl)
%COSTF Summary of this function goes here
%   Detailed explanation goes here
sSize=length(Sl);
S_star=[];
maxS=0;
for i=1:sSize
    ls=Sl{1,i};
    tempS=length(ls);
    %fprintf('\nls--');disp(ls);
    %fprintf('Size:%d',tempS);
    if tempS > maxS
        maxS=tempS;
        S_star=ls;
    end
end

end

