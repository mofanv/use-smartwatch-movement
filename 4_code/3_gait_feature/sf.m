function y=sf(x)
px=abs(fft(x,32768));
subplot(111)
%plot(px)
fs=100;
[b,i]=sort(px,'descend');
y=(i(1)-1)*fs/32768;
end