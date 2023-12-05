%% Setup and generation of variables
T = 60;
M = 10;

% generate wait times (Q1) - in cells as specified
WaitTimes = cell(1, M);
    for i = 1:M
        % row vector with T entries, taking values from set
        WaitTimes{i} = randi([1, 5], 1, T) * 5;
    end

% generate Wait Dis (Q2) - in cells as specified
WaitDis = cell(1, M);
    for i = 1:M
        % Each entry denotes the probability that a waiting time occurs at a given time
        WaitDis{i} = rand(T, 5);
        % Normalize the rows
        WaitDis{i} = WaitDis{i} ./ sum(WaitDis{i}, 2);
    end
%% Simple test case
Pref        =  [2; 1; 5];
TimeDist    =  [0	5	10	20;
                5	0	5	10;
                10	5	0	10;
                20	10	10	0 ];
T = 60;
M = 3;
WaitTimes{1}  = [25	25	20	15	25	10	25	25	10	5	25	5	25	5	5	10	15	20	20	5	10	5	10	25	25	10	10	25	25	25	10	5	5	10	10	5	20	25	20	20	20	10	15	10	15	25	5	25	15	15	25	10	10	20	10	5	20	20	20	25];
WaitTimes{2}  = [10	25	5	5	10	15	25	15	20	15	20	15	20	10	25	5	20	10	5	10	25	10	10	15	15	25	10	5	10	25	15	25	20	10	25	10	20	20	15	5	5	5	5	5	25	5	20	15	20	20	15	10	20	20	25	25	10	5	5	15];
WaitTimes{3}  = [5	5	25	20	10	15	20	15	5	20	15	20	5	20	25	15	25	15	25	15	10	25	25	5	25	20	15	25	10	20	25	15	15	25	5	10	5	20	15	10	10	15	25	10	5	25	5	15	5	15	10	25	15	5	10	15	5	10	20	15];



