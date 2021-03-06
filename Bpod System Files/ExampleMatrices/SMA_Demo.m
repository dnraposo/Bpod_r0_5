% Example state matrix: Single state; one second pause

sma = NewStateMatrix();

sma = AddState(sma, 'Name', 'State1', ...
    'Timer', 1,...
    'StateChangeConditions', {'Tup', 'State2'},...
    'OutputActions', {'PWM1', 128});
sma = AddState(sma, 'Name', 'State2', ...
    'Timer', 1,...
    'StateChangeConditions', {'Tup', 'exit'},...
    'OutputActions', {'PWM1', 255, 'ValveState', 4});