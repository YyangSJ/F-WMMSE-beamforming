function H = Channel(beta,phi_r,theta_r,phi_t,theta_t,lambda,d,Nt,Nr,L)
H=zeros(Nr,Nt);
for l=1:L
    H=H+sqrt(1/L)*beta(l)*PW(theta_r(l),phi_r(l),d,lambda,sqrt(Nr),sqrt(Nr))*PW(theta_t(l),phi_t(l),d,lambda,sqrt(Nt),sqrt(Nt))';
end

end

