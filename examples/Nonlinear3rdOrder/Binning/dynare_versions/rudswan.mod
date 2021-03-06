var V, C, L, VK, PI, Valphaexp, ZN, MC, Y, ZD, P0, W, Int, Delta, PIAVG, G, A, DZ, PISTAR, PB, PBB, YTM, YTMM, TT;

varexo EPSInt, EPSA, EPSZ, EPSG, EPSPISTAR;

parameters phi, chi, theta, eta, xi, alpha, LMax, DZBAR, YBAR, delta, KRAT, GRAT, KBAR, IBAR, GBAR, L_ss, 
    ABAR, PIBAR, rhoinflavg, taylrho, taylpi, tayly, rhoa, rhoz, rhog, rhopistar, GSSLOAD, Y_ss, MC_ss, DZ_ss,
    Beta_tilde, Beta, PI_ss, Int_ss, Delta_ss, PIAVG_ss, G_ss, A_ss, PISTAR_ss, C_ss, ZN_ss, ZD_ss, P0_ss, W_ss,
    DZZ_ss, chi0,  U_ss, V_ss, VAIMSS, VK_ss, Valphaexp_ss, PB_ss, PBB_ss, YTM_ss, YTMM_ss, TT_ss, cdelta;


phi = 2;
chi = 3;
theta = 0.2;
eta = 2/3;
xi = 0.75;
alpha = -148.3;
LMax = 1;
DZBAR = 1.0025;
YBAR = 1;
delta = 0.02;
KRAT = 2.5;
GRAT = 0.17;
KBAR = 4*YBAR*KRAT;
IBAR = delta*KBAR;
GBAR = YBAR*GRAT;
L_ss = 1/3;
ABAR = YBAR/(KBAR^(1-eta)*L_ss^eta);
PIBAR = 0;
rhoinflavg = 0;
taylrho = 0.73;
taylpi = 0.53;
tayly = 0.93;
rhoa = 0.95;
rhoz = 0;
rhog = 0.95;
rhopistar = 0;
GSSLOAD = 0;
Y_ss = 1;
MC_ss = 1/(1+theta);
DZ_ss = DZBAR;
Beta_tilde = 0.99;
Beta = Beta_tilde*DZ_ss^phi;
PI_ss = exp(PIBAR);
Int_ss = log((PI_ss/Beta)*DZ_ss^phi);
Delta_ss = 1;
PIAVG_ss = PI_ss;
G_ss = GBAR;
A_ss = ABAR;
PISTAR_ss = PIBAR;
C_ss = Y_ss - G_ss - IBAR;
ZN_ss = (1+theta)*MC_ss*Y_ss/(1-xi*Beta*DZ_ss^(-phi)*PI_ss^(eta*(1+theta)/theta));
ZD_ss = Y_ss/(1-xi*Beta*DZ_ss^(-phi)*PI_ss^(1/theta));
P0_ss = (ZN_ss/ZD_ss)^(1/(1+(1+theta)/theta*(1-eta)/eta));
W_ss = MC_ss*eta*Y_ss/L_ss;
DZZ_ss = DZ_ss;
chi0 = W_ss/((LMax - L_ss)^(-chi)/C_ss^(-phi));
U_ss = C_ss^(1-phi)/(1-phi) + chi0*(LMax - L_ss)^(1-chi)/(1-chi);
V_ss = U_ss/(1 - (Beta*DZBAR^(1-phi)));
VAIMSS = V_ss;
VK_ss = VAIMSS*DZBAR^(1-phi);
Valphaexp_ss = ((V_ss/VAIMSS))^(1-alpha);
cdelta = 0.9848;
PB_ss = 1/(1 - cdelta/exp(Int_ss));
PBB_ss = 1/(1 - cdelta/exp(Int_ss));
YTM_ss = log(cdelta*PB_ss/(PB_ss-1))*400;
YTMM_ss = log(cdelta*PBB_ss/(PBB_ss-1))*400;
TT_ss = 0;

model;
    V - C^(1-phi)/(1-phi) - chi0*(LMax - L)^(1-chi)/(1-chi) - Beta*VK;
    C^(-phi) - Beta*(exp(Int)/PI(1))*C(1)^(-phi)*DZ(1)^(-phi)*(V(1)*DZ(1)^(1-phi)/VK)^(-alpha);
    Valphaexp - ((V(1)/VAIMSS)*(DZ(1)/DZBAR)^(1-phi))^(1-alpha);
    VK - VAIMSS*DZBAR^(1-phi)*Valphaexp^(1/(1-alpha));
    ZN - (1+theta)*MC*Y - xi*Beta*(C(1)/C)^(-phi)*DZ(1)^(-phi)*(V(1)*DZ(1)^(1-phi)/VK)^(-alpha)*PI(1)^((1+theta)/theta/eta)*ZN(1);
    ZD - Y - xi*Beta*(C(1)/C)^(-phi)*DZ(1)^(-phi)*(V(1)*DZ(1)^(1-phi)/VK)^(-alpha)*PI(1)^(1/theta)*ZD(1);
    P0^(1+(1+theta)/theta*(1-eta)/eta) - ZN/ZD;
    PI^(-1/theta) - (1-xi)*(P0*PI)^(-1/theta) - xi;
    MC - W/eta*Y^((1-eta)/eta)/A^(1/eta)/KBAR^((1-eta)/eta);
    chi0*(LMax - L)^(-chi)/C^(-phi) - W;
    Y - A*KBAR^(1-eta)*L^eta/Delta;
    Delta^(1/eta) - (1-xi)*P0^(-(1+theta)/theta/eta) - xi*PI^((1+theta)/theta/eta)*Delta(-1)^(1/eta);
    C - Y + G + IBAR;
    log(PIAVG) - rhoinflavg*log(PIAVG(-1)) - (1-rhoinflavg)*log(PI);
    4*Int - (1 - taylrho)*(4*log(1/Beta*DZBAR^phi) + 4*log(PIAVG) + taylpi*(4*log(PIAVG) - PISTAR) + tayly*(Y-YBAR)/YBAR ) - taylrho*4*Int(-1) - EPSInt;

	PB - 1 - PB(1)*cdelta*Beta*(C(1)/C)^(-phi)*DZ(1)^(-phi)*(V(1)*DZ(1)^(1-phi)/VK)^(-alpha)/PI(1);
    PBB - 1 - PBB(1)*cdelta/exp(Int);
    YTM - log(cdelta*PB/(PB-1))*400;
    YTMM - log(cdelta*PBB/(PBB-1))*400;
    TT - 100*(YTM-YTMM);

	log(A/ABAR) - rhoa*log(A(-1)/ABAR) - EPSA;
    log(DZ/DZBAR) - rhoz*log(DZ(-1)/DZBAR) - EPSZ;
    log(G/GBAR) - rhog*log(G(-1)/GBAR) - EPSG;
    PISTAR - (1-rhopistar)*PIBAR + rhopistar*PISTAR(-1) - GSSLOAD*(4*log(PIAVG) - PISTAR) - EPSPISTAR;



end;

initval;

V = V_ss;
C = C_ss;
L = L_ss;
VK = VK_ss;
PI = PI_ss;
Valphaexp = Valphaexp_ss;
ZN = ZN_ss;
MC = MC_ss;
Y = Y_ss;
ZD = ZD_ss;
P0 = P0_ss;
W = W_ss;
Int = Int_ss;
Delta = Delta_ss;
PIAVG = PIAVG_ss;
G = G_ss;
A = A_ss;
DZ = DZ_ss;
PISTAR = PISTAR_ss;
PB = PB_ss;
PBB = PBB_ss;
YTM = YTM_ss;
YTMM = YTMM_ss;
TT = TT_ss;

end;


vcov=[
         0.01            0            0            0            0
            0         0.01            0            0            0
            0            0         0.01            0            0
            0            0            0         0.01            0
            0            0            0            0         0.01
			];

order = 3;
