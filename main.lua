
	inruntime = false

	pal = {}
	pal["info_database"] = {}
	pal["info_database_added"] = {}
	pal["info_database_removed"] = {}
	pal["synonyms_groups"] = {}
	pal["spellchecking"] = {}
	pal["prior_input"] = ""
	pal["emotion_level"] = {3,2}
	pal["emotion_grid"] = {}
	pal["emotion_grid_max_size"] = 3
	pal["idk_responces"] = {}
	pal["annoyed_maxlevel"] = 5
	pal["annoyed_responcecounter"] = {}
	pal["annoyed_responces_attachment"] = {}
	pal["annoyed_responces"] = {}
	pal["searchfor_groups"] = {}
	pal["sandbox"] = {}
	pal["runfunctionkey"] = "֍"

-- end of seting pal vars start of data control functions ----------------------------------------------------------------------------------------------------

function pal:getvar( v ) return pal["sandbox"][v] end
function pal:setvar( k, v ) pal["sandbox"][k] = v end

function pal:RemoveInfo( id )
if inruntime == true then pal["info_database_removed" +1] = id end
for z = 1, #pal["info_database"] do
if id == pal["info_database"][z]["id"] then pal["info_database"][z] = nil end
if type( pal["info_database"][z]["id"] ) ~= "table" then
	local stopthis = false
for y = 1, #pal["info_database"][z]["id"] do
if stopthis == false then
if pal["info_database"][z]["id"] == id then pal["info_database"][z] = nil; stopthis = true end
         end
      end
   end
end
   
for z = 1, #pal["info_database_added"] do
if id == pal["info_database_added"][z]["id"] then pal["info_database_added"][z] = nil end
if type( pal["info_database_added"][z]["id"] ) ~= "table" then
	local stopthis = false
for y = 1, #pal["info_database_added"][z]["id"] do
if stopthis == false then
if pal["info_database_added"][z]["id"] == id then pal["info_database_added"][z] = nil; stopthis = true end
            end
         end
      end
   end   
end

function pal:AddInfo( searchfor, searchfor_prior, emotion_change, add_emotion_text, annoyable, inportance, responces, subresponces, id, append ) --SearchFor is done like so {"hodey","hello","hi"} it can ethier contain functions
	pal["info_database"][#pal["info_database"] +1] = {["sf"]=searchfor,["sfl"]=searchfor_prior,["ec"]=emotion_change,["aet"]=add_emotion_text,["a"]=annoyable,["i"]=inportance,["responces"]=responces,["subresponces"]=subresponces,["id"]=id,["append"]=append}
if inruntime == true then pal["info_database_added"][#pal["info_database_added"] +1] = pal["info_database"][#pal["info_database"]] end
for z = 1, pal["info_database_removed"] do
if pal["info_database_removed"][z] == id then pal["info_database_removed"][z] = nil end
   end
end

function pal:ReturnInfo( searchfor, searchfor_prior, emotion_change, add_emotion_text, annoyable, inportance, responces, subresponces, id, append ) --format like so {"word","word","word"}, {"word","from","the","prior","text","responded","to"}, {0.15,0.001}, true, true, 1, {"hi","bye","gay"}, {ReturnInfo( DATA ),ReturnInfo( DATA )}, "code_for_editing_info", "appends_to_all_responces"
return {["sf"]=searchfor,["sfl"]=searchfor_prior,["ec"]=emotion_change,["aet"]=add_emotion_text,["a"]=annoyable,["i"]=inportance,["responces"]=responces,["subresponces"]=subresponces,["id"]=id,["append"]=append}
end

function pal:AddSpellChecking( correct, ... )
	pal["spellchecking"][#pal["spellchecking"] +1] = {["c"]=correct,["i"]={...}}
end

function pal:AddSynonymsGroup( id, ... )
	pal["synonyms_groups"][id] = {...}
end

function pal:GetSynonymsWord( id )
return pal["synonyms_groups"][id][math.random( 1, #pal["synonyms_groups"][id] )]
end

function pal:BuildEmotionGrid( size ) --sets the play field used for emotion simulation
	pal["emotion_grid_max_size"] = size
for x = 1, size do
for y = 1, size do
	pal["emotion_grid"][x] = {}
	pal["emotion_grid"][x][y] = {}
      end
   end 
end

function pal:AddEmotion( gridlocation, openingemotiveremarks, closeingemotiveremarks, emotivewords, wordsthatmaketheaifeelmorelikethis ) --for when the ai dose not have a responce
	pal["emotion_grid"][gridlocation[1]][gridlocation[2]] = {["oer"]=openingemotiveremarks,["cer"]=closeingemotiveremarks,["words"]=emotivewords,["wtmifmlt"]=wordsthatmaketheaifeelmorelikethis}
end

function pal:GetEmotiveWord( gridlocation )
return pal["emotion_grid"][gridlocation[1]][gridlocation[2]]["words"][math.random( 1, #pal["emotion_grid"][gridlocation[1]][gridlocation[2]]["words"] )]
end

function pal:AddIDKresponces( responce ) --for when the ai dose not have a responce
	pal["idk_responces"][#pal["idk_responces"] +1] = responce
end

function pal:AddAnnoyedRespoces( level, responce ) --for if you ask the same question to many times
if leve == 1 then pal["annoyed_responces_attachment"][#pal["annoyed_responces_attachment"] +1] = responce end
if leve == 2 then pal["annoyed_responces"][#pal["annoyed_responces"] +1] = responce end
end

function pal:SetPriorInput( text )
	pal["prior_input"] = text
end

function pal:GetPriorInput()
return pal["prior_input"]
end

pal:BuildEmotionGrid( pal["emotion_grid_max_size"] )

-- end of data control functions and start of main ai loop ---------------------------------------------------------------------------------------------------

function pal:RunSpellCheck( input )
	local mstr = ( string.gsub( input, ".", {["("]="%(",[")"]="%)",["."]="%.",["%"]="%%",["+"]="%+",["-"]="%-",["*"]="%*",["?"]="%?",["["]="%[",["]"]="%]",["^"]="%^",["$"]="%$",["\0"]="%z"} ) )
	local nul = 0
for z = 1, #pal["spellchecking"] do
for y = 1, #pal["spellchecking"][z]["i"] do
	mstr, nul = string.gsub( mstr, pal["spellchecking"][z]["i"][y].." ", pal["spellchecking"]["c"][z].." " )
   end
end
return mstr
end

function pal:RunAjustEmotionToEmotiveKeyWords( input )
	local xy = {0,0}
	local div = 1

for x = 1, pal["emotion_grid_max_size"] do
for y = 1, pal["emotion_grid_max_size"] do
if pal["emotion_grid"][x][y]["words"] ~= nil then
for z = 1, pal["emotion_grid"][x][y]["words"] do
	local has, word = string.find( input, pal["emotion_grid"][x][y]["words"], 1, true )
if has ~= nil then
	xy[1] = x
	xy[2] = y
	div = div +1
   end
end

for z = 1, pal["emotion_grid"][x][y]["wtmifmlt"] do
	local has, word = string.find( input, pal["emotion_grid"][x][y]["wtmifmlt"], 1, true )
if has ~= nil then
	xy[1] = x
	xy[2] = y
	div = div +1
            end
         end
      end
   end
end

	xy[1] = xy[1] /div
	xy[2] = xy[2] /div
	pal["emotion_level"] = pal["emotion_level"] +xy
	pal["emotion_level"][1] = math.max( 1, math.min( pal["emotion_grid_max_size"], pal["emotion_level"][1] ) )
	pal["emotion_level"][2] = math.max( 1, math.min( pal["emotion_grid_max_size"], pal["emotion_level"][2] ) )
end

function pal:BuildResponceTo( input ) --USE THIS TO GET THE AI TO MAKE A RESPONCE TO THE INPUT
	local master = input

	master = self:RunSpellCheck( master )
self:RunAjustEmotionToEmotiveKeyWords( master )

end

-- end of main ai loop and start of loading external data ----------------------------------------------------------------------------------------------------

function pal:SaveInfo()



end

function pal:LoadInfo()

local processdata = function( strtp, chart )
	local lastpoint = 1
	local data = {}
for z = 1, string.len( strtp ) do
if string.sub( strtp, z, z ) == "chart" then
	data[#data +1] = string.sub( strtp, lastpoint, z -1 )
if printcode == true then print( string.sub( strtp, lastpoint, z -1 ) ) end
	lastpoint = z +string.len( chart )
   end
end
return processdata
end

end

require( "requires.lua" )

pal:LoadInfo()
for z = 1, #pal["info_database_added"] do pal["info_database"][#pal["info_database"] +1] = pal["info_database_added"][z] end
for z = 1, #pal["info_database_removed"] do pal:RemoveInfo( pal["info_database_removed"][z] ) end

--do code for convo start here

inruntime = true

return pal