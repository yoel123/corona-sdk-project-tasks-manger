ye = require("ye")
fa = require("forms_action")
composer = require( "composer" )
local centerX = display.contentCenterX
local centerY = display.contentCenterY
local btn_bg = {"btns/button.png","btns/buttonhover.png"}
local btn_edit = {"btns/editbtn.png","btns/editbtn.png"}

--view screen object
vs = {}

vs.data = nil
vs.bg = nil
vs.nextbtn= nil
vs.prevbtn = nil
vs.editbtn = nil
vs.title= nil
vs.main_text= nil
vs.scroll= nil
vs.chackbox= nil
vs.cbx = 10
vs.datar= {}
vs.cur_id = 1
vs.type = "view"





function go_to_edit()

  composer.gotoScene( "edit_screen" )
end--go_to_view



-----------scene------------

local scene = composer.newScene()
-------|create|----------------
function scene:create( event )

  local sceneGroup = self.view



---------------main--------------

--init data
 vs.datar = fa:load_data(vs.datar)

--init background
  vs.bg = ye:rect(0,0,1000,1000)
  vs.bg:setFillColor( 255/255,255/255,255/255)

--init title and content
  vs.title = ye:txt("title",160,50,native.systemFont,28)
  vs.title:setFillColor( 0,0,0 )
  vs.main_text = display.newText("i am text",display.contentCenterX,display.contentCenterY+760,280,2000,native.systemFont,14)
  vs.main_text:setFillColor(0,0,0 )
  vs.scroll = ye:scroll_v(9,70,{w=300,h=250,hb =true})
  vs.scroll:insert(vs.main_text)

--init chackbox
  vs.chackbox = ye:checkbox(vs.cbx,360,{txt_x=50,txt="done",onSwitchPress = fa.done_checkbox_do})
  vs.chackbox[1].obj = vs--ye:checkbox returns an object array the first is the cahckbox widget, pass the class parent to it.
--init btns
  vs.prevbtn = ye:btn(centerX+40,centerY+180,{df=btn_bg[1],of=btn_bg[2],dc = {0,0,0},txt="previous",func = fa.yback})
  vs.prevbtn.obj = vs--lua way to call perent...
  vs.nextbtn = ye:btn(centerX+40,centerY+110,{df=btn_bg[1],of=btn_bg[2],dc = {0,0,0},txt="next",func = fa.ynext})
  vs.nextbtn.obj = vs
  
   vs.editbtn = ye:btn(centerX,centerY+240,{df=btn_edit[1],of=btn_edit[2],dc = {0,0,0},txt="",func = go_to_edit})
--load data
  fa:render_data_view(vs)



  --add to scene
  sceneGroup:insert(vs.bg)
  sceneGroup:insert(vs.title)
  sceneGroup:insert(vs.scroll)
  sceneGroup:insert(vs.prevbtn)
  sceneGroup:insert(vs.nextbtn)
  sceneGroup:insert(vs.editbtn)


end--end create

-- show()
function scene:show( event )

  local sceneGroup = self.view
  local phase = event.phase

  if ( phase == "will" ) then

elseif ( phase == "did" ) then
    
    --reload data
    if event.params then
     vs.cur_id = event.params.cur_id
     vs.datar =  event.params.datar
     fa:render_data_view(vs)
    end--if


    if( vs.chackbox ) then
      vs.chackbox[1].isVisible = true
      vs.chackbox[2].isVisible = true
    end--if list
  end
end


-- hide()
function scene:hide( event )

  local sceneGroup = self.view
  local phase = event.phase

  if ( phase == "will" ) then

  elseif ( phase == "did" ) then
    if( vs.chackbox ) then
      vs.chackbox[1].isVisible = false
      vs.chackbox[2].isVisible = false
    end--if list
  end
end


-- destroy()
function scene:destroy( event )

  local sceneGroup = self.view

end


-- -----------------------------------------------------------------------------------
-- Scene event function listeners
-- -----------------------------------------------------------------------------------
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )
-- -----------------------------------------------------------------------------------



return scene