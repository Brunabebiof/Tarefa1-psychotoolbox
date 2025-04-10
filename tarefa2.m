% Inicialização
Screen('Preference', 'SkipSyncTests', 1); % Remova depois dos testes
AssertOpenGL;
PsychDefaultSetup(2);
screenNumber = max(Screen('Screens'));
[win, rect] = PsychImaging('OpenWindow', screenNumber, [50 50 50]);
[xCenter, yCenter] = RectCenter(rect);
ifi = Screen('GetFlipInterval', win);

% Conversão de graus visuais para pixels (ajuste conforme necessário)
pixPerDeg = 30; % Ajuste para seu setup

% Cores
verde = [0 255 0];
vermelho = [255 0 0];
branco = [255 255 255];
preto = [0 0 0];

% Estímulo
fixSize = 10;
baseRect = [0 0 40 40]; % Tamanho da bolinha
xOffset = 10 * pixPerDeg;
yOffset = 10 * pixPerDeg;

% Número de blocos e trials
nBlocos = 4;
nTrials = 20;

% Loop pelos blocos
for bloco = 1:nBlocos
    
    % Definir cor-alvo para o bloco
    if rand() > 0.5
        corAlvo = verde;
        nomeCor = 'verde';
    else
        corAlvo = vermelho;
        nomeCor = 'vermelho';
    end
    
    % Mostrar instrução
    DrawFormattedText(win, ['Olhe para o estímulo = ' nomeCor], 'center', 'center', preto);
    Screen('Flip', win);
    KbStrokeWait; % Espera uma tecla para começar o bloco
    
    % Loop pelos trials
    for trial = 1:nTrials
        
        % === Tela inicial cinza ===
        Screen('FillRect', win, [128 128 128]);
        Screen('Flip', win);
        WaitSecs(0.5);
        
        % === Ponto de fixação ===
        DrawFormattedText(win, '+', 'center', 'center', preto);
        Screen('Flip', win);
        WaitSecs(1);
        
        % === Pista (seta) ===
        lado = randi([0 1]); % 0 = esquerda, 1 = direita
        if lado == 0
            seta = '<';
        else
            seta = '>';
        end
        DrawFormattedText(win, seta, 'center', 'center', preto);
        Screen('Flip', win);
        WaitSecs(0.5);
        
        % === Estímulos ===
        % Cores dos dois estímulos — os dois com a mesma cor, mas aleatória
        if rand() > 0.5
            corEst = verde;
        else
            corEst = vermelho;
        end
        
        % Determinar o lado onde os estímulos aparecerão
        if lado == 0
            stimX = xCenter - xOffset;
        else
            stimX = xCenter + xOffset;
        end
        
        % Criar os dois estímulos simétricos em Y
        centeredRect1 = CenterRectOnPointd(baseRect, stimX, yCenter - yOffset);
        centeredRect2 = CenterRectOnPointd(baseRect, stimX, yCenter + yOffset);
        
        % Desenhar os estímulos
        Screen('FillOval', win, corEst, centeredRect1);
        Screen('FillOval', win, corEst, centeredRect2);
        Screen('Flip', win);
        
        % Espera para coleta de olhar
        WaitSecs(1);
        
    end
    
    % Pausa entre blocos
    DrawFormattedText(win, 'Pausa. Pressione qualquer tecla para continuar.', 'center', 'center', branco);
    Screen('Flip', win);
    KbStrokeWait;
end

% Fim do experimento
DrawFormattedText(win, 'Fim do experimento. Obrigado!', 'center', 'center', branco);
Screen('Flip', win);
WaitSecs(2);
sca;
