prev_location = 0
prev_clock = 0
prev_lives = 0
prev_score = 0
prev_coins = 0
prev_jump = 0

function reward(data)
    -- Calculate current location
    local current_location = (data.xscrollHi * 100 + data.xscrollLo)
    local velocity = current_location - prev_location

    local jumping = data.jump - prev_jump

    -- Calculate time change
    local clock = data.time
    local time_change = prev_clock - clock

    -- Initialize velocity reward
    local velocity_reward = 0

    -- Apply velocity reward only if time has changed
    if time_change ~= 0 then
        if velocity == 0 and jumping == 0 then
            velocity_reward = -1
        end
    end

    -- Update previous location, jump, and clock
    prev_location = current_location
    prev_jump = data.jump
    prev_clock = clock

    -- Determine time reward
    local time_reward = 0
    if time_change == 0 then
        time_reward = 0
    else
        time_reward = -1
    end

    -- Calculate change in lives
    local dead = data.lives - prev_lives

    -- Determine dead reward
    local dead_reward = 0
    if dead == -1 then
        dead_reward = -25
    else
        dead_reward = 0
    end

    -- Update previous lives
    prev_lives = data.lives

    -- Add bonus for points scored
    local score_reward = data.score - prev_score
    prev_score = data.score

    -- Coin reward
    local current_coins = data.coins
    local coin_reward = (current_coins - prev_coins) * 100
    prev_coins = current_coins

    -- Calculate total rewards
    local total_rewards = velocity_reward + score_reward + coin_reward + dead_reward
    return total_rewards
end
