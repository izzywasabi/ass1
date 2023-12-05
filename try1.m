%% Setup and generation of variables
% T = 60;
% M = 10;
% 
% % generate wait times (Q1) - in cells as specified
% WaitTimes = cell(1, M);
%     for i = 1:M
%         % row vector with T entries, taking values from set
%         WaitTimes{i} = randi([1, 5], 1, T) * 5;
%     end
% % generate Wait Dis (Q2) - in cells as specified
% WaitDis = cell(1, M);
%     for i = 1:M
%         % Each entry denotes the probability that a waiting time occurs at a given time
%         WaitDis{i} = rand(T, 5);
%         % Normalize the rows
%         WaitDis{i} = WaitDis{i} ./ sum(WaitDis{i}, 2);
%     end
% 
% % From assignment
% TimeDist = [0	5	10	20	15	20	20	25	10	15	25;
%             5	0	5	10	15	15	10	15	10	20	20;
%             10	5	0	10	15	15	10	10	5	10	15;
%             20	10	10	0	5	5	5	10	15	20	15;
%             15	15	15	5	0	5	10	15	20	25	20;
%             20	15	15	5	5	0	10	15	20	25	20;
%             20	10	10	5	10	10	0	5	15	25	10;
%             25	15	10	10	15	15	5	0	15	20	5 ;
%             10	10	5	15	20	20	15	15	0	5	15;
%             15	20	10	20	25	25	25	20	5	0	15;
%             25	20	15	15	20	20	10	5	15	15	0 ];
% Pref = [3; 3; 2; 4; 3; 5; 1; 2; 2; 5];

%% Simple test case
% Pref = [2; 1; 5];
% TimeDist = [0	5	10	20;
%             5	0	5	10	;
%             10	5	0	10;
%             20	10	10	0 ];
% T = 60;
% M = 3;
% WaitTimes{1} = [25	25	20	15	25	10	25	25	10	5	25	5	25	5	5	10	15	20	20	5	10	5	10	25	25	10	10	25	25	25	10	5	5	10	10	5	20	25	20	20	20	10	15	10	15	25	5	25	15	15	25	10	10	20	10	5	20	20	20	25];
% WaitTimes{2} = [10	25	5	5	10	15	25	15	20	15	20	15	20	10	25	5	20	10	5	10	25	10	10	15	15	25	10	5	10	25	15	25	20	10	25	10	20	20	15	5	5	5	5	5	25	5	20	15	20	20	15	10	20	20	25	25	10	5	5	15];
% WaitTimes{3} = [5	5	25	20	10	15	20	15	5	20	15	20	5	20	25	15	25	15	25	15	10	25	25	5	25	20	15	25	10	20	25	15	15	25	5	10	5	20	15	10	10	15	25	10	5	25	5	15	5	15	10	25	15	5	10	15	5	10	20	15];

%% Pretest 1
TimeDist = [ 0 10 20 10 10;
            10  0 15 25 10;
            20 15  0  5 10;
            10 25  5  0 15;
            10 10 10 15  0];

Pref = [3 1 5 2];

WaitTimes = cell(4,1);
WaitTimes{1} = [5 5 5 5 5 10 10 10 10 10 15 15 15 15 15];
WaitTimes{2} = [10 10 10 10 10 15 15 15 15 15 5 5 5 5 5];
WaitTimes{3} = [5 5 5 5 5 25 25 25 25 25 20 20 20 20 20];
WaitTimes{4} = [10 10 10 10 10 5 5 5 5 5 15 15 15 15 15];
%% Pretest 2
TimeDist = [ 0  5 10 20 15 20 20 25 10 15 25;
             5  0  5 10 15 15 10 15 10 20 20;
            10  5  0 10 15 15 10 10  5 10 15;
            20 10 10  0  5  5  5 10 15 20 15;
            15 15 15  5  0  5 10 15 20 25 20;
            20 15 15  5  5  0 10 15 20 25 20;
            20 10 10  5 10 10  0  5 15 25 10;
            25 15 10 10 15 15  5  0 15 20  5;
            10 10  5 15 20 20 15 15  0  5 15;
            15 20 10 20 25 25 25 20  5  0 15;
            25 20 15 15 20 20 10  5 15 15  0];

Pref = [3 3 2 4 3 5 1 2 2 5];

WaitTimes = cell(10,1);
for i=1:10
    WaitTimes{i} = 15*ones(1,40);
end

%% Request results for testing
[optimalattractionsequence]=eftelingplan(TimeDist,WaitTimes,Pref)
%[nextlocation,expreward]=eftelingpolicy(TimeDist,WaitDis,Pref);

%% Functions

%Function for question 1
function [optimalattractionsequence] = eftelingplan(TimeDist,WaitTimes,Pref)
    M = length(Pref);           % Number of attractions
    T = length(WaitTimes{1});   % Number of time slots

    for t = 1:T
        WaitTimes{M+1} = zeros(1,T);
    end
    
    for t = 1:T
        for from = 1:M+1
            for to = 1:M+1
                if t + TimeDist(from, to) > T || (from == to && from ~= M+1)
                    timeTot{t}(from,to) = inf;
                else
                    timeTot{t}(from,to) = TimeDist(from, to)/5 + WaitTimes{to}(t)/5;
                end
            end
        end
    end

    attractions = 1:M;

    maxLength = length(attractions);

    % Generate all combinations
    allCombinations = [];
    for k = 1:maxLength
        combinationsOfLengthK = nchoosek(attractions, k);
        
        permutationsOfLengthK = [];
        % Generate all permutations for each combination
        for i = 1:length (combinationsOfLengthK(:,1))
            permutationsOfLengthK = [permutationsOfLengthK; perms(combinationsOfLengthK(i,:));];
        end
        
        % Pad with zeros to make all combinations the same length
        paddingSize = maxLength - k;
        paddedPermutations = [permutationsOfLengthK, zeros(size(permutationsOfLengthK, 1), paddingSize)];
        
        allCombinations = [allCombinations; paddedPermutations];
    end

    allCombinations = [(M+1)*ones(1,length(allCombinations))' allCombinations];
    
    % trueCombos = [];
    rewardCombo = [];
    timeCombo = [];
    for i = 1:length(allCombinations)
        considered = allCombinations(i,:);
        firstZeroIndex = find(considered == 0, 1);
        if isempty(firstZeroIndex)
            firstZeroIndex = length(considered)+1;
        end
        reward = 0;
        time = 1;
        for j = 2:firstZeroIndex-1
            reward = reward + Pref(considered(j));
            if time ~= inf
                time = time + timeTot{time}(considered(j-1), considered(j));
            end
        end
        if time ~= inf

            time = time + timeTot{time}(considered(firstZeroIndex-1), M+1);
            rewardCombo(i) = reward;
            timeCombo(i) = time;
            % if time <= T
            %     trueCombos = [trueCombos; considered];
            %     rewardCombo = [rewardCombo; reward];
            % end
        end
    end

    %get all best rewards that fall within time limit
    maxReward = max(rewardCombo);
    maxIndices = find(rewardCombo == maxReward);
    sequence = [];
    for i = 1:length(maxIndices)
        if timeCombo(i) <= T
            sequence = [sequence; allCombinations(maxIndices(i),:)];
        end
    end
    %there may be more than one best path, so choose the one with the
    %lowest choices first
    if length(sequence(:,1))>1
        sortedSeq = sortrows(sequence);
        sequence = sortedSeq(1,:);
    end
    
    firstZeroIndex = find(sequence == 0, 1);
    optimalattractionsequence = [sequence(2:firstZeroIndex-1), M+1];
    
    % %This is bad I know, but just for testing, just visits highest
    % preferece first
    % [B,sequence] = sort(Pref,'descend');
    % sequence = [M+1; sequence(:)];
    % optimalattractionsequence = 1;
    % time = 1;
    % for i = 2:length(sequence)
    %     if time + timeTot{time}(i-1,M+1) >= T ||  time + timeTot{time}(i-1,i) == inf
    %         sequence(i) = M+1;
    %         optimalattractionsequence = sequence(2:i)';
    %         break
    %     else
    %         time = time + timeTot{time}(i-1,i);
    %     end
    % 
    % end
    % if time < T && optimalattractionsequence(end) ~= M+1
    %     optimalattractionsequence = [sequence(2:end); M+1]';
    % end
    % test =1;

    % M = length(Pref);           % Number of attractions
    % T = length(WaitTimes{1});   % Number of time slots

    % NOTE: I also tried DP, but I never finished it
    % a = 10;  % variable cost bumper
    % 
    % %stage 1
    % for k = 1:M+1
    %     if k == M+1
    %         C{1}{M+1}{k} = [0;1];
    %     else
    %         C{1}{M+1}{k} = [WaitTimes{k}(1) + TimeDist(M+1, k) - Pref(k)*a; (WaitTimes{k}(1) + TimeDist(M+1, k))/5];
    %     end
    %     A{1}{M+1}{k} = k;
    % end
    % % stage 2
    % for j = 1:M+1
    %     for k = 1:M+1
    %         if k == M+1
    %             C{2}{j}{k} = [TimeDist(j,k),(C{1}{M+1}{j}(2))];
    %         else
    %             C{2}{j}{k} = [WaitTimes{k}(C{1}{M+1}{j}(2)) + TimeDist(j, k) - Pref(k)*a; (WaitTimes{k}(C{1}{M+1}{j}(2)) + TimeDist(j, k))/5 + C{1}{M+1}{j}(2)];
    %         end
    %         A{2}{j}{k} = k;
    %     end
    % end
    % %stage 3 to M
    % for i = 3:M+1
    %     for j = 1:M+1
    %         for k = 1:M+1
    %             if (C{i-1}{ A{i-1}{j}{k} }{j}(2) +  TimeDist(j, M+1) >= T) %if it will go over time, go to exit
    %                 if (C{i-1}{ A{i-1}{j}{k} }{j}(2) >= T) % if old time already over time
    %                     C{i}{j}{k} = C{i-1}{ A{i-1}{j}{k} }{j};  %keep same time
    %                 else % if new time will go over time, go to exit
    %                     C{i}{j}{k} = [WaitTimes{k}(C{i-1}{ A{i-1}{j}{k} }{j}(2)) + TimeDist(j, k) - Pref(k)*a; (WaitTimes{k}(C{i-1}{ A{i-1}{j}{k} }{j}(2)) + TimeDist(j, k))/5 + C{i-1}{ A{i-1}{j}{k} }{j}(2)]; %go to exit, go not pass go. Do not collect 200
    %                 end
    %                 A{i}{j}{k} = 1;
    %             else
    %                 if k == M+1
    %                     C{i}{j}{k} = [TimeDist(j,k),C{1}{M+1}{j}(2)];
    %                 else
    %                     C{i}{j}{k} = [WaitTimes{k}(C{i-1}{ A{i-1}{j}{k} }{j}(2)) + TimeDist(j, k) - Pref(k)*a; (WaitTimes{k}(C{i-1}{ A{i-1}{j}{k} }{j}(2)) + TimeDist(j, k))/5 + C{i-1}{ A{i-1}{j}{k} }{j}(2)];
    %                 end
    %             end
    % 
    %             if (i == M+1)
    %                 A{i}{j}{k} = 1;
    %             else
    %                 A{i}{j}{k} = k;
    %             end
    %         end
    %     end
    % end   
    % 
    % % Dynamic programming (mostly copy paste dp.mlx)
    % h = length(A);
    % J_{h+1}{1} = 0;
    % for k = h:-1:1
    %     ni = length(A{k}); % state dimension
    %     for i=1:ni
    %         if k == 1
    %             nj = length(A{k}{M+1});
    %             caux = zeros(1,nj);
    %             for j = 1:nj
    %                 caux(j) = C{k}{M+1}{j}(1) + J_{k+1}{A{k}{M+1}{j}};
    %             end
    %             [a,b] = sort(caux);
    %             J_{k}{i} = a(1); J{k}{i} = J_{k}{i};
    %             u{k}{i} = b(1);
    %         else
    %             nj = length(A{k}{i});
    %             caux = zeros(1,nj);
    %             for j = 1:nj
    %                 caux(j) = C{k}{i}{j}(1) + J_{k+1}{A{k}{i}{j}};
    %             end
    %             [a,b] = sort(caux);
    %             J_{k}{i} = a(1); J{k}{i} = J_{k}{i};
    %             u{k}{i} = b(1);
    %         end
    %     end
    % end

    % NOTE: Original attempt with some modifications, but is somewhere very
    % wrong because there should be way more attractions visited
    % M = length(Pref);           % Number of attractions
    % T = length(WaitTimes{1});   % Number of time slots
    % 
    % % Initialize optimal sequence array starting from 0
    % sequence = zeros(1, M+2);
    % sequence(1)= M+1; %start at exit
    % 
    % % Initialize optimal reward array
    % optimalReward = zeros(M+1, T+1);
    % 
    % % Set to keep track of visited attractions
    % visitedAttractions = zeros(1, M);
    % 
    % % Dynamic programming loop
    % for index = M:-1:2
    %     for time = 1:T
    %         % Calculate max reward for current index, time
    %         if time + WaitTimes{index}(time)/5 <= T
    %             if index == 2   
    %                 reward_with_current = Pref(index) + optimalReward(index+1, time+WaitTimes{index}(time)/5);
    %                 reward_without_current = optimalReward(index+1, time);
    %                 distance_penalty = TimeDist(M+1, index+1)/5;
    %                 optimalReward(index, time+1) = max(reward_with_current - distance_penalty, reward_without_current);
    %             else
    %             reward_with_current = Pref(index) + optimalReward(index+1, time+WaitTimes{index}(time)/5);
    %             reward_without_current = optimalReward(index+1, time);
    %             distance_penalty = TimeDist(sequence(index-1)+1, index+1)/5; % Corrected this line
    %             optimalReward(index, time+1) = max(reward_with_current - distance_penalty, reward_without_current);
    %             end
    %         else
    %             optimalReward(index, time+1) = optimalReward(index+1, time);
    %         end
    %     end
    % end
    % 
    % % Backtrack to find the optimal sequence
    % time = 1;
    % for i = 2:M
    %     % Find the attraction with the maximum reward among unvisited attractions
    %     maxReward = -inf;
    %     selectedAttraction = 0;
    % 
    %     %if the time is too great, end
    %     if time > T 
    %         break
    %     end
    % 
    %     for j = 1:M
    %         if ~visitedAttractions(j) && optimalReward(j, time+1) > maxReward
    %             maxReward = optimalReward(j, time+1);
    %             selectedAttraction = j;
    %         end
    %     end
    % 
    %     % Check if the selected attraction is valid
    %     if selectedAttraction > 0 && sequence(i-1) ~= 0 && time + WaitTimes{selectedAttraction}(time) + TimeDist(sequence(i-1), selectedAttraction) <= T % potentially issues with walk out times to exit?
    %         visitedAttractions(selectedAttraction) = 1;  % Mark the attraction as visited
    %         sequence(i) = selectedAttraction;
    %         time = time + WaitTimes{selectedAttraction}(time) + TimeDist(sequence(i-1), selectedAttraction);
    %     end
    % end
    % 
    % % The last attraction is the exit, cut off "0" attractions in sequence
    % firstZeroIndex = find(sequence == 0, 1);
    % sequence(firstZeroIndex) = M + 1;
    % optimalattractionsequence = sequence(2:firstZeroIndex); % remove start from sequence
end

%Function for question 2
function [nextlocation,expreward] = eftelingpolicy(TimeDist,WaitDis,Pref)
    nextlocation = 0;
    expreward = 0;
end