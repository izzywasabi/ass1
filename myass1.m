% Walking times
TimeDist    =  [0	5	10	20	15	20	20	25	10	15	25;
                5	0	5	10	15	15	10	15	10	20	20;
                10	5	0	10	15	15	10	10	5	10	15;
                20	10	10	0	5	5	5	10	15	20	15;
                15	15	15	5	0	5	10	15	20	25	20;
                20	15	15	5	5	0	10	15	20	25	20;
                20	10	10	5	10	10	0	5	15	25	10;
                25	15	10	10	15	15	5	0	15	20	5 ;
                10	10	5	15	20	20	15	15	0	5	15;
                15	20	10	20	25	25	25	20	5	0	15;
                25	20	15	15	20	20	10	5	15	15	0 ];

Pref        =  [3; 3; 2; 4; 3; 5; 1; 2; 2; 5]; % reward for each attraction

T = 60; % # of timeslots
M = 10; % # of attractions

% WaitTimes of each attraction for all 60 timeslots
WaitTimes{1}  = [25	25	20	15	25	10	25	25	10	5	25	5	25	5	5	10	15	20	20	5	10	5	10	25	25	10	10	25	25	25	10	5	5	10	10	5	20	25	20	20	20	10	15	10	15	25	5	25	15	15	25	10	10	20	10	5	20	20	20	25];
WaitTimes{2}  = [10	25	5	5	10	15	25	15	20	15	20	15	20	10	25	5	20	10	5	10	25	10	10	15	15	25	10	5	10	25	15	25	20	10	25	10	20	20	15	5	5	5	5	5	25	5	20	15	20	20	15	10	20	20	25	25	10	5	5	15];
WaitTimes{3}  = [5	5	25	20	10	15	20	15	5	20	15	20	5	20	25	15	25	15	25	15	10	25	25	5	25	20	15	25	10	20	25	15	15	25	5	10	5	20	15	10	10	15	25	10	5	25	5	15	5	15	10	25	15	5	10	15	5	10	20	15];
WaitTimes{4}  = [25	25	20	15	25	10	25	25	10	5	25	5	25	5	5	10	15	20	20	5	10	5	10	25	25	10	10	25	25	25	10	5	5	10	10	5	20	25	20	20	20	10	15	10	15	25	5	25	15	15	25	10	10	20	10	5	20	20	20	25];
WaitTimes{5}  = [10	25	5	5	10	15	25	15	20	15	20	15	20	10	25	5	20	10	5	10	25	10	10	15	15	25	10	5	10	25	15	25	20	10	25	10	20	20	15	5	5	5	5	5	25	5	20	15	20	20	15	10	20	20	25	25	10	5	5	15];
WaitTimes{6}  = [5	5	25	20	10	15	20	15	5	20	15	20	5	20	25	15	25	15	25	15	10	25	25	5	25	20	15	25	10	20	25	15	15	25	5	10	5	20	15	10	10	15	25	10	5	25	5	15	5	15	10	25	15	5	10	15	5	10	20	15];
WaitTimes{7}  = [25	25	20	15	25	10	25	25	10	5	25	5	25	5	5	10	15	20	20	5	10	5	10	25	25	10	10	25	25	25	10	5	5	10	10	5	20	25	20	20	20	10	15	10	15	25	5	25	15	15	25	10	10	20	10	5	20	20	20	25];
WaitTimes{8}  = [10	25	5	5	10	15	25	15	20	15	20	15	20	10	25	5	20	10	5	10	25	10	10	15	15	25	10	5	10	25	15	25	20	10	25	10	20	20	15	5	5	5	5	5	25	5	20	15	20	20	15	10	20	20	25	25	10	5	5	15];
WaitTimes{9}  = [5	5	25	20	10	15	20	15	5	20	15	20	5	20	25	15	25	15	25	15	10	25	25	5	25	20	15	25	10	20	25	15	15	25	5	10	5	20	15	10	10	15	25	10	5	25	5	15	5	15	10	25	15	5	10	15	5	10	20	15];
WaitTimes{10} = [5	5	25	20	10	15	20	15	5	20	15	20	5	20	25	15	25	15	25	15	10	25	25	5	25	20	15	25	10	20	25	15	15	25	5	10	5	20	15	10	10	15	25	10	5	25	5	15	5	15	10	25	15	5	10	15	5	10	20	15];


%% Request results for testing
[sequence]                  =eftelingplan(TimeDist,WaitTimes,Pref);
[nextattraction,expreward]  =eftelingpolicy(TimeDist,WaitDis,Pref);

    for ride = M:-1:1
        for timeslot = 1:T
            %% Calculate max reward for current ride, time
            if timeslot + WaitTimes{ride}(timeslot)/5 + <= T
                reward_with_current             = Pref(ride) + optimalReward(ride+1, timeslot+WaitTimes{ride}(timeslot));
                reward_without_current          = optimalReward(ride+1, timeslot);
                distance_penalty                = TimeDist(sequence(ride) + 1, sequence(ride+1) + 1); % Corrected this line
                optimalReward(ride, timeslot+1) = max(reward_with_current - distance_penalty, reward_without_current);
                distance_penalty                = TimeDist(sequence(ride) + 1, sequence(ride+1) + 1);
                optimalReward(ride, timeslot+1)    = max(reward_with_current, reward_without_current);
            else
                optimalReward(ride, timeslot+1) = optimalReward(ride+1, timeslot);
            end
        end
    end

    %% Backtrack to find the optimal sequence
    timeslot = 1;
    for i = 1:M
        %% Find the attraction with the maximum reward among unvisited attractions
        maxReward = -inf;
        selectedAttraction = 0;
        for j = 1:M
            if ~visitedAttractions(j) && optimalReward(j, timeslot+1) > maxReward
                maxReward = optimalReward(j, timeslot+1);
                selectedAttraction = j;
            end
        end
        %% Check if the selected attraction is valid
        if selectedAttraction > 0 && timeslot + WaitTimes{selectedAttraction}(timeslot) <= T % potentially issues with walk out times to exit?
            visitedAttractions(selectedAttraction) = 1;  % Mark the attraction as visited
            sequence(i) = selectedAttraction;
            timeslot = timeslot + WaitTimes{selectedAttraction}(timeslot); %potentially also need time dist, but wait times potentially also uses it
            disp(timeslot)
        end
    end
    %% The last attraction is the exit, cut off "0" attractions in sequence
    firstZeroIndex = find(sequence == 0, 1);
    sequence(firstZeroIndex) = M + 1;
    sequence = sequence(1:firstZeroIndex);
end


%Function for question 2
function [nextlocation,expreward] = eftelingpolicy(TimeDist,WaitDis,Pref)
    nextlocation = 0;
    expreward = 0;
end