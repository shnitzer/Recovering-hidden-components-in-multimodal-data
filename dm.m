% Construct the diffusion maps kernel and eigenvectors
% ***************************************************************@

function [ V, E, K ] = dm( data, ep )
%DM Calculates the diffusion maps kernel, K, its eigenvectors, V, and its
% eigenvalues, E.
% Input: data - the data matrix of size: Samples X Features.
%        ep   - a coefficient multiplying the kernel scale (\epsilon)

dis = squareform(pdist(data));  % distance matrix
epD = median(dis(:))*ep;        % kernel scale
W   = exp(-dis.^2/epD.^2);      % affinity kernel
K   = diag(1./sum(W, 2)) * W;   % normalized affinity kernel (diffusion maps kernel)

[V, E] = eigs(K,10);            
[~, I] = sort(real(diag(E)),'descend');

V = V(:,I);
E = E(I,I);

end

