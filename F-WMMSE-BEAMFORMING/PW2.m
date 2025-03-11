function g_s = PW2(theta,phi,lambda,pos_x,pos_z)
for i=1:length(pos_x)
    r_s(i)=-pos_z(i)*theta-pos_x(i)*phi;
    G_s(i)=exp(-1i*2*pi/lambda*(r_s(i)));
end
g_s=G_s(:);
end

