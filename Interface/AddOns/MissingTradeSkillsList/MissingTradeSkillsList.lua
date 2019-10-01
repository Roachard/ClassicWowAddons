---------------------
-- Start the addon --
---------------------

-- Intialise our fonts
MTSLUI_FONTS:Initialise()

-- Initialise our event handler
MTSLUI_EVENT_HANDLER:Initialise()

-- Add slash command for addon & use eventhandler to handle it
SLASH_MTSL1 = "/mtsl"
function SlashCmdList.MTSL (msg, editbox)
    MTSLUI_EVENT_HANDLER:SLASH_COMMAND(msg)
end
