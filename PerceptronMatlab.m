X = [0 0;0 1;1 0;1 1];
D = [0;1;1;1];

[nPadroes, nEntradas] = size(X);

txAprendizado = 0.5;
w = rand(nEntradas+1,1);
bias = 1;
erroEpoca = 1;
epoca = 0;

while(erroEpoca~=0)
  Y = zeros(4,1);
  erroEpoca = 0;
  
  for j = 1:nPadroes
    ativ = bias*w(1,1)+X(j,1)*w(2,1)+X(j,2)*w(3,1);
    
    if(ativ > 0)
      Y(j) = 1;
    else
      Y(j) = 0;
    end
    
    erro = D(j)-Y(j);
    w(1,1) = w(1,1)+txAprendizado*bias*erro;
    w(2,1) = w(2,1)+txAprendizado*X(j,1)*erro;
    w(3,1) = w(3,1)+txAprendizado*X(j,2)*erro;
    
    erroEpoca = erroEpoca + abs(erro);
    
  end
  epoca = epoca + 1;
end

disp('Treinamento do Perceptron (AND)');
disp('Resultados do Treinamento');
disp(' ');
disp(['Épocas: ',num2str(epoca)]);
disp(['w0:   ',num2str(w(1,1))]);
disp(['w1:     ',num2str(w(2,1))]);
disp(['w2:     ',num2str(w(3,1))]);
disp(' ');
disp('Teste para os pesos encontrados: ')
for j=1:4
    disp(['X1 = ',num2str(X(j,1)),' X2 = ',num2str(X(j,2)),...
        ' Yobtido = ',num2str(Y(j)),' Ydesejado = ',num2str(D(j))]);
end
