% Inicializa a Psychtoolbox e configura a tela
Screen('Preference', 'SkipSyncTests', 1); % Pula testes de sincronização (remova para experimento real)
[window, windowRect] = Screen('OpenWindow', 0, [128, 128, 128]); % Abre tela cinza

% Obtém o centro da tela
[xCenter, yCenter] = RectCenter(windowRect);

% Define as cores
corRosa = [255, 105, 180]; % Rosa
corAzul = [0, 0, 255]; % Azul
corTexto = [255, 255, 255]; % Branco para texto
corPista = [255, 255, 255]; % Branco para a pista

% Define deslocamento horizontal dos estímulos
offsetX = 300; % Distância do centro
posEsquerda = [xCenter - offsetX, yCenter];
posDireita = [xCenter + offsetX, yCenter];

% Número de blocos e trials por bloco
numBlocos = 4;
numTrials = 20;

% Define o lado que a pista vai apontar (esquerda ou direita)
if rand < 0.5
    posPista = posEsquerda;
else
    posPista = posDireita;
end
% Sorteia qual cor sera a instruida e em qual lado aparecera sempre nesse bloco
if rand < 0.5
corInstrucao = corRosa;
corNaoInstrucao = corAzul;
ladoCorInstrucao = posEsquerda;
ladoCorNaoInstrucao = posDireita;
corTextoStr = 'ROSA';
else
corInstrucao = corAzul;
corNaoInstrucao = corRosa;
ladoCorInstrucao = posDireita;
ladoCorNaoInstrucao = posEsquerda;
corTextoStr = 'AZUL';
end

% Exibe a instrucao sobre a cor a ser seguida no inicio do bloco
DrawFormattedText(window, ['Olhe para os estimulos de cor: ' corTextoStr], 'center', 'center', corTexto);
Screen('Flip', window);
WaitSecs(2); % Tempo da instrucao na tela

% Exibe o ponto de fixacao por 2 segundos antes do inicio do bloco
Screen('FillOval', window, [0, 0, 0], [xCenter-5, yCenter-5, xCenter+5, yCenter+5]);
Screen('Flip', window);
WaitSecs(2);

% Calcula o tempo de refresh da tela
ifi = Screen('GetFlipInterval', window);

for trial = 1:numTrials

% Desenha o ponto de fixacao
Screen('FillOval', window, [0, 0, 0], [xCenter-5, yCenter-5, xCenter+5, yCenter+5]);

% Desenha a pista (linha branca apontando para o lado escolhido)
Screen('DrawLine', window, corPista, xCenter, yCenter, posPista(1), posPista(2), 5);

% Atualiza a tela para exibir a pista
vbl = Screen('Flip', window);
WaitSecs(1.0 - 0.5 * ifi); % Tempo da pista antes do estimulo em termos de refresh

% Escolhe aleatoriamente qual estimulo sera apresentado
if rand < 0.5
    corEstimulo = corInstrucao;
    posEstimulo = ladoCorInstrucao;
else
    corEstimulo = corNaoInstrucao;
    posEstimulo = ladoCorNaoInstrucao;
end

% Converte posicao do estimulo para coordenadas em angulo de visao
posEstimulo = VisualAngleToPixels(posEstimulo, screenDistance, screenWidth, screenResolution);

% Apresenta o estimulo
Screen('FillOval', window, corEstimulo, [posEstimulo(1)-50, posEstimulo(2)-50, posEstimulo(1)+50, posEstimulo(2)+50]);
Screen('Flip', window);
WaitSecs(1.5 - 0.5 * ifi);
end

% Fecha a janela apos os blocos, sca



