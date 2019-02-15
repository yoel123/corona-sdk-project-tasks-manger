 ye = require("ye")
 fa = {}



------------convert text file/csv to an array-------
 function fa:ycsv_process(csv_str,row,col)
  csvr = ye:split(csv_str,row)
  ret_r = {}
  --loop rows
  for i  = 1,  #csvr do
    ret_r[i] = ye:split(csvr[i],col)
  end--end for
  return ret_r
end--ycsv_proces

---------------convert array back to text/csv------------
 function fa:to_ycsv(arr,row,col)
  str =""
  for i  = 1,  #arr do

    for j  = 1,  #arr[i] do
      str = str..arr[i][j]
      if j  ~= #arr[i] then
        str = str..col
      end--if
    end--for
    str = str..row
    
  end--end for

  return str
end--to_ycsv

-----------load data from data fie--------
 function fa:load_data()
  --has app ran before
  local hasAppRunBefore = system.getPreference( "app", "hasAppRunBefore", "boolean" )

  csv_file = ye:get_txt_file("tasks_db.txt")
  --if no fie
  if csv_file == nil or not hasAppRunBefore then -- no file or first run, then create a defult one
    system.setPreferences( "app", { hasAppRunBefore = true } )--set hasAppRunBefore to true
    ye:save_txt("how to use#this apps database txt file is in your documents folder: \n\n   "..system.pathForFile( "", system.DocumentsDirectory ).."    \n\n please edit it \n\n you can also edit by clicing the wrench at the bottom#0;","tasks_db.txt")
    csv_file = ye:get_txt_file("tasks_db.txt")
  end--if
  print(system.DocumentsDirectory)
  datar = fa:ycsv_process(csv_file,";","#")
  
  return datar
end--load_data

-----------save_data to file--------------
 function fa:save_data(obj)
 -- ye:printr(obj.datar)
  csv_txt = fa:to_ycsv(obj.datar,";","#")

  ye:save_txt(csv_txt,"tasks_db.txt")
end--load_data

------------------render data (put data into components)------------
 
 --render data view page
 function fa:render_data_view(vs)

  current_row = vs.datar[vs.cur_id]
  if current_row == nil then return end --exit if no data
  if current_row[1] then--incase its empty
    vs.title.text  = current_row[1]
  end--if
  if current_row[2] and vs.main_text then--incase its empty
    vs.main_text.text  = current_row[2]
  end--if
  
  --incase its empty exit
  if vs.chackbox ==nil then return end--if
  
  --remove and re init chackbox in correct state...(cant set state after init)
  display.remove( vs.chackbox[1] )
  display.remove( vs.chackbox[2] )
  --re init as correct state (1= checked,0= unchecked)
  if current_row[3] =="1" then
    vs.chackbox = ye:checkbox(vs.cbx,360,{txt_x=60,txt="done",onSwitchPress = fa.done_checkbox_do,yis_on=true })
    vs.chackbox[1].obj = vs
  else
    vs.chackbox = ye:checkbox(vs.cbx,360,{txt_x=50,txt="done",onSwitchPress = fa.done_checkbox_do,yis_on=false })
    vs.chackbox[1].obj = vs
  end--if
  
  --scroll top (so the user sees the start of the text)
  vs.scroll:scrollTo( "top", { time=200})

end--render_data

--render data edit page
function fa:render_data_edit(es)
  if current_row == nil then return end --exit if no data
  current_row = es.datar[es.cur_id] --get current row
  es.title.text  = current_row[1] --set title text to curent data row
  es.content.text  = current_row[2] --set content text to curent data row

end--render_data_edit

function fa:update_data(es)
  current_row = es.datar[es.cur_id] --get curret data row
  if es.title.text == "" then es.title.text ="\n0"end -- if title is empty put defult data
  current_row[1] = es.title.text --set current row tite to title input text
  if es.content.text == "" then es.content.text ="0"end --if content input is empty set defult val
  current_row[2] =  es.content.text --set row content to content input text
end--update data

--render data
function fa:render_data(obj)
  --if its view or edit screen do a render func
  if obj.type =="view" then
    fa:render_data_view(obj)
  end--if
  if obj.type =="edit" then
    fa:render_data_edit(obj)
  end--if

end--render_data_edit

----------------on check done chackbox-----------------

fa.done_checkbox_do = function(e)
  vs  = e.target.obj --get view screen class object
  current_row = vs.datar[vs.cur_id] --get current row
  
  --if checked after click change data to no checked else mark as checked in the array (1 is checked)
  if current_row[3] =="1" then
    vs.datar[vs.cur_id][3] = "0"
  else
    vs.datar[vs.cur_id][3] = "1"
  end--if
  --save to file
  fa:save_data(vs)
end--done_checkbox_do


-------------select and return a random color rgb array---------------
 function fa:yrand_color()

  colors = {{69,179,224},{135,206,235},{219,94,92},{252,190,71},{168,62,102},
    {79, 230, 45},{255, 133, 203},{142, 220, 157}}
  rnd =  math.random(1, #colors)
  return colors[rnd]

end --yrand_color

------------fade in----------
 function fa:yfade_in(obj)
  obj.alpha=0
  transition.to( obj, { time=500, alpha=1})
end --yfade_in

-------------change background--------
 function fa:ychange_bg(bg)
  --set new bg color
  ycolor = fa:yrand_color()
  --set bacground color to random color
  bg:setFillColor( ycolor[1]/255,ycolor[2]/255,ycolor[3]/255) --n/255 is to convert rgb to corona decime
  --fade in
  fa:yfade_in(bg)
end --ychange_bg

----------------press next----
 fa.ynext = function(e)
  vs  = e.target.obj --get view/edit screen class object
  --change bg on view page only
  if vs.type == "view"then
    fa:ychange_bg(vs.bg)
  end
  --update datar from form fieldsw
  if vs.type == "edit"then
    fa:update_data(vs)
  end
  --incrament current id and make sure its not bigger then rows size
  vs.cur_id = vs.cur_id + 1
  
  --if id is bigger then array size
  if vs.cur_id > #vs.datar then
    last_id = vs.cur_id --save current id
    vs.cur_id=1 --set id back to one to loop tasks
    --if edit add new entry
    if vs.type == "edit" and vs.datar[last_id] == nil then
      vs.datar[last_id] = {"\nnew entry "..last_id,"","0"}--new row
      vs.cur_id = last_id  --save id becuse we just created it
    end--if
  end--if

  --if edit page save data
  if vs.type == "edit"then
    fa:save_data(vs)
  end
  fa:render_data(vs)
end --ynext

----------------press previous----
 fa.yback = function(e)
  vs  = e.target.obj --get view/edit screen class object
  --change bg on view page only
  if vs.type == "view"then
    fa:ychange_bg(vs.bg)
  end
  
  --update datar from form fieldsw
  if vs.type == "edit"then
    fa:update_data(vs)
  end
  
  --decrament current id and make sure its not smaller or equal  0 if it is goto last row
  vs.cur_id = vs.cur_id - 1
  if vs.cur_id<=0 then
    vs.cur_id = #vs.datar
  end--if
  
  --if edit page save data
  if vs.type == "edit"then
    fa:save_data(vs)
  end
  fa:render_data(vs)
end --yback


return fa