function apm = APM(theta,phi,x,z,lambda,L)
for l=1:L
apm(l)=exp(-1i*2*pi/lambda*(theta(l)*z+phi(l)*x));
end
end

