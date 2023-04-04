function [A]=Svp(A, lambda, p)
A(A > lambda / p) = A(A > lambda / p) - lambda / p;
A(abs(A) < lambda / p) = 0;
A(abs(A) < -1 * lambda / p) = A(abs(A) < -1 * lambda / p) + lambda/p;
Svp =  A;
end 
