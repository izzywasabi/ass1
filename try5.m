function optimal_sequence = findOptimalRideSequence(WaitTimes, WalkTime, WalkToExit, Preference)
    % Number of rides
    num_rides = length(WaitTimes);

    % Number of time slots
    num_slots = size(WaitTimes{1}, 2);

    % Initialize variables
    V = zeros(num_slots, num_rides + 1); % Value function matrix
    optimal_sequence = zeros(1, num_rides + 1); % Initialize optimal ride sequence

    % Dynamic programming - value iteration
    for t = num_slots:-1:1
        for ride = 1:num_rides
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

    % Find the optimal sequence using the optimal value function
    [~, optimal_exit] = max(V(1, :));
    optimal_sequence(1) = optimal_exit;

    for i = 2:num_rides + 1
        [~, prev_ride] = max(Preference);
        optimal_sequence(i) = prev_ride;
        Preference(prev_ride) = -inf; % Mark visited ride as unattractive
    end
end


% Example matrices (replace these with your actual data)
WaitTimes = cell(1, 10);  % Replace with actual wait time matrices
WalkTime = randi([5, 25], 10, 10);  % Replace with actual walk time matrix
WalkToExit = randi([5, 25], 1, 10);  % Replace with actual walk time to exit vector
Preference = randi([1, 5], 1, 10);  % Replace with actual preference vector

% Call the function
optimal_sequence = findOptimalRideSequence(WaitTimes, WalkTime, WalkToExit, Preference);

% Display the optimal sequence
disp('Optimal Ride Sequence:');
disp(optimal_sequence);
