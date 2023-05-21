
	inruntime = false

	pal = {}
	pal["info_database"] = {}
	pal["info_database_added"] = {}
	pal["info_database_removed"] = {}
	pal["synonyms_groups"] = {}
	pal["spellchecking"] = {}
	pal["prior_input"] = ""
	pal["emotion_level"] = {3,2}
	pal["emotion_level_wanted"] = {3,2}
	pal["emotion_grid"] = {}
	pal["emotion_grid_max_size"] = 3
	pal["idk_responces"] = {}
	pal["annoyance_maxlevel"] = 4
	pal["annoyance_responcecounter"] = {}
	pal["annoyance_responces_attachment"] = {}
	pal["annoyance_decreese_in"] = 60
	pal["annoyance_responces"] = {}
	pal["searchfor_groups"] = {}
	pal["sandbox"] = {}
	pal["runfunctionkey"] = "֍"
	pal["match_level_length_processed"] = -1
	pal["match_level_words_processed"] = -1
	pal["match_level_words_processed_old"] = -1
	pal["current_responce_importance"] = -999
	pal["found_tag"] = false
	pal["found_tag_at"] = 0

-- end of seting pal vars start of data control functions ----------------------------------------------------------------------------------------------------

function pal:getvar( v ) return pal["sandbox"][v] end
function pal:setvar( k, v ) pal["sandbox"][k] = v end

function pal:EmotionLevelEquals( tbl )
return ( tbl[1] == pal["emotion_level"][1] and tbl[2] == pal["emotion_level"][2] )
end

function pal:EmotionLevelNotEquals( tbl )
return ( tbl[1] ~= pal["emotion_level"][1] or tbl[2] ~= pal["emotion_level"][2] )
end

function pal:notrequiredtag( tag ) --for tags you want it to seach for but only mark down the result and not desqalify it if result cant be found
	local starts, ends = string.find( tag, self:GetTextToRespondTo(), 1, true )
if starts ~= nil then
	pal["match_level_length_processed"] = pal["match_level_length_processed"] -1
	pal["match_level_words_processed"] = pal["match_level_words_processed"] -1
	pal["found_tag_at"] = ends
end
return true
end

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

function pal:AddInfo( searchfor, searchfor_prior, emotion_change, annoyable, inportance, responces, subresponces, id, append ) --SearchFor is done like so {"hodey","hello","hi"} it can ethier contain functions
	pal["info_database"][#pal["info_database"] +1] = {["sf"]=searchfor,["sfl"]=searchfor_prior,["ec"]=emotion_change,["a"]=annoyable,["i"]=inportance,["responces"]=responces,["subresponces"]=subresponces,["id"]=id,["append"]=append}
if inruntime == true then pal["info_database_added"][#pal["info_database_added"] +1] = pal["info_database"][#pal["info_database"]] end
for z = 1, pal["info_database_removed"] do
if pal["info_database_removed"][z] == id then pal["info_database_removed"][z] = nil end
   end
end

function pal:AddInfoTbl( tbl ) --SearchFor is done like so {"hodey","hello","hi"} it can ethier contain functions
	pal["info_database"][#pal["info_database"] +1] = tbl
if inruntime == true then pal["info_database_added"][#pal["info_database_added"] +1] = pal["info_database"][#pal["info_database"]] end
for z = 1, pal["info_database_removed"] do
if pal["info_database_removed"][z] == id then pal["info_database_removed"][z] = nil end
   end
end

function pal:ReturnInfo( searchfor, searchfor_prior, emotion_change, annoyable, inportance, responces, subresponces, id, append ) --format like so {"word","word","word"}, {"word","from","the","prior","text","responded","to"}, {0.15,0.001}, true, 1, {"hi","bye","gay"}, {ReturnInfo( DATA ),ReturnInfo( DATA )}, "code_for_editing_info", "appends_to_all_responces"
return {["sf"]=searchfor,["sfl"]=searchfor_prior,["ec"]=emotion_change,["a"]=annoyable,["i"]=inportance,["responces"]=responces,["subresponces"]=subresponces,["id"]=id,["append"]=append}
end

function pal:GetInfoByIndex( index )
	local result = pal["info_database"][index]
return {["sf"]=result["sf"],["sfl"]=result["sfl"],["ec"]=result["ec"],["a"]=result["a"],["i"]=result["i"],["responces"]=result["responces"],["subresponces"]=result["subresponces"],["id"]=result["id"],["append"]=result["append"]}
end

function pal:GetInfoById( id )
	local result = pal["info_database"]
for z = 1, #result do
if result[z]["id"] == id then
	local result = pal["info_database"][z]
return {["sf"]=result["sf"],["sfl"]=result["sfl"],["ec"]=result["ec"],["a"]=result["a"],["i"]=result["i"],["responces"]=result["responces"],["subresponces"]=result["subresponces"],["id"]=result["id"],["append"]=result["append"]}
      end
   end
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

function pal:GetIDKresponce()
return pal["idk_responces"][math.random( 1, pal["idk_responces"] )]
end

function pal:AddAnnoyanceRespoces( level, responce ) --for if you ask the same question to many times
if leve == 1 then pal["annoyance_responces_attachment"][#pal["annoyance_responces_attachment"] +1] = responce end
if leve == 2 then pal["annoyance_responces"][#pal["annoyance_responces"] +1] = responce end
end

function pal:GetAnnoyanceRespoce( level ) --for if you ask the same question to many times
if leve == 1 then return pal["annoyance_responces_attachment"][math.random( 1, #pal["annoyance_responces_attachment"] )] end
if leve == 2 then return pal["annoyance_responces"][math.random( 1, #pal["annoyance_responces"] )] end
end

function pal:SetPriorInput( text )
	pal["prior_input"] = text
end

function pal:GetPriorInput()
return pal["prior_input"]
end

pal:BuildEmotionGrid( pal["emotion_grid_max_size"] )

-- end of data control functions and start of AI loop --------------------------------------------------------------------------------------------------------

function pal:EmotionGravatate()
	local gravatateamount = 0.03 
	local x = pal["emotion_level_wanted"][1] -pal["emotion_level"][1]
	local y = pal["emotion_level_wanted"][2] -pal["emotion_level"][2]
	x = ( x /( x+y ) ) *gravatateamount; y = ( y /( x+y ) ) *gravatateamount
	pal["emotion_level"][1] = pal["emotion_level"][1] +x
	pal["emotion_level"][2] = pal["emotion_level"][2] +y
end

function pal:AnnoyanceDecreese()
if pal["annoyance_level"] == nil or pal["annoyance_level"] <= 0 then
for k, v in pairs( pal["annoyance_responcecounter"] ) do
	v = v -1
if v <= 0 then pal["annoyance_responcecounter"][k] = 0 end
end
	pal["annoyance_level"] = pal["annoyance_maxlevel"] +1
end
	pal["annoyance_level"] = pal["annoyance_level"] -1
end

function pal:Loop() --runs every second but it only a simulation meaning anything that envolves printing can not be done in this
pal:EmotionGravatate()  --remove here to remove emotion change
pal:AnnoyanceDecreese()
--put any code here
end

function pal:RunLoopSimulation()
if pal["last_sim_time"] == nil then pal["last_sim_time"] = os.time() end
	local simlen = os.time() -pal["last_sim_time"]
for z = 1, simlen do pal:Loop() end
end

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

function pal:RunFindResponce( input )
	
	pal["current_responce_importance"] = -999
	pal["match_level_words_processed_old"] = -1
	local currentresponceindex = -1

for index = 1, #pal["info_database"] do

	pal["match_level_length_processed"] = 0
	pal["match_level_words_processed"] = 0

	local searchin = pal["info_database"][z]["sf"]
	local searchin_prior = pal["info_database"][z]["sfl"]
	local importance = pal["info_database"][z]["i"]

if searchin ~= nil then
for z = 1, searchin do
	local text = searchin[z]
	pal["found_tag"]  = false
	pal["found_tag_at"] = 0
if string.len( text ) <= 4 then text = text.." " end
if string.sub( text, 1, 1 ) == pal["runfunctionkey"] then
	local run, err = load( "return "..string.sub( text, 2, string.len( text ) ) )
	pal["found_tag"] = ( run() == true )
else
	local starts, ends = string.find( input, text, 1, true )
if starts ~= nil then
	pal["found_tag"]  = true
	pal["found_tag_at"] = ends
   end
end


if pal["found_tag"]  == true then 
if pal["found_tag_at"] >= pal["match_level_length_processed"] then
	pal["match_level_length_processed"] = pal["found_tag_at"]
	pal["match_level_words_processed"] = pal["match_level_words_processed"] +1
else
	pal["found_tag_at"] = -999
end
else
	pal["found_tag_at"] = -999
      end 
   end
end

if searchin_prior ~= nil then
for z = 1, #searchin_prior do
	local text = searchin_prior[z]
	pal["found_tag"]  = false
	pal["found_tag_at"] = 0
if string.len( text ) <= 4 then text = text.." " end
if string.sub( text, 1, 1 ) == pal["runfunctionkey"] then
	local exe, null = load( "return"..string.sub( text, 2, string.len( text ) ) )
	pal["found_tag"]  = ( exe() == true )
else
	local starts, ends = string.find( input, text, 1, true )
if starts ~= nil then
	pal["found_tag"]  = true
	pal["found_tag_at"] = ends
   end
end

if pal["found_tag"]  == true then 
if pal["found_tag_at"] >= pal["match_level_length_processed"] then
	pal["match_level_length_processed"] = pal["found_tag_at"]
	pal["match_level_words_processed"] = pal["match_level_words_processed"] +1
else
	pal["found_tag_at"] = -999
end
else
	pal["found_tag_at"] = -999
      end 
   end 
end

if pal["match_level_length_processed"] >= 1 then
if pal["match_level_words_processed"] >= pal["match_level_words_processed_old"] then
if importance >= pal["current_responce_importance"] then

	pal["match_level_words_processed_old"] = pal["match_level_words_processed"]
	pal["current_responce_importance"] = importance
	currentresponceindex = index

         end
      end
   end
end

if currentresponceindex ~= -1 then
	return currentresponceindex
   end
end

function pal:RunAnnoyanceTest( inputindex, input )
	local annoyedlevel = pal["annoyance_responcecounter"][inputindex] or 0
if annoyedlevel >= 1 then
if annoyedlevel >= pal["annoyance_maxlevel"] then
	return pal:GetAnnoyanceRespoce( 1 )..input
else
	return pal:GetAnnoyanceRespoce( 2 )
   end
end
	pal["annoyance_responcecounter"][inputindex] = math.min( annoyedlevel +1, pal["annoyance_maxlevel"] +1 )
end

function pal:RunLuaCodeInResponce( input )
	local startcutat = -1
	local endcutat = -1
	local levelat = 0
	local processing = false
	local masterstr = input
	local diffrence = 0

for z = 1, string.len( input ) +1000 do
	local point = string.sub( input, z, z )
if point == pal["runfunctionkey"] then startcutat, processing = point, false end
if point == "(" then levelat, processing = levelat, true end
if point == ")"  then
	levelat = levelat +1

if levelat == 0 and processing == true then
	local exe, null = load( "return "..string.sub( input, startcutat +1, endcutat ) )
	local result = exe()
if result ~= nil then
	masterstr = string.sub( masterstr, 1, startcutat -( 1 +diffrence ) )..result..string.sub( masterstr, endcutat +( 1 +diffrence ), string.len( masterstr ) )
	diffrence = string.len( masterstr ) -string.len( input )
end
	levelat = 0
	processing = false
      end
   end
end
return masterstr
end

function pal:BuildResponceTo( input ) --USE THIS TO GET THE AI TO MAKE A RESPONCE TO THE INPUT
	local master = input

self:RunLoopSimulation()
	master = self:RunSpellCheck( master )
function pal:GetTextToRespondTo() return master end
self:RunAjustEmotionToEmotiveKeyWords( master ) --remove here to remove emotion change

	local outputindex = self:RunFindResponce( master )
	local outputdata = self:GetInfoByIndex( outputindex )
	local outputresponce = outputdata["responces"][math.random( 1, outputdata["responces"] )]..outputdata["append"]
	
if outputindex == -1 then return self:GetIDKresponce() end
if outputdata["a"] ~= false then outputresponce = self:RunAnnoyanceTest( outputindex, outputresponce ) end

	pal["emotion_change"][1] = pal["emotion_change"][1] +outputdata["ec"][1]  --remove here to remove emotion change
	pal["emotion_change"][2] = pal["emotion_change"][2] +outputdata["ec"][2]  --remove here to remove emotion change

if outputdata["subresponces"] ~= nil then --add sub responces
for z = 1, #outputdata["subresponces"] do
self:AddInfoTbl( outputdata["subresponces"][z] )
   end
end

	outputresponce = pal:RunLuaCodeInResponce()
	pal["prior_input"] = input
	
return outputresponce
end

pal:RunLoopSimulation()

-- end of main ai loop and start of loading external data ----------------------------------------------------------------------------------------------------

function pal:SaveInfo()



end

function pal:LoadInfo()

local processdata = function( strtp, chart )
	local lastpoint = 1
	local data = {}
for z = 1, string.len( strtp ) do
if string.sub( strtp, z, z +( string.len( chart ) -1 ) ) == chart then
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