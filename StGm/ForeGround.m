function [ FG ] = ForeGround(ws,menors,sigmas,K,THFG )
%FOREGROUND retorna la mascara de primer plano seguno el algoritmo StGm
%   FG = ForeGround(ws,menors,sigmas,K,THFG ) retorna FG como mascara de
%   primer plano. siendo ws los pesos, menors, aquellas guassianas que han
%   cuadarado, K el numero de guassians, i THFG el umbral de decisión.
%   David Mart’n Borreg—n, Montse Pardˆs
    
%% incialización.
    D=size(ws,1); %evaluación de la dimensión W*H.

%% 
%    [~,I]=sort(ws./squeeze(sqrt(sum(sigmas.^2,2))),2,'ascend'); %se ordenan las guassianas de cada pixel segun Ws/std.
    [Cdummy,I]=sort(ws./squeeze(sqrt(sum(sigmas.^2,2))),2,'ascend'); %se ordenan las guassianas de cada pixel segun Ws/std.
    %I tiene tamaño DxK
    
    wsT=ws'; %trasnpogo la matriz (DxK)->(KxD)
    W=wsT(I+repmat((0:D-1)'*K,[1 K]));%es el vector ordenado de ws respecto los valores obtenidos en el sort ws/std. se podría hacer mejor con sub2ind.
    acumW=cumsum(W,2); %suma acumulada tal como marco stGm
    mask=(acumW>THFG)'; %comparacion con umbral assignado. es una mascara que contiene 0 en aquellas guassianas ordenadas estan por debejo del umbral.

%    [~,I2]=sort(I,2); %I2 contiene el indice que era menor en el caso anterior. Permite volver al orden original
    [Cdummy,I2]=sort(I,2); %I2 contiene el indice que era menor en el caso anterior. Permite volver al orden original
    MASK=mask(I2+repmat((0:D-1)'*K,[1 K]));%reordenación de mask para que cuadre con ws original.
    FG=abs(1-sum(menors.*MASK,2));%compración de si el pixel selecciónado como primer plano tambien no cumple el primer plano.

    
end

