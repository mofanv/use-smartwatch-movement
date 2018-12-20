function [symmetry] = ac_gait_symmetry(dat_left, dat_right)

lenL = length(dat_left);
lenR = length(dat_right);
if lenL > lenR
    idx = 0.5*(lenL-lenR);
    dat_left = dat_left(idx:(idx+lenR-1),1);
elseif lenL < lenR
    idx = 0.5*(lenR-lenL);
    dat_right = dat_right(idx:(idx+lenL-1),1);
end
    [autocorx,lags] = xcorr(dat_left,dat_right,'coeff');
    [peakarx,localarx,w,p] = findpeaks(autocorx);
    peakarx = sort(peakarx);
    symmetry = peakarx(length(peakarx)-1);
end