function g_s = PW(theta,phi,lambda,pos_x,pos_z)
for m=1:length(pos_x)
    for n=1:length(pos_z) 

         r_s(n,m)=-pos_z(n)*theta-pos_x(m)*phi;   
        G_s(n,m)=exp(-1i*2*pi/lambda*(r_s(n,m))); 
    end
end
g_s=G_s(:);
end

