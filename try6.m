function optimal_sequence = findOptimalRideSequence(WaitTimes, WalkTime, WalkToExit, Preference, max_time_slots)
    % Initialize variables
    num_rides = length(Preference);
    optimal_sequence = [];
    max_reward = 0;

    % Iterate through different numbers of rides to visit
    for num_rides_to_visit = 1:num_rides
        % Dynamic programming - value iteration
        V = zeros(max_time_slots + 1, num_rides_to_visit + 1);

        for t = max_time_slots:-1:1
            for ride = 1:num_rides_to_visit
                % Calculate the immediate reward for each action
                immediate_reward = Preference(ride);

                % Calculate the expected future reward by considering the next state
                next_state_values = V(t + 1, :);

                % Calculate the total value for each action
                total_value = immediate_reward + sum(WaitTimes{ride}(:, t) + WalkTime(ride, :) + next_state_values);

                % Update the value function
                V(t, ride) = total_value;
            end
        end

        % Find the optimal sequence within the specified maximum time
        [~, optimal_exit] = max(V(1, :));

        % Check if the current configuration has higher reward
        if V(1, optimal_exit) > max_reward
            max_reward = V(1, optimal_exit);
            optimal_sequence = [optimal_exit];
            for i = 1:num_rides_to_visit
                [~, prev_ride] = max(Preference);
                optimal_sequence = [optimal_sequence, prev_ride];
                Preference(prev_ride) = -inf; % Mark visited ride as unattractive
            end
        end
    end
end

% Matrices
WaitTimes{1}  = [25	25	20	15	25	10	25	25	10	5	25	5	25	5	5	10	15	20	20	5	10	5	10	25	25	10	10	25	25	25	10	5	5	10	10	5	20	25	20	20	20	10	15	10	15	25	5	25	15	15	25	10	10	20	10	5	20	20	20	25;
10	25	5	5	10	15	25	15	20	15	20	15	20	10	25	5	20	10	5	10	25	10	10	15	15	25	10	5	10	25	15	25	20	10	25	10	20	20	15	5	5	5	5	5	25	5	20	15	20	20	15	10	20	20	25	25	10	5	5	15;
5	5	25	20	10	15	20	15	5	20	15	20	5	20	25	15	25	15	25	15	10	25	25	5	25	20	15	25	10	20	25	15	15	25	5	10	5	20	15	10	10	15	25	10	5	25	5	15	5	15	10	25	15	5	10	15	5	10	20	15;
25	25	20	15	25	10	25	25	10	5	25	5	25	5	5	10	15	20	20	5	10	5	10	25	25	10	10	25	25	25	10	5	5	10	10	5	20	25	20	20	20	10	15	10	15	25	5	25	15	15	25	10	10	20	10	5	20	20	20	25;
10	25	5	5	10	15	25	15	20	15	20	15	20	10	25	5	20	10	5	10	25	10	10	15	15	25	10	5	10	25	15	25	20	10	25	10	20	20	15	5	5	5	5	5	25	5	20	15	20	20	15	10	20	20	25	25	10	5	5	15;
5	5	25	20	10	15	20	15	5	20	15	20	5	20	25	15	25	15	25	15	10	25	25	5	25	20	15	25	10	20	25	15	15	25	5	10	5	20	15	10	10	15	25	10	5	25	5	15	5	15	10	25	15	5	10	15	5	10	20	15;
25	25	20	15	25	10	25	25	10	5	25	5	25	5	5	10	15	20	20	5	10	5	10	25	25	10	10	25	25	25	10	5	5	10	10	5	20	25	20	20	20	10	15	10	15	25	5	25	15	15	25	10	10	20	10	5	20	20	20	25;
10	25	5	5	10	15	25	15	20	15	20	15	20	10	25	5	20	10	5	10	25	10	10	15	15	25	10	5	10	25	15	25	20	10	25	10	20	20	15	5	5	5	5	5	25	5	20	15	20	20	15	10	20	20	25	25	10	5	5	15;
5	5	25	20	10	15	20	15	5	20	15	20	5	20	25	15	25	15	25	15	10	25	25	5	25	20	15	25	10	20	25	15	15	25	5	10	5	20	15	10	10	15	25	10	5	25	5	15	5	15	10	25	15	5	10	15	5	10	20	15;
5	5	25	20	10	15	20	15	5	20	15	20	5	20	25	15	25	15	25	15	10	25	25	5	25	20	15	25	10	20	25	15	15	25	5	10	5	20	15	10	10	15	25	10	5	25	5	15	5	15	10	25	15	5	10	15	5	10	20	15];
WalkTime    =  [0	5	10	20	15	20	20	25	10	15	25;
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
WalkToExit =   [25	20	15	15	20	20	10	5	15	15	0 ];  
Preference = [3; 3; 2; 4; 3; 5; 1; 2; 2; 5];  
max_time_slots = 60;

% Call
optimal_sequence = findOptimalRideSequence(WaitTimes, WalkTime, WalkToExit, Preference, max_time_slots);

% Display the optimal sequence
disp('Optimal Ride Sequence:');
disp(optimal_sequence);
