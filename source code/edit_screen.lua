ye = require("ye")
composer = require( "composer" )
fa = require("forms_action")

local centerX = display.contentCenterX
local centerY = display.contentCenterY
local btn_bg = {"btns/button.png","btns/buttonhover.png"}

--edit screen object
es = {}
es.title = nil
es.content = nil
es.nextbtn = nil
es.backbtn = nil
es.back_toviewbtn = nil
es.datar = {}
es.cur_id = 1
es.type = "edit"


function go_to_view(e)
  --save evrything first
  fa:update_data(es)--update datar from current form fields first
  fa:save_data(es)
  --pass current_id and data array with params
  composer.gotoScene( "view_screen",{params={cur_id = es.cur_id,datar = es.datar}} )
end--go_to_view

-----------scene------------

local scene = composer.newScene()
-------|create|----------------
function scene:create( event )

  local sceneGroup = self.view



---------------main--------------



--init data
  es.datar = fa:load_data(es.datar)

--init components

   es.title = ye:txtbox(160,50,280,30)
   es.title.size = 18
   es.content = ye:txtbox(160,180,280,200,true)
   es.content.size =20
   es.nextbtn = ye:btn(centerX+40,centerY+80,{df=btn_bg[1],of=btn_bg[2],dc = {0,0,0},txt="next",func = fa.ynext})
   es.nextbtn.obj = es
   es.backbtn = ye:btn(centerX+40,centerY+150,{df=btn_bg[1],of=btn_bg[2],dc = {0,0,0},txt="previous",func = fa.yback})
   es.backbtn.obj = es
   es.back_toviewbtn = ye:btn(centerX+40,centerY+220,{df=btn_bg[1],of=btn_bg[2],dc = {0,0,0},txt="end edit",func = go_to_view})
   es.back_toviewbtn.obj = es
--load data
  fa:render_data(es)



  --add to scene
  sceneGroup:insert(es.title)
  sceneGroup:insert(es.content)
  sceneGroup:insert(es.nextbtn)
  sceneGroup:insert(es.backbtn)
  sceneGroup:insert(es.back_toviewbtn)


end--end create

-- show()
function scene:show( event )

  local sceneGroup = self.view
  local phase = event.phase

  if ( phase == "will" ) then

  elseif ( phase == "did" ) then
    if( es.title ) then
      es.title.isVisible = true
      es.content.isVisible = true
    end--if title
  end
end


-- hide()
function scene:hide( event )

  local sceneGroup = self.view
  local phase = event.phase

  if ( phase == "will" ) then

  elseif ( phase == "did" ) then
    if( es.title ) then
      es.title.isVisible = false
      es.content.isVisible = false
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