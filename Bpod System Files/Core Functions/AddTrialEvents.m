function newTE = AddTrialEvents(TE, RawTrialEvents)
global BpodSystem

if isfield(TE, 'RawEvents')
    TrialNum = length(TE.RawEvents.Trial) + 1;
else
    TrialNum = 1;
end
TE.nTrials = TrialNum;
%% Parse and add raw events for this trial
States = RawTrialEvents.States;
nPossibleStates = length(BpodSystem.StateMatrix.StateNames);
VisitedStates = zeros(1,nPossibleStates);
% determine unique states while preserving visited order
UniqueStates = zeros(1,nPossibleStates);
nUniqueStates = 0;
UniqueStateIndexes = zeros(1,length(States));
for x = 1:length(States)
    if sum(UniqueStates == States(x)) == 0
        nUniqueStates = nUniqueStates + 1;
        UniqueStates(nUniqueStates) = States(x);
        VisitedStates(States(x)) = 1;
        UniqueStateIndexes(x) = nUniqueStates;
    else
        UniqueStateIndexes(x) = find(UniqueStates == States(x));
    end
end
UniqueStates = UniqueStates(1:nUniqueStates);
UniqueStateDataMatrices = cell(1,nUniqueStates);
% Create a 2-d matrix for each state in a cell array
for x = 1:length(States)
    UniqueStateDataMatrices{UniqueStateIndexes(x)} = [UniqueStateDataMatrices{UniqueStateIndexes(x)}; [RawTrialEvents.StateTimestamps(x) RawTrialEvents.StateTimestamps(x+1)]];
end
for x = 1:nUniqueStates
    eval(['TE.RawEvents.Trial{' num2str(TrialNum) '}.States.' BpodSystem.StateMatrix.StateNames{UniqueStates(x)} ' = UniqueStateDataMatrices{x};'])
    % Note: Modify this to handle states that recur multiple times
end
for x = 1:nPossibleStates
    if VisitedStates(x) == 0
        eval(['TE.RawEvents.Trial{' num2str(TrialNum) '}.States.' BpodSystem.StateMatrix.StateNames{x} ' = [NaN NaN];'])
    end
end
Events = RawTrialEvents.Events;
for x = 1:length(Events)
    eval(['TE.RawEvents.Trial{' num2str(TrialNum) '}.Events.' BpodSystem.EventNames{Events(x)} ' = [' num2str(RawTrialEvents.EventTimestamps(find(Events == Events(x)))) '];'])
end
TE.RawData.OriginalStateNamesByNumber{TrialNum} = BpodSystem.StateMatrix.StateNames;
TE.RawData.OriginalStateData{TrialNum} = RawTrialEvents.States;
TE.RawData.OriginalEventData{TrialNum} = RawTrialEvents.Events;
TE.TrialStartTimestamp(TrialNum) = RawTrialEvents.TrialStartTimestamp;
TE.Settings = BpodSystem.ProtocolSettings;
newTE = TE;
