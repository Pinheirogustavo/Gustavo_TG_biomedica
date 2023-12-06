#Octave 8.0.0
#Autor: Gustavo Pinheiro

%%%%%%%%%%%%%%%%%%%%%%%%%%%% Descricao do codigo %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%{
Analise dos dados de bioimpedancia dos voluntarios do experimento
CAAE: 78985417.0.0000.5594
XXXXXXXXX
%}

#pre-defifinicoes do octave
clear all; more off;clc; close all; %limpa o ambiente de trabalho
pkg load control; pkg load signal; pkg load io; pkg load statistics; %carrega pacotes

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Dados %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

balanca = xlsread('dados_bioimpedancia.ods');  %arquivo com dados dos voluntarios obtidos a

HBF = [60.5	71.4	75.3	65.8	84.4	80.7	72.1	68.7	78.1	73.6;
       58.9	67.5	65.1	63.6	68.8	78.9	71.8	76.3	74.4	59.4];
       #linha 1: dados de FFM(%) dos 10 homens com a balanca comercial hbf
              #linha 2: dados de FFM(%) das 10 mulheres com a balanca comercial hbf

Equipamento_homens = [64.5	74.3	81.6	74.7	78.2	79.4	72.5	71.7	78.7	72.1;
                      64.7	73.5	80.6	72.2	83.7	82.1	74.5	72.1	79.0	71.6;
                      69.2	76.1	78.3	72.6	83.4	79.1	76.4	73.9	81.6	75.0];
# linha 1: eq 1
# linha 2: eq 5
# linha 3: eq 14

Equipamento_mulheres = [62.5	67.1	65.8	65.9	65.5	78.8	70.6	72.1	68.3	60.9;
                        65.0	67.7	70.4	68.8	70.5	78.1	74.1	76.7	75.8	64.4;
                        60.7	63.3	64.9	62.8	65.5	77.2	70.6	71.4	67.7	59.4;
                        64.5	67.2	71.1	70.9	70.8	80.6	75.2	76.5	75.6	62.0];

# linha 1: eq 1
# linha 2: eq 5
# linha 3: eq 6
# linha 4: eq 9

parametros = ["Rb";"Xb";"Zb";"Zc"];
parametros = cellstr(parametros);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%% analise outliers %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

x = length(parametros);
c=1;
d=2;

figure(1); #figura 1 - boxplot homens

for idx =1:2:x*2
  if d== 5
  d=d+1; end

      subplot(x,2,idx)
      boxplot(balanca(1:10,d),"OutlierTags", "on") #boxplot dos elementos de HBF
      title('homens')
      ylabel(parametros(c))
      axis([0.5 1.5]) #ajuste de escala para centralizar a caixa no grafico

      subplot(x,2,idx+1)
      boxplot(balanca(11:20,d)) #boxplot dos elementos de HBF
      title('mulheres')
      ylabel(parametros(c))
      axis([0.5 1.5]) #ajuste de escala para centralizar a caixa no grafico

      teste(idx) = d;
  c=c+1;
  d=d+1;
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%% analise de correlacao %%%%%%%%%%%%%%%%%%%%%%%%%%%

################# Zc Rb ##############
figure(2)
c=1;
d=2;
x=3;
for idx =1:2:x*2
if d== 5
  d=d+1; end

    list = 1:10;
    list(4) = []; list(6) = [];

    xx_h = balanca(list,6); #vetor de x, dados homens
    xx_m = balanca(11:20,6); #vetor de x, dados mulheres

    p_h = polyfit( balanca(list,6) , balanca(list,d) , 1 ); #devolve os coeficientes do polinomio de 1 grau
        [R_h,P_h] = corrcoef (balanca(list,6) , balanca(list,d)); #coeficiente de pearson e pvalor
                 R2_h = R_h(2)^2

    p_m = polyfit( balanca(11:20,6) , balanca(11:20,d) , 1 ); #devolve os coeficientes do polinomio de 1 grau
                 [R_m,P_m] = corrcoef (balanca(11:20,6) , balanca(11:20,d)); #coeficiente de pearson e pvalor
                                  R2_m = R_m(2)^2
     yy_h = balanca(list,d); #vetor de y
     yy_m = balanca(11:20,d); #vetor de y

     yyy_h = polyval(p_h,xx_h); #vetor de y reta
     yyy_m = polyval(p_m,xx_m); #vetor de y reta

     subplot(x,2,idx)
     plot( xx_h , yy_h , 'bo' ,'linewidth', 1.5)
     hold on;     grid on;
    % plot(xx_h,yyy_h, 'r', 'linewidth', 2)


     %equacao = sprintf('y =%.2f x + %.2f',p_h(1),p_h(2));
     %text(0.5,0.5,equacao,"verticalalignment","bottom", ...
    %              "units", "normalized") #posição do polinomio no gráfico
     %R2_h = sprintf('R² = %.2f',R2_h);
     %text(0.5,0.5,R2_h,"verticalalignment","top", ...
     %             "units", "normalized")
     hold off;
     if idx ==1
       title('homens');end
     ylabel(parametros(c));
     xlabel('Zc');
     %legend(' ponto experimental','curva ajustada','Location','southeast');
     legend(' ponto experimental','Location','southeast');

     %%%%%%% mulheres
     subplot(x,2,idx+1)
     plot( xx_m , yy_m , 'bo' ,'linewidth', 1.5)
     hold on;     grid on;
     %plot(xx_m,yyy_m, 'r', 'linewidth', 2)

     %equacao = sprintf('y =%.2f x + %.2f',p_m(1),p_m(2));
     %text(0.5,0.5,equacao,"verticalalignment","bottom", ...
     %             "units", "normalized") #posição do polinomio no gráfico
     %R2_m = sprintf('R² = %.2f',R2_m);
     %text(0.5,0.5,R2_m,"verticalalignment","top", ...
      %            "units", "normalized")

     hold off;

     grid on
     if idx ==1
     title('mulheres');end
     ylabel(parametros(c));
     xlabel('Zc');
     %legend(' ponto experimental','curva ajustada','Location','southeast');
     legend(' ponto experimental','Location','southeast');

     c=c+1;
  d=d+1;
end


