function signal = gen_gauss_signal(num,sigma,interval,dx)

coeff=1/sqrt(2*pi*(sigma^2));
center=interval;
comp=[];
for x=dx:dx:(interval*2)
    comp = [comp, coeff*exp(-double(x-center)^2/(2*double(sigma^2)))];
end

signal=[];
for n=1:num 
    signal = [signal comp];
end