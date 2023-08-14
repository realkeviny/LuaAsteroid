local love = require "love"

--[[
    PARAMETERS:
    -> text: string - text to be displayed (required)
    -> x: number - x position of text (required)
    -> y: number - y position of text (required)
    -> font: Font - font to be used (required)
    -> fade_in: number - time in seconds for text to fade in (optional)
    -> fade_out: number - time in seconds for text to fade out (optional)
    -> wrap_width: number - width of text box (optional)
    -> align: string - alignment of text (optional)
    -> opacity: number - opacity of text (optional)
]]
function Text(text,x,y,font_size,fade_in,fade_out,wrap_width,align,opacity)
    font_size = font_size or "p"
    fade_in = fade_in or false
    fade_out = fade_out or false
    wrap_width = wrap_width or love.graphics.getWidth()
    align = align or "left"
    opacity = opacity or 1

    local TEXT_FADE_DUR = 6

    local fonts = {
        s1 = love.graphics.newFont(70),
        s2 = love.graphics.newFont(55),
        s3 = love.graphics.newFont(40),
        s4 = love.graphics.newFont(30),
        s5 = love.graphics.newFont(20),
        s6 = love.graphics.newFont(10),
        p = love.graphics.newFont(17)
    }

    if fade_in then
        opacity = 0.1
    end

    return {
        text = text,
        x = x,
        y = y,
        opacity = opacity,

        colors = {
            r = 1,
            g = 1,
            b = 1
        },

        setColor = function (self,red,green,blue)
            self.colors.r = red
            self.colors.g = green
            self.colors.b = blue
        end,

        draw = function (self,tbl_text,index)
            if self.opacity > 0 then
                if fade_in then
                    if self.opacity < 1 then
                        self.opacity = self.opacity + (1 / TEXT_FADE_DUR / love.timer.getFPS())
                    else
                        fade_in = false
                    end
                elseif fade_out then
                    self.opacity = self.opacity - (1 / TEXT_FADE_DUR / love.timer.getFPS())
                end
                
                love.graphics.setColor(self.colors.r,self.colors.g,self.colors.b,self.opacity)
                love.graphics.setFont(fonts[font_size])
                love.graphics.printf(self.text,self.x,self.y,wrap_width,align)
                love.graphics.setFont(fonts["p"])
            else
                table.remove(tbl_text,index)

                return false
            end

            return false
        end
    }
end

return Text