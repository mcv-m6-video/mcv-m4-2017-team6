function [ ws,sigmasA,mus2A,menors ] = StGm( NewFrame,K,InitSigma,InitWs,alphaW,distanciaTH,sigmasA,mus2A,ws )
%StGm implements the Stauffer and Grimson algorithm
%   [ ws,sigmas,mus] = StGm( NewFrame,K,InitSigma) returns the initial values of the algorithm:
%      'ws' are the weights for each gaussian and they will be 1 for all the first model and 0 for all others (2:K). 
%      'sigmas' contain the initial values of all the sigmas in the model
%      and they will correspond to the input value 'InitSigma'. 
%      'mus' (DxCxK) contains the value of the new frame in K=1 
%
%   [ ws,sigmasA,mus2A,menors ] = StGm( NewFrame,K,InitSigma,InitWs,alphaW,distanciaTH,sigmasA,mus2A,ws )
%   updates the values of sigmas, mus, and ws, and returns the gaussians than better fit the model in 'menors'
%
%   David Mart�n Borreg�n, Montse Pard�s

%% funtion
D=size(NewFrame,1);
C=size(NewFrame,2);


if nargin==3
%% Inicialization
    mus2A=ones(D,C,K)*(256*256*256); %inicialzo con valores superlativos.
    mus2A(:,:,1)=NewFrame; %para k=1 pongo el frame inicial
    sigmasA=ones(D,C,K)*InitSigma; %incializo sigmas con InitSigma.
    ws = [ones(D, 1), zeros(D, K-1)]; %compongo ws de 1's en k=1 i 0's en los otros casos.
    
    
else 
%% Update


    
    %% compute distances
    NF=repmat(NewFrame,[1 1 K]); %amplio el nuevo frame a todas las dimensionar para facilitar la resta.
    distancia=squeeze(sum(((mus2A-repmat(NewFrame,[1 1 K])).^2)./sigmasA,2)); %calculo la distancia de mahalanobis entre cada uno de los modelos i el nuevo frame, la salida es un vetor de DxK con los distancias de cada modelo
    
    
    %% Mask with minimum distances
%    [~,indexmins]=min(distancia,[],2);%busco para la segunda dimensi�n, qual �s el modelo que menor distancia tiene.
    [Cdummy,indexmins]=min(distancia,[],2);%busco para la segunda dimensi�n, qual �s el modelo que menor distancia tiene.
    menors=zeros(size(distancia)); %incializo a 0 toda la mascara.
    menors(sub2ind(size(distancia),1:length(indexmins),indexmins'))=ones(D,1); %en aquellos valors que havia menor distancia (indexmins) pongo un 1 en la dimensi�n K=indexmin correspondiente.

    %% search 'menors' below the threshold
    menorsTH = menors & (distancia < distanciaTH.^4);
    %menorsTH = menors & (distancia < distanciaTH); %substraijo a la mascara de menores (menors) aquellos valors con distancias mayor al umbral DistanciaTH.
    capmatched=find(sum(menorsTH,2)==0);%busco cuales son aquellos pixeles que no tienen ninguna guassiana i deben ser acutalizados.
    
    
    
    %% update weights

    ws=ws.*(1-alphaW)+menorsTH.*alphaW; %aquellas guassianas que han cuadrado para el nuevo frame son acutalizadas
    
    matched=repmat(menorsTH,[1 1 C]); 
    matched=permute(matched,[1 3 2]);
    noMatched=abs(1-matched);
    
    %% update model
    
    pessos=permute(repmat(ws,[1 1 C]),[1 3 2]); %repetci�n de ws(DxK) sobre las dimensiones (DxCxK)
    pessos(pessos<1e-50)=1e-50; %los valores que son 0 se les asigna un peque��ssimo valor por problemas en futras divisiones entre 0.
    alpha=alphaW./pessos;%Formulas sobre la correci�n de Wayne Power - Schoones sobre Stauffer Grimson.
    mus2A=noMatched.*mus2A+matched.*((mus2A.*(1-alpha))+NF.*(alpha)); %acutalizaci�n de valors de mu seg�n Stauffer Grimson.
    sigmasA=noMatched.*sigmasA+matched.*(sigmasA.*(1-alpha)+alpha.*((mus2A-NF).^2)); %actualizaci�n de los valrose de Sigma seg�n StaufferGrimson.
    sigmasA(sigmasA<1.5)=1.5; %assignaci�n de una sigma min para evitar demasiado estrechamiento de guassianas en caso de quemados (255,255,255,255,255,...,_254_)
    
    % search for lowest confidence values
    sigmas2=sum(sigmasA(capmatched,:,:).^2,2); %sigmas2(por pixel fuera de model)=(sigmas_r+sigmas_g+sigmas_b)^2 tiene tama�o length(capmatched)x1xK
    sigmas2=reshape(sigmas2,length(capmatched),K); %redimensionamiento para tener tama�o length(capmatched)xK
%    [ ,index2]=min( ws(capmatched, :).^2 ./ sigmas2,[],2); %evaluaci�n de quales s�n las sigmas con menores confianza para todos los que no han cuadrado. ws/std=ws^2/sigma.
    [Cdummy,index2]=min( ws(capmatched, :).^2 ./ sigmas2,[],2); %evaluaci�n de quales s�n las sigmas con menores confianza para todos los que no han cuadrado. ws/std=ws^2/sigma.

    %assignaci�n de las nuevas medias de la guassiana al valor
    %correspondiente del nuevo frame. - �NO robusto para C diferente que 3!
    mus2A(sub2ind(size(mus2A),capmatched,ones(length(capmatched),1),index2))=NewFrame(capmatched,1); %para R
    mus2A(sub2ind(size(mus2A),capmatched,ones(length(capmatched),1)*2,index2))=NewFrame(capmatched,2); %para G
    mus2A(sub2ind(size(mus2A),capmatched,ones(length(capmatched),1)*3,index2))=NewFrame(capmatched,3); %para B 

    %assignaci�n de las nuevas sigmas de la guassiana al valor InitSigma.
    %�NO robusto para C diferente que 3!
    sigmasA(sub2ind(size(sigmasA),capmatched,ones(length(capmatched),1),index2))=InitSigma;
    sigmasA(sub2ind(size(sigmasA),capmatched,ones(length(capmatched),1)*2,index2))=InitSigma;
    sigmasA(sub2ind(size(sigmasA),capmatched,ones(length(capmatched),1)*3,index2))=InitSigma;

    %asignaci�n de un pesso inicial a las nuevas guassianas.
    ws(sub2ind(size(ws),capmatched,index2))=InitWs;
    
    %% Fin
    %la suma de pessos para las diferentes K siempre debe ser 1. la
    %siguiente operaic�n assegura tal caracteristica.
    ws=ws./repmat(sum(ws,2),[1 K]);

end

end

