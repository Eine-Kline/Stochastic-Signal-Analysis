clear all;close all;clc
 %% ��ʼ������
n = 5;
K = 3;      % ���׸�˹���ģ��   
N = 5000;    % ����������
P1 = 0.3;   % P1 + P2 + P3 = 1;(��ʵ�ĸ��ʷֲ�)
P2 = 0.3;
P3 = 0.4;
u = [1,4,8];    % ��˹�ֲ��ľ�ֵ
b = [0.3,1,2];

% �����ϸ�˹����
VV1 = (randn(1,N)) * b(1) + u(1);
VV2 = (randn(1,N)) * b(2) + u(2);
VV3 = (randn(1,N)) * b(3) + u(3);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
for ii = 1 : N
    aa = rand;
    if aa < P1
        VV(ii) = VV1(ii);
    elseif aa > (1 - P3)
        VV(ii) = VV3(ii);    
    else 
        VV(ii) = VV2(ii);
    end
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
figure;
[f,xi] =  ksdensity(VV);
plot(xi ,f); % �����еĵ㻭����
% ��������
w0 = randn(n,1);
XX = randn(n, N);
YY = w0' * XX + VV;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% ��ʼ����alphak
Alphak(1) = 0.5;        
Alphak(2) = 0.25;  
Alphak(3) = 0.25;
% ��ʼ��ֵ
uu(1) = 1;      
uu(2) = 3;
uu(3) = 5;
% ��ʼ����
bb(1) = 1;             
bb(2) = 3;
bb(3) = 4;
w_em = randn(n, 1);
mu = 0.5;

%% ���е�������
for Iter = 1 : 200       % �����Ĵ���Ϊ20��
    uuu = zeros(1, K); %% mean value 
    bbb = zeros(1, K); %% variance value
    Nk  = zeros(1, K);
    if Iter >= 150
        mu = 0.001;
    end
    for ii = 1 : N
        xi = XX(:, ii);
        yi = YY(:, ii);
        ei(ii) = yi - w_em'* xi;
        for k = 1 : K 
            Pz(ii,k) = Alphak(k)*(1/(sqrt(2*pi)*bb(k))*exp(-(ei(:,ii)-uu(k))^2/(2*bb(k)^2)));    
        end
        Pz(ii, :) = Pz(ii, :) / (sum(Pz(ii, :)) + eps);
        Nk = Nk + Pz(ii, :);
        for k = 1 : K
            uuu(:, k) = uuu(:, k) + Pz(ii, k) * ei(:, ii);
            bbb(:, k) = bbb(:, k) + Pz(ii, k) * (norm(ei(:, ii) - uu(k))^2);
        end
        %% update: w_em
        en = 0;
        for k = 1 : K
            en = en + Pz(ii,k)*(ei(:, ii) - uu(k)) * xi;
        end
        if ii >= 1000
            mu = 0.0001;
        end
        w_em = w_em + mu * en;
        EE(ii,:) = w_em;
    end
    %% uu, bb,Alphak: update;
    Alphak = Nk / N;
    uu = uuu./Nk;
    bb = sqrt(bbb./Nk);
    Err_EM(Iter) = norm(w0 - w_em);
    BB(Iter,:) = bb;
end
% �г�EM������ֵ
Alphak
uu
bb
figure();
plot((Err_EM));
legend('ERR EM')
figure();
plot(BB);
