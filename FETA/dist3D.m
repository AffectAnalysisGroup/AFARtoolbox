function [ d ] = dist3D( A,B )

    d = sqrt(sum((A-B).^2,2));

end

