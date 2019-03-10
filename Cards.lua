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
    _layout     = "Component",  -- Case sensitive, needs to EXACTLY match the name used in CardLayouts

    -- Text tags
    text = {
        name        = "Sword Arm",
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
        centerArt = "body_bg.png",
    }
}


-- Return the Cards table
return Cards