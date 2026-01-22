local userpatch = require("userpatch")
local _ = require("gettext")
local T = require("ffi/util").template

-- This function patches the "Menu" widget base class
local function patchMenu(Menu)
    
    -- 1. Intercept init to change the buttons
    local orig_init = Menu.init
    function Menu:init()
        -- First, override the icon names BEFORE init runs.
        -- This is cleaner than trying to change them after creation.
        -- We temporarily swap the global icon strings if possible, 
        -- or we just let init run and then modify the buttons.
        
        orig_init(self)
        
        -- Modify the buttons after they are created
        if self.page_info_left_chev then
            self.page_info_left_chev.icon = nil
            self.page_info_left_chev:setText("•")
            -- Optional: Make them smaller or larger
            -- self.page_info_left_chev.text_face = Font:getFace("cfont", 20) 
        end
        
        if self.page_info_right_chev then
            self.page_info_right_chev.icon = nil
            self.page_info_right_chev:setText("•")
        end
        
        if self.page_info_first_chev then
            self.page_info_first_chev.icon = nil
            self.page_info_first_chev:setText("••")
        end
        
        if self.page_info_last_chev then
            self.page_info_last_chev.icon = nil
            self.page_info_last_chev:setText("••")
        end
    end

    -- 2. Intercept updatePageInfo to change the text "Page X of Y"
    local orig_updatePageInfo = Menu.updatePageInfo
    function Menu:updatePageInfo(select_number)
        -- Call original first to handle logic (enabling/disabling buttons)
        orig_updatePageInfo(self, select_number)
        
        -- Now overwrite the text with our minimal version
        if self.page_info_text then
            if self.page_num > 0 then
                -- Change "Page 1 of 50" to "1 / 50"
                self.page_info_text:setText(string.format("%d / %d", self.page, self.page_num))
            else
                -- Keep "No items" or whatever strictly, or make it empty
                -- self.page_info_text:setText("-")
            end
        end
    end
end

-- Apply the patch
local Menu = require("ui/widget/menu")
patchMenu(Menu)