local my_utility = require("my_utility/my_utility")

local cold_imb_menu_elements_base = 
{
    main_tab           = tree_node:new(1),
    main_boolean       = checkbox:new(true, get_hash(my_utility.plugin_label .. "cold_imb_main_bool_base")),
    only_elite_or_boss = checkbox:new(true, get_hash(my_utility.plugin_label .. "cold_imb_only_elite_or_boss_boolean")),
}

local function menu()                                                                              
    if cold_imb_menu_elements_base.main_tab:push("Cold Imbuement") then
        cold_imb_menu_elements_base.main_boolean:render("Enable Spell", "")
        cold_imb_menu_elements_base.only_elite_or_boss:render("Only Elite or Boss", "")
        cold_imb_menu_elements_base.main_tab:pop()
    end
end

local spell_id_bold_imb = 359246
local next_time_allowed_cast = 0.0

local function logics(target)
    local menu_boolean = cold_imb_menu_elements_base.main_boolean:get()
    local is_logic_allowed = my_utility.is_spell_allowed(
        menu_boolean, 
        next_time_allowed_cast, 
        spell_id_bold_imb
    )

    if not is_logic_allowed then
        return false
    end

    if cold_imb_menu_elements_base.only_elite_or_boss:get() then
        local special_found = false

        local enemies = target_selector.get_near_target_list(get_player_position(), 12)
        for _, enemy in pairs(enemies) do
            local is_special = enemy:is_champion() or enemy:is_elite() or enemy:is_boss()
            if is_special then
                special_found = true
            end
        end

        if not special_found then
            console.print("We didn't get any special boys")
            return false
        end
    end

    if cast_spell.self(spell_id_bold_imb, 0.0) then
        local current_time = get_time_since_inject()
        next_time_allowed_cast = current_time + 0.2
        console.print("Rouge Plugin, Casted Cold Imb")
        return true
    end

    return false
end

return {
    menu = menu,
    logics = logics,
}
