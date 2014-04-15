% Example state matrix: Trigger the sound server on Port1in

sma = NewStateMatrix();
sma = AddState(sma, 'Name', 'WaitForPoke', ...
    'Timer', 0,...
    'StateChangeConditions', {'Port1In', 'TriggerSound'},...
    'OutputActions', {});
sma = AddState(sma, 'Name', 'TriggerSound', ...
    'Timer', 0,...
    'StateChangeConditions', {'Tup', 'Delay'},...
    'OutputActions', {'Serial1Code', 1}); % Code 5 plays 5.wav from SD card
sma = AddState(sma, 'Name', 'Delay', ...
    'Timer', 1,...
    'StateChangeConditions', {'Tup', 'exit'},...
    'OutputActions', {});