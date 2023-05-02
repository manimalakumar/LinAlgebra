function [U Bi V] = Bidiag_Francis_Step_Update_U_V(U, V, Bi)
%copy Bidaig_Francis_Step here
%Francis step to chase the bulge to diagonalize matrix called from implicit_bidaig_QR_SVD
%10.3.5.1 %10.3.6
[m, n] = size(Bi);
disp("entering fran upd with m n");
disp(size(Bi));
%if(m~=n)  
%   return; %this code works for initial call from implicit_bidiag_qr_svd. then odd matrix
%end
assert( m~=n, 'only square diagonal matrix taken as input' );
%G1 w T's elements 
t00 = Bi(1,1) * Bi(1,1);
t10 = Bi(1,2) * Bi(1,1);
%tm1m1 = ( Bi(m-1,m) * Bi(m-1,m) ) * ( Bi(m,m) * Bi(m,m));
tm1m1 = ( Bi(m-1,n) * Bi(m-1,n) ) * ( Bi(m,n) * Bi(m,n));
G = eye(2);
if m==n
    for j =1:m-1
        if j == 1
            G = Givens_rotation( [ t00 - tm1m1;t10 ]);    
        else 
            G= Givens_rotation([Bi(j,j);Bi(j+1,j)]);       
        end 
        Bi(j:j+1, j:m) = G' * Bi(j:j+1, j:m); 
        Bi(1:j+1, j:j+1) = Bi(1:j+1, j:j+1) * G;
        U(1:j+1, j:j+1) = U(1:j+1, j:j+1) * G;  
        V(j:j+1, j:m) = G' * V(j:j+1, j:m);  
    end

disp("bi fran upd sz of u bi v");
disp(size(U));
disp(size(Bi));
disp(size(V));
end
end

%Calculate Givens rotation 2 x 2
function G = Givens_rotation( x ) 
    %Compute Givens rotation G so that G' * x = || x ||_2 % e_0        
    [ m, n ] = size( x );    
    assert( m==2 && n==1, 'x must be 2 x 1' );
    normx = norm( x );        
    gamma = x(1) / normx;
    sigma = x(2) / normx;  
    h = NaN;
    if(isequaln(gamma, h) >= 1)
        gamma = 0.00000000001;
    end
    if(isequaln(sigma, h) >=1 )
        sigma = 0.00000000001;
    end
    G = [ (gamma) (-sigma)
          (sigma)  (gamma) ]; 
end

