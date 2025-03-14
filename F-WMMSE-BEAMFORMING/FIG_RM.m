clear all;
close all;
rng(2024)
f=3e9; % system frequency
lambda=3e8/f; % antenna wavelength
d=lambda/2; % inter-element spacing for virtual channel representation
d_min=lambda/2; % allowed minimal inter-element spacing in practice
K=4; % number of users
Nt=16; % number of movable antennas at BS
Nr=4; %number of movable antennas at each user
D=4; % number of data streams for each user
L=5; % number of channel paths
sigma_2=1; % noise power
PP=5; % transmit power
I_max=25; % iteration number of WMMSE
realization=1000;
for reali=1:realization
    reali
    beta=normrnd(0,1,L,K)+1i*normrnd(0,1,L,K); % path gains
    phi_t=unifrnd(-1,1,L,K); % BS AOD-azimuth
    theta_t=unifrnd(-1,1,L,K); % BS AOD-elevation
    phi_r=unifrnd(-1,1,L,K); % User AOA-azimuth
    theta_r=unifrnd(-1,1,L,K); % User AOA-elevation
    pos_r_x=[0:(sqrt(Nr)-1)]*d;  %square array
    pos_r_z=[0:(sqrt(Nr)-1)]*d;
    pos_t_x=[0:(sqrt(Nt)-1)]*d;
    pos_t_z=[0:(sqrt(Nt)-1)]*d;
    H=[];
    P=10^(PP/10);
    A_R=zeros(Nr,L,K);
    A_T=zeros(Nt,L,K);
    for k=1:K
        for l=1:L
            A_R(:,l,k)= PW(theta_r(l,k),phi_r(l,k),lambda,pos_r_x,pos_r_z);
            A_T(:,l,k)= PW(theta_t(l,k),phi_t(l,k),lambda,pos_t_x,pos_t_z);
        end
        Si(:,:,k)=1/sqrt(L)*diag(beta(:,k));
        H(:,:,k)=A_R(:,:,k)*Si(:,:,k)*A_T(:,:,k)';
        % H(:,:,k)=Channel(beta(:,k),phi_r(:,k),theta_r(:,k),phi_t(:,k),theta_t(:,k),lambda,d,Nt,Nr,L);
    end
    %% MMSE

    HK=zeros(K*Nr,Nt);
    for k=1:K
        HK((k-1)*Nr+1:k*Nr,:)=H(:,:,k);
    end
    F=HK'*inv(HK*HK'+1*eye(Nr*K));
    for k=1:K
        W(:,:,k)=inv(1/P*trace(F*F')*eye(Nr)+H(:,:,k)*F*F'*H(:,:,k)')*H(:,:,k)*F(:,(k-1)*D+1:k*D);
    end

    F=sqrt(P/trace(F*F'))*F;
    sumrate_mmse=0;
    for k=1:K
        Interference=zeros(Nr,Nr);
        for j=1:K
            if j~=k
                Interference=Interference+ H(:,:,k)*F(:,(j-1)*D+1:j*D)*F(:,(j-1)*D+1:j*D)'*H(:,:,k)';
            end
        end
        sumrate_mmse=sumrate_mmse+ log2(det(eye(Nr)+(H(:,:,k)*F(:,(k-1)*D+1:k*D)*F(:,(k-1)*D+1:k*D)'*H(:,:,k)'...
            )*inv(Interference+eye(Nr))));
    end
    sumrate_MMSE(reali)=sumrate_mmse;

    %% WMMSE
    F=randn(Nt,K*D)+1i*randn(Nt,K*D);
    F=sqrt(P/trace(F*F'))*F;
    F_temp=F;
    E=zeros(D,D,K);
    B=zeros(D,D,K);
    for iter=1:I_max

        for k=1:K
            W(:,:,k)=inv(1/P*trace(F*F')*eye(Nr)+H(:,:,k)*F*F'*H(:,:,k)')*H(:,:,k)*F(:,(k-1)*D+1:k*D);
        end
        for k=1:K
            E(:,:,k)=eye(D)-W(:,:,k)'*H(:,:,k)*F(:,(k-1)*D+1:k*D);
            B(:,:,k)=inv(E(:,:,k));
        end
        C=zeros(Nt,Nt);
        for k=1:K
            C=C+1/P*trace(W(:,:,k)*B(:,:,k)*W(:,:,k)')*eye(Nt)+H(:,:,k)'*W(:,:,k)*B(:,:,k)*W(:,:,k)'*H(:,:,k);
        end
        for k=1:K
            F(:,(k-1)*D+1:k*D)=inv(C)*(H(:,:,k)'*W(:,:,k)*B(:,:,k));
            SD(:,(k-1)*D+1:k*D)=(H(:,:,k)'*W(:,:,k)*B(:,:,k));
        end


    end
    F=sqrt(P/trace(F*F'))*F;

    sumrate1=0;
    for k=1:K
        Interference=zeros(Nr,Nr);
        for j=1:K
            if j~=k
                Interference=Interference+ H(:,:,k)*F(:,(j-1)*D+1:j*D)*F(:,(j-1)*D+1:j*D)'*H(:,:,k)';
            end
        end
        sumrate1=sumrate1+ log2(det(eye(Nr)+(H(:,:,k)*F(:,(k-1)*D+1:k*D)*F(:,(k-1)*D+1:k*D)'*H(:,:,k)'...
            )*inv(Interference+eye(Nr))));
    end
    sumrate_WMMSE(reali)=sumrate1;

    %% F-WMMSE
    G_set=2:8; GT=4;
    for gr=1:length(G_set)
        GR=G_set(gr);
        Grx=GR; Grz=Grx; Gr=Grx*Grz;
        G_R=zeros(L,Gr,K);
        Gtx=GT; Gtz=Gtx; Gt=Gtx*Gtz;
        G_T=zeros(L*K,Gt);
        PHI_R=zeros(K*D,Gr,K);
        PSI=zeros(K*D,K*L);
        B_tilde=zeros(K*D,K*D);
        for k=1:K
            fla=0;
            for gx=1:Grx
                for gz=1:Grz
                    fla=fla+1;
                    G_R(:,fla,k)=APM(theta_r(:,k),phi_r(:,k),(gx-1)*lambda/2,(gz-1)*lambda/2,lambda,L) ;
                end
            end

            fla=0;
            for gx=1:Gtx
                for gz=1:Gtz
                    fla=fla+1;
                    G_T((k-1)*L+1:k*L,fla)=APM(theta_t(:,k),phi_t(:,k),(gx-1)*lambda/2,(gz-1)*lambda/2,lambda,L) ;
                end
            end

        end
        H_eq_t=zeros(L,D*K);
        F=F_temp;
        for k=1:K
            H_eq_t((k-1)*L+1:k*L,:)=A_T(:,:,k)'*F;
        end
        E=zeros(D,D,K);
        B=zeros(D,D,K);
        Lambda_r=[];W_line=[];H_eq_r=[];
        for iter=1:I_max
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%Update W_k and q_k%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

            gamma1=1/P*trace(F*F');
            for k=1:K
                OO=zeros(K*D,D);
                OO((k-1)*D+1:k*D,:)=eye(D);
                PHI_R(:,:,k)=H_eq_t((k-1)*L+1:k*L,:)'*Si(:,:,k)'*G_R(:,:,k);
                [Lambda_r(:,k),W_line(:,:,k)]=RLS_SOMP(OO,PHI_R(:,:,k),Gr,Nr,gamma1);
                %                W_ce(:,:,k)=inv(PHI_R(:,:,k)'*PHI_R(:,:,k)+gamma1*eye(Nr))*PHI_R(:,:,k)'*OO;
                H_eq_r(:,:,k)=G_R(:,:,k)*W_line(:,:,k);

            end

            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%Update B %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

            for k=1:K
                E(:,:,k)=eye(D)-H_eq_r(:,:,k)'*Si(:,:,k)*H_eq_t((k-1)*L+1:k*L,(k-1)*D+1:k*D);
                B(:,:,k)=inv(E(:,:,k));
            end

            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%Update F and p %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

            gamma2=0;
            for k=1:K
                gamma2=gamma2+1/P*trace(W_line(:,:,k)*B(:,:,k)*W_line(:,:,k)');
                B_tilde((k-1)*D+1:k*D,(k-1)*D+1:k*D)=sqrtm(B(:,:,k));
                PSI((k-1)*D+1:k*D,(k-1)*L+1:k*L)=sqrtm(B(:,:,k))*H_eq_r(:,:,k)'*Si(:,:,k);
            end
            PHI_T=PSI*G_T;
            [Lambda_t,F_line]=RLS_SOMP(B_tilde,PHI_T,Gt,Nt,gamma2);
            % F_ce=inv(PHI_T'*PHI_T+gamma2*eye(Nt))*PHI_T'*B_tilde;


            % F_line=sqrt(P/trace(F_line*F_line'))*F_line;
            H_eq_t=G_T*F_line;
            F = F_line(any(F_line, 2), :);
            Lambda_t=sort(Lambda_t);
            z_t_ind  = mod(Lambda_t - 1, sqrt(Gt)) + 1;
            x_t_ind  = ceil(Lambda_t / sqrt(Gt));
            for k=1:K
                Lambda_r(:,k)=sort(Lambda_r(:,k));
                z_r_ind(:,k)=mod(Lambda_r(:,k) - 1, sqrt(Gr)) + 1;
                x_r_ind(:,k)=ceil(Lambda_r(:,k) / sqrt(Gr));
                for l=1:L
                    A_R_re(:,l,k)= PW2(theta_r(l,k),phi_r(l,k),lambda,(x_r_ind(:,k)-1)*d,(z_r_ind(:,k)-1)*d);
                    A_T_re(:,l,k)= PW2(theta_t(l,k),phi_t(l,k),lambda,(x_t_ind-1)*d,(z_t_ind-1)*d);
                end
                H_re(:,:,k)=A_R_re(:,:,k)*Si(:,:,k)*A_T_re(:,:,k)';
                %H_re(:,:,k)=G_R(:,Lambda_r(:,k),k)'*Si(:,:,k)*G_T((k-1)*L+1:k*L,Lambda_t);
                % H(:,:,k)=Channel(beta(:,k),phi_r(:,k),theta_r(:,k),phi_t(:,k),theta_t(:,k),lambda,d,Nt,Nr,L);
                H_Wi((k-1)*D+1:k*D,:)=sqrtm(B(:,:,k))*W_line( Lambda_r(:,k),:,k)'*H_re(:,:,k);
                GGT((k-1)*L+1:k*L,:)=A_T_re(:,:,k)';
            end


            F_ce2=inv(H_Wi'*H_Wi+gamma2*eye(Nt))*H_Wi'*B_tilde;
            H_eq_t=GGT*F_ce2;
            F = F_ce2;


        end
        F=sqrt(P/trace(F*F'))*F;

        z_t_ind  = mod(Lambda_t - 1, sqrt(Gt)) + 1;
        x_t_ind  = ceil(Lambda_t / sqrt(Gt));
        for k=1:K
            z_r_ind(:,k)=mod(Lambda_r(:,k) - 1, sqrt(Gr)) + 1;
            x_r_ind(:,k)=ceil(Lambda_r(:,k) / sqrt(Gr));
            for l=1:L
                A_R_re(:,l,k)= PW2(theta_r(l,k),phi_r(l,k),lambda,(x_r_ind(:,k)-1)*d,(z_r_ind(:,k)-1)*d);
                A_T_re(:,l,k)= PW2(theta_t(l,k),phi_t(l,k),lambda,(x_t_ind-1)*d,(z_t_ind-1)*d);
            end
            % H_re(:,:,k)=A_R_re(:,:,k)*Si(:,:,k)*A_T_re(:,:,k)';
            H_re(:,:,k)=G_R(:,Lambda_r(:,k),k)'*Si(:,:,k)*G_T((k-1)*L+1:k*L,Lambda_t);
            % H(:,:,k)=Channel(beta(:,k),phi_r(:,k),theta_r(:,k),phi_t(:,k),theta_t(:,k),lambda,d,Nt,Nr,L);
        end
        %F = F_line(any(F_line, 2), :);
        sumrate=0;
        for k=1:K
            Interference=zeros(Nr,Nr);
            for j=1:K
                if j~=k
                    Interference=Interference+ H_re(:,:,k)*F(:,(j-1)*D+1:j*D)*F(:,(j-1)*D+1:j*D)'*H_re(:,:,k)';
                end
            end
            sumrate=sumrate+ log2(det(eye(Nr)+(H_re(:,:,k)*F(:,(k-1)*D+1:k*D)*F(:,(k-1)*D+1:k*D)'*H_re(:,:,k)'...
                )*inv(Interference+eye(Nr))));
        end
        sumrate_FWMMSE(reali,gr)=sumrate;


    end
end
S_MMSE=abs(mean(sumrate_MMSE))
S_WMMSE=abs(mean(sumrate_WMMSE))
S_FWMMSE=abs(mean(sumrate_FWMMSE))
plot(PP,abs(mean(sumrate_MMSE)))
hold on
plot(PP,abs(mean(sumrate_WMMSE)))
hold on
plot(PP,abs(mean(sumrate_FWMMSE)))

