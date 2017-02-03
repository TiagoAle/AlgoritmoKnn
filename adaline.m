clc;
clear all;
close all;
%Iniciando vetor D com valores de 1 a 10
D = [0:0.1:10];
D = D';
%Gerando valores entre -0,5 e 0,5
xmin= -0.5;
xmax = 0.5;
[nPadroes, nEntradas] = size(D);
a=xmin+rand(nPadroes,1)*(xmax-xmin);

%Adicionando o ruído na reta
aleatorio = D + a;
%Gerando as entradas através dos pontos aleatórios em torno da reta 2x + 3
X = 2*aleatorio + 3;
%Recebendo os valores desejados através da função 2x + 3
D = 2*D + 3;

%Normalizando valores entre 0 e 1
X = (X - min(X))/(max(X)-min(X))
D = (D - min(D))/(max(D)-min(D))
plot(X,'.');
%Iniciando Taxa de Aprendizado e Bias (X0)
n = 0.1;
bias = 1;
%Iniciando os pesos com o valor 0
w = zeros(nEntradas+1,1);
%Definindo erro maxímo tolerável
erroMax = 0.04;
erroEpoca = 1;
epocas = 0;
%Iniciando vetor Y com 0
Y = zeros(nPadroes,1);
while(erroEpoca > erroMax)
    
    erroEpoca = 0;
    for j = 1:nPadroes
        u = bias*w(1,1)+X(j,1)*w(2,1); %Função de ativação
        Y(j) = u;%Y obtido através do u
        erro = D(j) - u;%Erro(j) obtido no treinamento
    
        w(1,1) = w(1,1)+n*bias*erro; %Atualização do peso w(1,1) da entrada X0
        w(2,1) = w(2,1)+n*X(j,1)*erro; %Atualização do peso w(2,1) da entrada X1
    end
    
    for j = 1:nPadroes
       Y(j) = bias*w(1,1)+X(j,1)*w(2,1); %Atualizando valores obtidos com pesos finais da época
    end
    %Calculo do MSE da época
    MSE = (D-Y)'*(D-Y)/nPadroes;
    %Calculo do RMSE, sendo considerado o erro da epoca para parar o
    %treinamento
    erroEpoca = sqrt(MSE);
    
     % Visualização gráfica da evolução do treinamento.
    clf
    plot(X(:, 1), D,'r.')
 	%axis ([0 1.5 min(D)-1 max(D)+1])
    grid on
    hold on
    
    % Reta aproximada pelo Adaline
    Reta = w(2,1)*X + w(1,1);
    plot(X,Reta,'k')
    title('Evolução da Aproximação Obtida')
    xlabel('x')
    ylabel('f(x)')
    
    legend('Amostras', 'Reta Obtida', 'Location', 'NorthWest')
	
	% Pausa para melhor vizualização da evolução da reta (aproximação)
    pause(0.25)
    epocas = epocas+1;
end

disp('------------ ADALINE ------------');
disp('Resultados do Treinamento para a função 2x + 3 normalizada');
if (erroEpoca <= erroMax)
    disp('A rede convergiu para o resultado desejado.');
else
    disp('A rede não convergiu para o resultado desejado.');
end
disp(' ');
disp(['RMSE: ',num2str(erroEpoca)]);
disp(' ');
disp(['Épocas: ',num2str(epocas)]);
disp(['bias:   ',num2str(w(1,1))]);
disp(['w1:     ',num2str(w(2,1))]);
disp(' ');
disp('Valores encontrados pelo ADALINE:');
disp(' ');
for j = 1:nPadroes
    disp(['frede(',num2str(X(j,1),'%0.2f'),...
        ') = ',num2str(Y(j),'%0.2f')]);
end
       