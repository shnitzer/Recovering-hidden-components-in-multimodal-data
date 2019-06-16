% MATLAB code implementation of the synthetic fetal ECG heart rate 
% detection example in Subsection 6.2 from: T. Shnitzer, M. Ben-Chen, L.
% Guibas, R. Talmon and H.T. Wu, "Recovering Hidden Components in 
% Multimodal Data with Composite Diffusion Operators", submitted to SIAM 
% Journal on Mathematics of Data Science (SIMODS).
% ***************************************************************@
% This implementation constructs the simulated ta-ECG signals composed of
% the maternal and the fetal ECG components, and applies the operators A
% and S to the data.
%
% Author: Tal Shnitzer.
% Created:  6/16/19.
% ***************************************************************@

function main
%MAIN creates Figure 4, Figure 5 and Figure 6 in the paper.

%% Load the data and constrruct the simulated ta-ECG signals
load 'fECG.mat';
load 'mECG.mat';

% Preprocessing (removing the mean, normalizing by the maximum, removing
% the net noise (60Hz) and median filtering):
fs = 250;
fECG = bsxfun(@minus,   fECG, mean(fECG));
fECG = bsxfun(@rdivide, fECG, 0.5*max(fECG));
mECG = bsxfun(@minus,   mECG, mean(mECG));
mECG = bsxfun(@rdivide, mECG, 0.5*max(mECG));

notchFilt = fdesign.notch(4,60/(fs/2),1);
Hnotch    = design(notchFilt);
fECG(:,2) = filter(Hnotch,fECG(:,2) - medfilt1(fECG(:,2),100));
fECG(:,3) = filter(Hnotch,fECG(:,3) - medfilt1(fECG(:,3),100));
mECG(:,3) = filter(Hnotch,mECG(:,3) - medfilt1(mECG(:,3),100));

% Upsampling the ECG representing the maternal signal by a factor of 4 and
% the ECG representing the fetal signal by a factor of 2 (fECG will be
% approximately 2 times faster than mECG)
mECGrs  = resample(mECG(:,3), 4, 1);
fECGrs1 = resample(fECG(:,2), 2, 1); 
fECGrs2 = resample(fECG(:,3), 2, 1); 
fs = 1000;

% Constructing the ta-ECG signals:
len = 40000; % Number of samples to use in the analysis
sig_range = 1:len;
sig1 = 2*mECGrs(sig_range) -     fECGrs1(sig_range);
sig2 =   mECGrs(sig_range) - 0.5*fECGrs2(sig_range);

% Plotting Figure 4:
figure('Name','Figure 4'); 
lx(1) = subplot(2,1,1); plot(0:1/fs:(len/fs-1/fs),sig1,'k','LineWidth',1); xlabel('t [sec]'); ylabel({'Simulated Abdominal' ; 'ECG, lead 1'})
lx(2) = subplot(2,1,2); plot(0:1/fs:(len/fs-1/fs),sig2,'k','LineWidth',1); xlabel('t [sec]'); ylabel({'Simulated Abdominal' ; 'ECG, lead 2'})
linkaxes(lx,'x');
xlim([2,10.1]);
set(gcf,'Position',[800,400,1000,400]);

%% Construct a lagmap of the signal and reference data and construct the ground truth signals

lag  = 12;
jump = lag/2;

% Lagmap of the ta-ECG simulated signals:
siglag1 = const_lag( sig1, lag, jump );
siglag2 = const_lag( sig2, lag, jump );

% Reference data lagmaps:
fECGmean = mean( const_lag( fECGrs1(sig_range), lag, jump ), 2); 
% fECG values at points that will correspond to the eigenvector points of 
% the diffusion maps operators and operators A and S

mECGmean = mean( const_lag( mECGrs(sig_range), lag, jump ), 2); 
% fECG values at points that will correspond to the eigenvector points of 
% the diffusion maps operators and operators A and S

% Ground truth of fECG beat locations and mECG beat locations:
fECGgt = fECGrs2(sig_range);
fECGgt = fECGgt>1;
fECGgt = sum( const_lag( fECGgt, lag, jump ), 2);
fECGgt(fECGgt>0) = 1;

mECGgt = mECGrs(sig_range);
mECGgt = mECGgt>1;
mECGgt = sum( const_lag( mECGgt, lag, jump ), 2);
mECGgt(mECGgt>0) = 1;

%% Calculate the diffusion maps kernels and eigenvectors
ep = 1;

[ V1, ~, K1 ] = dm( siglag1, ep );
[ V2, ~, K2 ] = dm( siglag2, ep );

%% Constructing the operators S and A and their eigenvectors

S = K1*K2.' + K2*K1.';
A = K1*K2.' - K2*K1.';

[VS, ES] = eigs(S,10);
[~, I]   = sort(real(diag(ES)),'descend');
VS       = real(VS(:,I));

[VA, EA] = eigs(A,10);
[~, I]   = sort(imag(diag(EA)),'descend');
VA       = VA(:,I);

%% Plotting Figure 5

fig5( V1, V2, VS, VA, mECGmean, fECGmean )

%% Plotting Figure 6

pltsig1 = mean(siglag1,2);          % Signal to plot (length(pltsig1) = length(VA(:,1)))
cmap    = [0.75,0.75,0.75; 0,0,0];  % Colormap to use in the plot (black\gray)

x = [(1:length(fECGmean))*jump/fs; (1:length(fECGmean))*jump/fs];
y = [pltsig1(:).'; pltsig1(:).'];
z = zeros(size(y));

c = [double((abs((VS(:,2))).')>1e-2); double((abs((VS(:,2))).')>1e-2)];
figure('Name','ta-ECG colored by a thresholded eigenvector of S')
surface(x,y,z,c,'facecolor','none','edgecolor','flat','LineWidth',2); colormap(cmap);
ax1 = gca;
yl = ax1.YLim;
hold on
line(repmat(find((mECGgt>0).')*jump/fs,10,1),repmat(linspace(yl(1),yl(2),10).',1,sum(mECGgt)),'Color' ,[0.3,0.3,0.3,0.3], 'LineStyle',':','LineWidth',1.5)
xlabel('t [sec]');
set(ax1,'YTick',[])
xlim([12.2,22.2]);
hold off;
set(gcf,'Position',[600,500,1200,250]);

c = [double((abs(imag(VA(:,2))).')>3e-2); double((abs(imag(VA(:,2))).')>3e-2)];
figure('Name','ta-ECG colored by a thresholded eigenvector of A')
surface(x,y,z,c,'facecolor','none','edgecolor','flat','LineWidth',2); colormap(cmap);
ax2 = gca;
yl = ax2.YLim;
hold on
line(repmat(find((fECGgt>0).')*jump/fs,10,1),repmat(linspace(yl(1),yl(2),10).',1,sum(fECGgt)),'Color' ,[0.3,0.3,0.3,0.3], 'LineStyle','--','LineWidth',1)
xlabel('t [sec]');
set(ax2,'YTick',[])
xlim([12.2,22.2]);
hold off;
set(gcf,'Position',[600,200,1200,250]);

linkaxes([ax1,ax2],'xy')

end