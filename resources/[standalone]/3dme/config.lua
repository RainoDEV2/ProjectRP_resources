-- @desc Shared config file
-- @author Elio
-- @version 2.0

-- Global configuration
Config = {
    language = 'en',
    color = { r = 230, g = 230, b = 230, a = 255 }, -- Text color
    font = 0, -- Text font
    time = 5000, -- Duration to display the text (in ms)
    scale = 0.4, -- Text scale
    dist = 50, -- Min. distance to draw 
}

-- Languages available
Languages = {
    ['en'] = {
        commandName = 'me',
        commandDescription = 'Display an action above your head.',
        commandSuggestion = {{ name = 'action', help = '"picks up box" for example.'}},
        prefix = ''
    },
}
