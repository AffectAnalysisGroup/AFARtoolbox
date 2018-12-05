function [Tr] = CalcSimT(src,dst)
    n = size(src,1);
    H = zeros(4,4);
    g = zeros(4,1);
    p = zeros(4,1);
   
    H(1,1) = sum(sum(src.^2));
    H(1,3) = sum(src(:,1));
    H(1,4) = sum(src(:,2));
    
    g(1,1) = sum(sum(src .* dst));
    g(2,1) = sum(src(:,1) .* dst(:,2) - src(:,2) .* dst(:,1));
    g(3,1) = sum(dst(:,1));
    g(4,1) = sum(dst(:,2));

    H(2,2) = H(1,1); 
    H(4,1) = H(1,4);
    H(2,3) = -H(4,1);
    H(3,2) = -H(4,1);
    
    H(3,1) = H(1,3); 
    H(2,4) = H(1,3);
    H(4,2) = H(1,3);
    
    H(4,4) = n;
    H(3,3) = n;
    
   p = linsolve(H,g);
%     p = pinv(H)*g;
    Tr.a = p(1,1); 
    Tr.b = p(2,1); 
    Tr.tx = p(3,1); 
    Tr.ty = p(4,1);         
end