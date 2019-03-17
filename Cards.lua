--[[ RobCards card definitions, by mythricia@gmail.com ]]--

-- Contains card definitions
-- Cards need to define:
-- * Layout type (what type of card it is)
-- * Text tags for the layout
-- * Art tags for the layout

-- It's okay to omit tags that were defined in CardLayout
-- It's NOT okay to add tags that don't exist in CardLayout, it will crash / fail

local Cards = {}

--:: Component Cards
Cards.swordArm = {
    layout     = "Component",  -- Case sensitive, must match a layout name in CardLayouts

    -- Text tags
    text = {
        cardName        = "Sword Arm",
        augs        = 2,
        stats       = "0 AC / 3 HP / 0 HC",
        cardType    = "Component: Arm",

        attack1     = "Slash: Melee, Slashing",
        attackDesc1 = "+1 Damage when targeting a limb",
        heatCost1   = 1,
        attackDamage1 = 1,
    },

    -- Art tags
    art = {
        centerArt = "placeholder.png",
    }
}

Cards.plasmaBoltCannon = {
    layout     = "Component",  -- Case sensitive, must match a layout name in CardLayouts

    -- Text tags
    text = {
        cardName    = "Plasma Bolt Cannon",
        augs        = 0,
        stats       = "0 AC / 2 HP / 0 HC",
        cardType    = "Component: Arm",

        attack1     = "Zap: Ranged, Plasma",
        attackDesc1 = "Heat Cost is increased by 1 each time this is used successively.",
        heatCost1   = 2,
        attackDamage1 = 3,
    },

    -- Art tags
    art = {
        centerArt = "placeholder.png",
    }
}


-- Return the Cards table
return Cards