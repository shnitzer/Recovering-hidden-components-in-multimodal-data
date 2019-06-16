function fig5( V1, V2, VS, VA, mECGmean, fECGmean )
%FIG5 creates the plots of Figure 5 in the paper - presenting the
% diffusion maps eigenvectors of the two ta-channels and the eigenvectors
% of the operators S and A

pos = [1159, 426, 404, 290];

% Presenting the DM eigenvectors of the two ta-ECG channels:
figure('Name','DM of sig1 colored by mECG');
scatter(V1(:,2), V1(:,3), 30, mECGmean, 'filled'); colorbar;
set(gcf,'Position',pos);

figure('Name','DM of sig1 colored by fECG');
scatter(V1(:,2), V1(:,3), 30, fECGmean, 'filled'); colorbar;
set(gcf,'Position',pos);

figure('Name','DM of sig2 colored by mECG');
scatter(V2(:,2), V2(:,3), 30, mECGmean, 'filled'); colorbar;
set(gcf,'Position',pos);

figure('Name','DM of sig2 colored by fECG');
scatter(V2(:,2), V2(:,3), 30, fECGmean, 'filled'); colorbar;
set(gcf,'Position',pos);

% Presenting the eigenvectors of the operators S and A:
figure('Name','Eigenvectors of S colored by mECG')
scatter(VS(:,2), VS(:,3), 30, mECGmean, 'filled'); colorbar; %title('S_{2,3} colored by mECG');
set(gcf,'Position',pos);

figure('Name','Eigenvectors of S colored by fECG')
scatter(VS(:,2), VS(:,3), 30, fECGmean, 'filled'); colorbar; %title('S_{2,3} colored by fECG')
set(gcf,'Position',pos);

figure('Name','Imaginary part of the eigenvectors of A colored by mECG')
scatter(imag(VA(:,2)), imag(VA(:,3)), 30, mECGmean, 'filled'); colorbar; %title('A_{imag(2,3)} colored by mECG')
set(gcf,'Position',pos);

figure('Name','Imaginary part of the eigenvectors of A colored by fECG')
scatter(imag(VA(:,2)), imag(VA(:,3)), 30, fECGmean, 'filled'); colorbar; %title('A_{imag(2,3)} colored by fECG')
set(gcf,'Position',pos);

figure('Name','Real part of the eigenvectors of A colored by mECG')
scatter(real(VA(:,2)), real(VA(:,3)), 30, mECGmean, 'filled'); colorbar; %title('A_{real(2,3)} colored by mECG')
set(gcf,'Position',pos);

figure('Name','Real part of the eigenvectors of A colored by fECG')
scatter(real(VA(:,2)), real(VA(:,3)), 30, fECGmean, 'filled'); colorbar; %title('A_{real(2,3)} colored by fECG')
set(gcf,'Position',pos);

end

