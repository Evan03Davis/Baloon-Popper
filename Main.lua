--# Main
function setup()
 B={} -- Table to hold Balloons
 A={} -- Table to hold Arrows 
    x = 50
    y = HEIGHT/2
    width = 40
    height = 50
    speed = 10
 arrowWidth=40 
 arrowStartX=50 --Where the arrow starts when screen is tapped
 arrowX=-1
 arrowY=HEIGHT/2 
 arrowSpeed=10
 arrowColor=color(61, 247, 22, 255)
 score=0
 lives=10
 state="menu"
 theme="dark"
 gameLive=true
 gameover=false
 highScoreYES=false
 infobuttonX=500
 infobuttonY=650
 infoTint=color(255, 19, 0, 255)
 --x=arrowX+arrowWidth --calculate right hand position, for collision testing
 -- HIGH SCORE GOES HERE --
 highScore=readLocalData("highScore")
 if highScore==nil 
 then
 highScore=0
 end
 balloonFrequency=1 --number of balloons released per second
 timer=0 --initialise timer
 parameter.action("Close", function() close() end)
 parameter.action("Play", function() state=hi  end)
------------------------------------------------------------------------------------------------------------
  displayMode(FULLSCREEN)
  supportedOrientations(LANDSCAPE_RIGHT)
-- Button settings
    menuButtons = {
        Button("Exit", WIDTH*.50, HEIGHT*.40, color(255, 0, 0, 255), function() close() end),
        Button("⚙", WIDTH*.50, HEIGHT*.20, color(100, 255), function() state="settings" end),
        Button("Play", WIDTH*.50, HEIGHT*.55, color(255, 0, 0, 0), function() state="gameON" end),
       }
    gameButtons = {
        Button("<-", WIDTH*.10, HEIGHT*.90, color(100, 255), function() state="menu" end),
       }
    settingButtons = {
         Button("<-", WIDTH*.10, HEIGHT*.90, color(100, 255), function() state="menu" end),
         Button("Clear HighScore", WIDTH*.5, HEIGHT*.1, color(100, 25), function() clearLocalData() restart() end),    Button("<-", WIDTH*.4, HEIGHT*.3, color(100, 25), function() balloonFrequency=balloonFrequency-(.5) end),    Button("->", WIDTH*.6, HEIGHT*.3, color(100, 25), function() balloonFrequency=balloonFrequency+(.5) end),    Button("Dark", WIDTH*.2, HEIGHT*.5, color(100, 100, 100, 255), function() theme = "dark" end),
         Button("Light", WIDTH*.5, HEIGHT*.5, color(200, 200, 200, 255), function() theme = "light" end),
         Button("Green", WIDTH*.8, HEIGHT*.5, color(0, 200, 0, 255), function() theme = "weird" end),
       }
    infoButtons = { 
         Button("<-", WIDTH*.10, HEIGHT*.90, color(100, 255), function() state="menu" end),
       }
-------------------------------------------------------------------------------------------------------------
    
     -- Switches
    ctlSwitchView = Control("Switch", WIDTH*.5, HEIGHT*.8, 200, 110)
    ctlSwitchView.enabled = false
    ctlSwitchView.background = color(255, 255, 255, 255)
    switch = Switch("Switch", WIDTH*.45, HEIGHT*.7, 100, 100, callback)

end


--# FunctionDraw
function draw()
if lives<=0 then state="gameOVER"
end
if theme=="dark" then background(0, 0, 0, 255)   
elseif theme =="light" then background(255, 255, 255, 255)
elseif theme == "weird" then background(88, 255, 0, 255) arrowColor=color(0, 0, 0, 255)
end
pushStyle()
 timer=timer+DeltaTime --update timer

 if timer>=1/balloonFrequency --is it time for a new balloon?
 and state=="gameON"
 then
 LaunchBalloon() LaunchArrow() --launch next balloon

 timer=0 --reset timer
 ------------------------------------------------------------------------------------------------------------ 
 -- If you get score of 50 then give more lives
  if score==50 then lives=lives+15
 -- HIGH SCORE SETTINGS --
  elseif score>=highScore then
        highScore=score
        saveLocalData("highScore",score)
 -- Make score over 50 so it does not keep adding lives   
 if score==50 then score=51
 -- If score=10 increase diffaculty
 if score==10 then balloonFrequency=1
 -- If diffuculty is harder, then give more lives
 if balloonFrequency==1 then lives=15
 ------------------------------------------------------------------------------------------------------------
end
end
end
end
end
------------------------------------------------------------------------------------------------------------ 
if state == "menu" then
 for i,v in ipairs(menuButtons) do
 fontSize(50)
 v:draw()
 fill(255, 0, 0, 255)
 fontSize(50)
 text("Baloon Popper:",WIDTH*.5, HEIGHT*.7)
 table.remove(B,1)
    pushStyle()
 fill(infoTint)
 ellipse(infobuttonX,infobuttonY,100)
 popStyle()
            
 pushStyle()
 fill(0, 0, 0, 255) 
 text("i",infobuttonX,infobuttonY)
 popStyle()
end
popStyle()
pushStyle()
elseif state=="settings" then
    for i,v in ipairs(settingButtons) do
    fontSize(50)
    v:draw()
    switch:draw()
    text("Max Speed",WIDTH*.5,HEIGHT*.4)
    text(balloonFrequency,WIDTH*.5,HEIGHT*.3)
end
elseif state == "gameON" then
 for i,v in ipairs(gameButtons) do
 fontSize(50)
 v:draw()
 -- Draws the score on the screen!
 fill(255, 0, 0, 255)    
 fontSize(50)  
 text(score,WIDTH*.90,HEIGHT*.87)
 -- Puts text on top of the screen!
 fill(255, 0, 0, 255)
 fontSize(50)
 text("Score:",WIDTH*.90,HEIGHT*.95)
 --Draws the Lives left on the screen!
 fill(255, 0, 3, 255)
 fontSize(50)
 text(lives,WIDTH*.10,HEIGHT*.73)
 fill(255, 0, 0, 255)
 fontSize(50)
 text("Lives:",WIDTH*.10,HEIGHT*.80)
 fill(255, 0, 0, 255) 
   fontSize(25)
   text("HighScore:",WIDTH*.10,HEIGHT*.67)
   text(highScore,WIDTH*.10,HEIGHT*.63)
end
elseif state=="gameOVER" then 
 background(0, 0, 0, 255)   gameLive=false
 fontSize(100)
 text("GAME OVER!",WIDTH*.5,HEIGHT*.6) 
 text("Tap to restart",WIDTH*.5,HEIGHT*.4)
     
elseif state=="info" then 
 for i,v in ipairs(infoButtons) do
 fontSize(50)
 v:draw() 
 pushStyle()
  --textWrapWidth(600)
 fill(255, 255, 255, 255)
 text("Nothing to see here!",WIDTH/2,HEIGHT*.5)
end 
end
   ------------------------------------------------------------------------------------------------------
-- draw the arrow, if there is one, first adjust position
 if arrowX>0  --arrow exists
then
 arrowX=arrowX+arrowSpeed --adjust position
if arrowX>WIDTH then arrowX=-1 --delete if off the screen
end 

 x=arrowX+arrowWidth --calculate right hand position, for collision testing

else x=0 --set to 0 if no arrow, so we don't get an error when collision testing
end

if arrowX>0 --if we still have an arrow, draw it
then
stroke(arrowColor)
strokeWidth(3)
line(arrowX,arrowY,arrowX+arrowWidth,arrowY)
end

popStyle() --put this here to reset the strokeWidth etc before we draw balloons
pushStyle() --store style settings
 --loop through all balloons, adjusting position, checking for collisions etc
 --i gives us the index number of each balloon in the table
 --b gives us the information for each balloon
 for i,b in pairs(B) do

 b.y=b.y+b.s/60 --adjust y position using speed
 -- Makes you able to lose Lives
 if b.y >= HEIGHT and b.y <= HEIGHT+1 then lives=lives-(1)
end
 if b.y-b.h/2>HEIGHT then table.remove(B,i) end --delete balloon if it goes off screen
 fill(b.c) --set colour for this balloon
 ellipse(b.x,b.y,b.w,b.h)

 --check for collision with arrow
 if x>b.x-b.w/2 and x<=b.x+b.w/2 and
 arrowY>b.y-b.h/2 and arrowY<=b.y+b.h/2 then
 score=score+1 
 table.remove(B,i) --delete this balloon
 arrowX=-1 --reset balloon and arrow
popStyle()--restore style

end
end
end  



--# Touch
function touched(touch)
    


    if state=="gameON" and touch.state==BEGAN then arrowX=arrowStartX arrowY=touch.y
    elseif state=="gameOVER" and touch.state==BEGAN then restart()
    elseif state=="settings" and switch:touched(touch) then print("hi")
    end

     if state=="menu" and 
        touch.x >= infobuttonX-(50) and
        touch.x <= infobuttonX+(50) and
        touch.y >= infobuttonY-(50) and
        touch.y <= infobuttonY+(50) then
     if touch.state==BEGAN or touch.state==MOVING then 
        state="info"
        end
        
    
        
end
------------------------------------------------------------------------------------------------------------
    -- arrowX=arrowStartX
------------------------------------------------------------------------------------------------------------       
    if (state == "menu") then 
        for i,v in ipairs(menuButtons) do
            v:touched(touch)
end
    elseif (state == "gameON") then
        for i,v in ipairs(gameButtons) do
            v:touched(touch)
end         
    elseif state == "settings" then 
             for i,v in ipairs(settingButtons) do
             v:touched(touch)
end
    elseif state == "info" then
             for i,v in ipairs(infoButtons) do
             v:touched(touch)
end
end    
end

--# Button
Button = class()

function Button:init(t,x,y,col,cb)
    -- you can accept and set parameters here
    self.text = t
    self.x = x
    self.y = y
    self.color = col
    self.callback = cb or function() 
end
end

function Button:draw()
    -- Codea does not automatically call this method
    rectMode(CENTER)
    fill(255, 0, 12, 255)
    rect(self.x, self.y, string.len(self.text)*fontSize()-(1), fontSize()*1.75)
    textMode(CENTER)
    fill(18, 0, 255, 255)
    text(self.text, self.x, self.y)
end

function Button:touched(touch)
    -- Codea does not automatically call this method
    if (touch.x > self.x-string.len(self.text)*fontSize()/2 and
    touch.x < self.x+string.len(self.text)*fontSize()/2 and
    touch.y > self.y-string.len(self.text)*fontSize()/2 and
    touch.y < self.y+string.len(self.text)*fontSize()/2 and
    touch.state == BEGAN) then
        sound(SOUND_PICKUP, 14256)
        self.callback()
end
end

--# LaunchBalloon
function LaunchBalloon() 
 b={} --a table to hold details of our new balloon
 b.x=math.random(100,WIDTH)

 b.y=0

 b.w = math.random(30,80) --width
 --make height dependent on width, to keep the proportions reasonable
 b.h = math.random(b.w, b.w*1) --height
 b.s = math.random(100,100) --speed in pixels/second
 -- b.c=color(math.random(0,255),math.random(0,255),math.random(0,255),math.random(50,150))
 b.c=color(math.random(1,250),math.random(1,250),math.random(1,250),math.random(150,250))
 table.insert(B,b) --add to our table of balloons
end
--# LuanchArrow
function LaunchArrow()
    a = {}
    
    a.x = 50
    a.y = HEIGHT/2
    a.w = 40
    a.h = 50
    a.speed = 10
    a.c=color(math.random(1,250),math.random(1,250),math.random(1,250),math.random(150,250))

table.insert(A,a)
end

--# Frame
Frame = class()

-- Frame 
-- ver. 7.0
-- a simple rectangle for holding controls.
-- ====================

function Frame:init(x, y, w, h)
    self.x = x
    self.y = y
    self.w = w
    self.h = h
end

function Frame:setPosition(pos)
    self.x = pos.x
    self.y = pos.y
end

function Frame:setSize(size)
    self.w = size.x
    self.h = size.y
end

function Frame:position()
    return vec2(self.x, self.y)
end

function Frame:size()
    return vec2(self.w, self.h)
end

function Frame:inset(dx, dy)
    self.x = self.x + dx
    self.y = self.y + dy
    self.w = self.w - dx * 2
    self.h = self.h - dy * 2
end

function Frame:offset(dx, dy)
    self.x = self.x + dx
    self.y = self.y + dy
end
    
function Frame:draw()
    pushStyle()
    rectMode(CORNER)
    rect(self.x, self.y, self.w, self.h)
    popStyle()
end

function Frame:roundRect(radius)
    pushStyle()
    insetPos = vec2(self.x + radius, self.y + radius)
    insetSize = vec2(self.w - 2 * radius, self.h - 2 * radius)

    rectMode(CORNER)
    rect(insetPos.x, insetPos.y, insetSize.x, insetSize.y)

    if radius > 0 then
        smooth()
        lineCapMode(ROUND)
        strokeWidth(radius * 2)

        line(insetPos.x, insetPos.y, 
             insetPos.x + insetSize.x, insetPos.y)
        line(insetPos.x, insetPos.y,
             insetPos.x, insetPos.y + insetSize.y)
        line(insetPos.x, insetPos.y + insetSize.y,
             insetPos.x + insetSize.x, insetPos.y + insetSize.y)
        line(insetPos.x + insetSize.x, insetPos.y,
             insetPos.x + insetSize.x, insetPos.y + insetSize.y)            
    end
    popStyle()
end

function Frame:touched(touch)
    if self:ptIn(touch) then
        return true
    end
    return false
end

function Frame:ptIn(test)
    if test.x >= self.x and test.x <= self.x + self.w then
        if test.y >= self.y and 
        test.y <= self.y + self.h then
            return true
        end
    end
    return false
end

function Frame:overlaps(f)
    if self:left() > f:right() or self:right() < f:left() or
    self:bottom() > f:top() or self:top() < f:bottom() then
        return false
    else
        return true
    end
end

function Frame:left()
    return self.x
end

function Frame:right()
    return self.x + self.w
end

function Frame:bottom()
    return self.y
end

function Frame:top()
    return self.y + self.h
end

function Frame:midX()
    return self.x + (self.w / 2)
end
    
function Frame:midY()
    return self.y + (self.h / 2)
end

function Frame:width()
    return self.w
end

function Frame:height()
    return self.h
end
--# Control
Control = class(Frame)

-- Control 7.0
-- =====================
-- Designed for use with CiderControls7
-- Used alone, and as a base class for other controls
-- =====================

function Control:init(s, x, y, w, h, callback)
    -- creates a boundary
    Frame.init(self, x, y, w, h)
    
    -- text properties
    self.text = s
    self.itemText = {}
    self.font = "HelveticaNeue-Light"
    self.textColor = color(0, 0, 0, 255)
    self.highlightedTextColor = color(0, 50, 255, 255)
    self.textMode = CORNER
    self.textAlign = LEFT
    self.fontSize = 18
    self.textVerticalAlign = TOP
    
    -- basic color properties
    self.background = color(0, 0, 0, 0)
    self.foreground = color(14, 14, 14, 255)
    self.highlightColor = color(0, 0, 0, 0)
    
    -- status properties
    self.selected = false
    self.highlighted = false
    self.enabled = true
    
    -- shadow properties
    self.shadowColor = color(0, 0, 0, 46)
    self.shadowOffset = 4
    self.shadowVisible = false

    -- class refrences
    self.controlName = "Control"
    self.callback = callback or nil
end

function Control:splitText()
    -- allows multiple items to be passed to text using
    -- semicolons as seperators
    local i, k
    i = 0
    for k in string.gmatch(self.text,"([^;]+)") do
        i = i + 1
        self.itemText[i] = k
    end
end

function Control:draw()
    local i, h, w, x
    pushStyle()
    noStroke()
    fill(self.background)
    Frame.draw(self)
    if self.enabled then
        fill(self.textColor)
    else
        fill(self.textColor.r, self.textColor.g,
        self.textColor.b, 50)
    end
    textAlign(self.textAlign)
    textMode(self.textMode)
    font(self.font)
    fontSize(self.fontSize)
    w, h = textSize(self.text)
    
    if self.textAlign == LEFT then
        x = self:left() + 4
    elseif self.textAlign == CENTER then
        x = self:midX() - w / 2
    elseif self.textAlign == RIGHT then
        x = self:right() - w - 8
    end
    
    if self.textVertAlign == TOP then
        text(self.text, x, self:top() - h)
    elseif self.textVertAlign == MIDDLE then
        text(self.text, x, self:midY()- h/2)
    elseif self.textVertAlign == BOTTOM then
        text(self.text, x, self:bottom() + 4)
    end
    
    popStyle()
end

function Control:initString(ctlName)
    return self.controlName.."('"..self.text.."', " .. 
        self.x..", "..self.y..", "..
        self.w..", "..self.h..", "..
        ctlName.."_Clicked" ..
        ")"
end

 
 


--# Switch
Switch = class(Control)

-- Switch 7.0
-- =====================
-- Designed for use with Cider controls 7
-- two-position selector
-- =====================


function Switch:init(s, x, y, w, h, callback)
    Control.init(self, s, x, y, w, h, callback)
    self.controlName = "Switch"
    self.itemText = {}
    self.highlightedColor = color(17, 226, 21, 255)
    self.background = color(255, 255, 255, 255)
end

function Switch:drawOn()
    pushStyle()
    rectMode(CENTER)
    stroke(self.highlightedColor)
    fill(self.highlightedColor)
    w=100
    h=100
    rect(self:right()-w*.75,self:midY(),w/2,h)
    ellipse(self:right()-w,self:midY(),h)
    fill(self.background)
    ellipse(self:right()-h/2,self:midY(),h)
    
    popStyle()
end

function Switch:drawOff()
    pushStyle()
    rectMode(CENTER)
    stroke(self.foreground)
    fill(self.background)
    w=100
    h=100
  ellipse(self:right()-h/2,self:midY(),h)
    noStroke()
    rect(self:right()-w*.75,self:midY(),w/2,h)
    strokeWidth(1)
    noSmooth()
    line(self:right()-w,self:midY()+h/2-2,
    self:right()-h/2,self:midY()+h/2-2)
    line(self:right()-w,self:midY()-h/2+1,
    self:right()-h/2,self:midY()-h/2+1)
    stroke(0, 0, 0, 72)
    fill(0, 0, 0, 53)
    ellipse(self:right()-w+1,self:midY()-3,h)
    stroke(self.foreground)
    fill(self.background)
    ellipse(self:right()-w,self:midY(),h)
    popStyle()
end


function Switch:draw()
    pushStyle()
    font(self.font)
    fontSize(self.fontSize)
    strokeWidth(1)
    textMode(CORNER)
    textAlign(LEFT)
    fill(self.textColor)
    w,h = textSize(self.text)
  text(self.text, self:left(), self:midY()-h/2)
    
    if self.selected then
        self:drawOn()
    else
        self:drawOff()
    end
    popStyle()
end

function Switch:touched(touch)
    if self:ptIn(touch) then
        if touch.state == BEGAN then
            self.selected = not self.selected
            if self.callback ~= nil then self.callback() end
        end
        return true
    else
        return false
    end
end


