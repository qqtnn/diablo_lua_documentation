local my_utility = require("my_utility/my_utility")

local blood_howl_elements =
{
    main_tab            = tree_node:new(1),
    main_boolean        = checkbox:new(true, get_hash(my_utility.plugin_label .. "disable_enable_ability")),
}

local function menu()

    if blood_howl_elements.main_tab:push("Blood Howl")then
        blood_howl_elements.main_boolean:render("Enable Spell", "")
 
        blood_howl_elements.main_tab:pop()
    end
end

local next_time_allowed_cast = 0.0;
local spell_id_blood_howls = 566517;
local function logics()

    local menu_boolean = blood_howl_elements.main_boolean:get();
    local is_logic_allowed = my_utility.is_spell_allowed(
                menu_boolean, 
                next_time_allowed_cast, 
                spell_id_blood_howls);

    if not is_logic_allowed then
        return false;
    end;

   if cast_spell.self(spell_id_blood_howls, 0.1) then

    local current_time = get_time_since_inject();
    next_time_allowed_cast = current_time + 0.2;

    console.print("Druid Plugin, Casted Blood Howls");
        return true;
    end;
    
    return false;
end;

return
{
    menu = menu,
    logics = logics,   
}
