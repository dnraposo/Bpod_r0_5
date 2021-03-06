% function OutcomePlot(AxesHandle,TrialTypeSides, OutcomeRecord, CurrentTrial)
function OutcomePlot(AxesHandle, Action, varargin)
%% 
% Plug in to Plot reward side and trial outcome.
% AxesHandle = handle of axes to plot on
% Action = specific action for plot, "init" - initialize OR "update" -  update plot

%Example usage:
% OutcomePlot(AxesHandle,'init',TrialTypeSides)
% OutcomePlot(AxesHandle,'init',TrialTypeSides,'ntrials',90)
% OutcomePlot(AxesHandle,'update',CurrentTrial,TrialTypeSides,OutcomeRecord)

% varargins:
% TrialTypeSides: Vector of 0's (right) or 1's (left) to indicate reward side (0,1), or 'None' to plot trial types individually
% OutcomeRecord:  Vector of trial outcomes
%                 Simplest case: 
%                               1: correct trial (green)
%                               0: incorrect trial (red)
%                 Advanced case: 
%                               NaN: future trial (blue)
%                                -1: withdrawal (red circle)
%                                 0: incorrect choice (red dot)
%                                 1: correct choice (green dot)
%                                 -2: did not choose (green circle)
% OutcomeRecord can also be empty
% Current trial: the current trial number

% Adapted from BControl (SidesPlotSection.m) 
% Kachi O. 2014.Mar.17


%% Code Starts Here
global nTrialsToShow %this is for convenience
% global BpodSystem

switch Action
    case 'init'
        %initialize pokes plot
        SideList = varargin{1};
        
        nTrialsToShow = 90; %default number of trials to display
        
        if length(varargin) > 1 %custom number of trials
            nTrialsToShow = varargin{2};
        end
        
        %plot in specified axes
        plot(AxesHandle, 1:nTrialsToShow, SideList(1:nTrialsToShow), 'o', 'MarkerFaceColor','b','MarkerEdgeColor', 'b', 'MarkerSize', 4);
        hold(AxesHandle, 'on');
        % scatter(AxesHandle,  1:nTrialsToShow, SideList(1:nTrialsToShow),'MarkerFaceColor','b','MarkerEdgeColor', 'b');
        set(AxesHandle,'TickDir', 'out','YLim', [-1, 2], 'YTick', [0 1],'YTickLabel', { 'Right','Left'}, 'box', 'off');
                
    case 'update'
        CurrentTrial = varargin{1};
        SideList = varargin{2};
        OutcomeRecord = varargin{3};
        
        if CurrentTrial<1
            CurrentTrial = 1;
        end
        
        % recompute xlim
        [mn, mx] = rescaleX(AxesHandle,CurrentTrial,nTrialsToShow);

        %plot future trials
        FutureTrialsIndx = CurrentTrial:mx;
        cla(AxesHandle);
        plot(AxesHandle, FutureTrialsIndx, SideList(FutureTrialsIndx), 'o', 'MarkerFaceColor','b','MarkerEdgeColor', 'b', 'MarkerSize', 4);
        
        %Plot current trial
        plot(AxesHandle,CurrentTrial,SideList(CurrentTrial), 'o', 'MarkerFaceColor',[1 1 1],'MarkerEdgeColor', 'k', 'MarkerSize', 4);
        plot(AxesHandle,CurrentTrial,SideList(CurrentTrial), '+', 'MarkerFaceColor',[1 1 1],'MarkerEdgeColor', 'k', 'MarkerSize', 4);

        %Plot past trials
        if ~isempty(OutcomeRecord)
            indxToPlot = mn:CurrentTrial-1;
            
            %Plot Correct
            CorrectTrialsIndx = (OutcomeRecord(indxToPlot) == 1);
            plot(AxesHandle,  indxToPlot(CorrectTrialsIndx), SideList(indxToPlot(CorrectTrialsIndx)), 'o','MarkerFaceColor','g','MarkerEdgeColor', 'g', 'MarkerSize', 4);
            %Plot Incorrect
            InCorrectTrialsIndx = (OutcomeRecord(indxToPlot) == 0);
            plot(AxesHandle,  indxToPlot(InCorrectTrialsIndx), SideList(indxToPlot(InCorrectTrialsIndx)), 'o','MarkerFaceColor','r','MarkerEdgeColor', 'r', 'MarkerSize', 4);
            %Plot EarlyWithdrawals
            EarlyWithdrawalTrialsIndx =(OutcomeRecord(indxToPlot) == -1);
            plot(AxesHandle,  indxToPlot(EarlyWithdrawalTrialsIndx), SideList(indxToPlot(EarlyWithdrawalTrialsIndx)),'ro','MarkerFaceColor',[1 1 1], 'MarkerSize', 4);
            %Plot DidNotChoose
            DidNotChooseTrialsIndx = (OutcomeRecord(indxToPlot) == -2);
            plot(AxesHandle,  indxToPlot(DidNotChooseTrialsIndx), SideList(indxToPlot(DidNotChooseTrialsIndx)),'bo','MarkerFaceColor',[1 1 1], 'MarkerSize', 4);
            
        end
        drawnow;

end

end

function [mn,mx] = rescaleX(AxesHandle,CurrentTrial,nTrialsToShow)
FractionWindowStickpoint = .75; % After this fraction of visible trials, the trial position in the window "sticks" and the window begins to slide through trials.
mn = max(round(CurrentTrial - FractionWindowStickpoint*nTrialsToShow),1);
mx = mn + nTrialsToShow - 1;
set(AxesHandle,'XLim',[mn-1 mx+1]);
end


