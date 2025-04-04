% --------------------------- % PARAMETROS DA TELA E VISUAL ANGLE % ---------------------------

% Distância da tela ao participante (em cm)
screenDistance = 57; % padrão em psicofísica

% Largura da tela (em cm)
screenWidth = 50;

% Resolução horizontal da tela (em pixels)
screenResolution = 1920;

% Tamanho do estímulo em graus de ângulo visual (ajustável)
tamEstimuloGraus = 2;

% Posição lateral dos estímulos (graus do centro)
anguloLateral = 5;

% Cores
corRosa = [255, 105, 180];
corAzul = [0, 191, 255];
corPista = [255, 255, 255];
corTexto = [255, 255, 255];

% Número de trials
numTrials = 20;

% Abre janela
Screen('Preference', 'SkipSyncTests', 1);
[window, windowRect] = PsychImaging('OpenWindow', max(Screen('Screens')), [128, 128, 128]);

% Função para converter ângulo visual em pixels
VisualAngleToPixels = @(graus) round(tan(graus * pi / 180) * screenDistance * (screenResolution / screenWidth));

% Posição do centro da tela
[xCenter, yCenter] = RectCenter(windowRect);

% Define posições absolutas (em pixels) para esquerda e direita
offsetX = VisualAngleToPixels(anguloLateral);
posEsquerda = [xCenter - offsetX, yCenter];
posDireita  = [xCenter + offsetX, yCenter];

% Sorteia qual cor será a instruída e em qual lado aparecerá sempre nesse bloco
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

% Exibe a instrução sobre a cor a ser seguida no início do bloco
DrawFormattedText(window, ['Olhe para os estimulos de cor: ' corTextoStr], 'center', 'center', corTexto);
Screen('Flip', window);
WaitSecs(2); % Tempo da instrução na tela

% Exibe o ponto de fixação por 2 segundos antes do início do bloco
Screen('FillOval', window, [0, 0, 0], [xCenter-5, yCenter-5, xCenter+5, yCenter+5]);
Screen('Flip', window);
WaitSecs(2);

% Calcula o tempo de refresh da tela
ifi = Screen('GetFlipInterval', window);

for trial = 1:numTrials

    % Define o lado que a pista vai apontar (esquerda ou direita)
    if rand < 0.5
        posPista = posEsquerda;
    else
        posPista = posDireita;
    end

    % Desenha o ponto de fixação
    Screen('FillOval', window, [0, 0, 0], [xCenter-5, yCenter-5, xCenter+5, yCenter+5]);

    % Desenha a pista (linha branca apontando para o lado escolhido)
    Screen('DrawLine', window, corPista, xCenter, yCenter, posPista(1), posPista(2), 5);

    % Atualiza a tela para exibir a pista
    vbl = Screen('Flip', window);
    WaitSecs(1.0 - 0.5 * ifi); % Tempo da pista antes do estímulo

    % Escolhe aleatoriamente qual estímulo será apresentado
    if rand < 0.5
        corEstimulo = corInstrucao;
        posEstimulo = ladoCorInstrucao;
    else
        corEstimulo = corNaoInstrucao;
        posEstimulo = ladoCorNaoInstrucao;
    end

    % Calcula tamanho do estímulo em pixels
    raioEstimulo = VisualAngleToPixels(tamEstimuloGraus);

    % Apresenta o estímulo
    Screen('FillOval', window, corEstimulo, ...
        [posEstimulo(1)-raioEstimulo, posEstimulo(2)-raioEstimulo, ...
         posEstimulo(1)+raioEstimulo, posEstimulo(2)+raioEstimulo]);
    Screen('Flip', window);
    WaitSecs(1.5 - 0.5 * ifi); % Duração do estímulo

end

% Fecha a janela após os blocos
