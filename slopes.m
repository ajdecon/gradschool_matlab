function [res,ftmode] = slopes(signal)

for n=1:size(signal,2)
    ft(:,n)=fft(signal(:,n));
end

for k=1:floor(size(ft,1)/2)
    ftmode(:,k)=transpose(log(abs(ft(k,:))));
end

for k=1:size(ftmode,2)
    p=polyfit([1:size(ftmode,1)], transpose(ftmode(:,k)),1);
    res(k)=p(1);
end