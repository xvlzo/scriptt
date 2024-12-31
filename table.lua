return {
    Triggerbot = {
        Enabled = false,         -- Default triggerbot state
        ClickDelay = 0,          -- Delay in seconds before the next click
        ToggleKey = "T",         -- Key to toggle triggerbot
        ActivationKey = "MouseButton2", -- Default activation key (X1 Mouse Button)
        Mode = "Hold",           -- Default mode: "Hold" or "Press"
    },
    SilentAim = {
        Enabled = true,          -- Enable or disable Silent Aim
        ToggleKey = "Q",         -- Key to toggle Silent Aim
        FOV = 70,                -- Field of view for targeting
        Prediction = 0.165,      -- Adjust prediction to match server latency
    },
    AimAssist = {
        Enabled = true,          -- Enable or disable Aim Assist
        ToggleKey = "E",         -- Key to toggle Aim Assist
        Smoothness = 0.5,        -- Adjusts how smooth the aim is (lower = faster, higher = slower)
        FOV = 100,               -- Field of view for targeting
        BodyPartPriority = {"Head", "Torso"}, -- Target body part priority
    },
    HitboxExpander = {
        Enabled = true,          -- Enable or disable Hitbox Expander
        X = 2,                   -- Hitbox expansion on X-axis
        Y = 2,                   -- Hitbox expansion on Y-axis
        Z = 2,                   -- Hitbox expansion on Z-axis
    },
    SafetyChecks = {
        WallCheck = true,        -- Ensure no targeting through walls
        KOCheck = true,          -- Avoid targeting knocked out players
        AntiCurve = true,        -- Prevent unnatural movement curves
    },
    Visuals = {
        Enabled = true,          -- Enable or disable visuals
        Streamproof = true,      -- Ensure visuals are not stream-visible
    },
}
