nBlocks = 10000; 
r = 1; 
t = 8; 
L = 10;
SNRdB = 0:1:10; 
SNR = 10.^(SNRdB/10); 
No = 1; 
MSE_LS = zeros(1,length(SNRdB));

for blk = 1:nBlocks
    h = 1/sqrt(2)*(randn(t,1)+1j*randn(t,1));
    noise= sqrt(No/2)*(randn(L,1)+1j*randn(L,1));
    DFTmat = dftmtx(L);
    for K=1:length(SNRdB)
        Xp = sqrt(SNR(K))*DFTmat(:,1:t);
        Yp = Xp*h + noise;

        h_LS= pinv(Xp)*Yp;
        MSE_LS(K) = MSE_LS(K) + norm(h-h_LS)^2;
    end
end


MSE_LS = MSE_LS/nBlocks;

semilogy(SNRdB,MSE_LS,'b - s','linewidth',3.0,'MarkerFaceColor','b','MarkerSize',9.0);
hold on
axis tight;
grid on;
title('MSE for Wireless Channel Learning');
legend('LS','Location','SouthWest');
xlabel('SNR (dB)')
ylabel('MSE')
