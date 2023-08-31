nBlocks = 10;
r = 1;
t = 8;
EbdB = 10.1;
Eb = 10^(EbdB/10);
No = 1;
SNR = 2*Eb/No;
SNRdB = 10*log10(Eb/No);
Lp = 2000;
mu = [0.001,0.0005,0.0003];
MSE_Online = zeros(length(mu),Lp);
for kx = 1:length(mu)
    for blk=1:1:nBlocks
        h = 1/sqrt(2)*(randn(t,1)+1j*randn(t,1));
        noise= sqrt(No/2)*(randn(Lp,1)+1j*randn(Lp,1));
        PilotI = randi([0,1],[Lp,t]);
        PilotQ = randi([0,1],[Lp,t]);
        Pilot = (2*PilotI-1)+1j*(2*PilotQ-1);
        hest = zeros(t,1)+1j*zeros(t,1);
        Xp =sqrt(Eb)*Pilot;
        Yp = Xp*h + noise;
        for px = 1:Lp
            e = Yp(px) - Xp(px,:)*hest;
            hest = hest + mu(kx)*e*Xp(px,:)';
            MSE_Online(kx,px) = MSE_Online(kx,px) + norm(h-hest)^2;
        end

    end
end


MSE_Online = MSE_Online/nBlocks;

semilogy([1:Lp], MSE_Online(1,:),'g-','linewidth',3.0);
hold on
semilogy([1:Lp], MSE_Online(2,:),'r-.','linewidth',3.0);
semilogy([1:Lp], MSE_Online(3,:),'b--','linewidth',3.0);
axis tight;
grid on;
title('MSE for Online Multi-antenna Channel Learning');
legend('\mu=0.001','\mu=0.0005','\mu=0.0003','Location','NorthEast');
xlabel('SNR (dB)')
ylabel('MSE')
