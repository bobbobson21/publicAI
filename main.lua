
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
	pal["annoyed_maxlevel"] = 5
	pal["annoyed_responcecounter"] = {}
	pal["annoyed_responces_attachment"] = {}
	pal["annoyed_responces"] = {}
	pal["searchfor_groups"] = {}
	pal["sandbox"] = {}
	pal["runfunctionkey"] = "֍"
	
	pal["matchlevel_lengthprocessed"] = -1
	pal["matchlevel_wordsprocessed"] = -1
	pal["matchlevel_wordsprocessed_old"] = -1
	pal["currentresponceimportance"] = -999
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
	pal["matchlevel_lengthprocessed"] = pal["matchlevel_lengthprocessed"] -1
	pal["matchlevel_wordsprocessed"] = pal["matchlevel_wordsprocessed"] -1
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

function pal:GetIDKresponce()
return pal["idk_responces"][math.random( 1, pal["idk_responces"] )]
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

-- end of data control functions and start of AI loop --------------------------------------------------------------------------------------------------------

function pal:EmotionGravatate()
	local gravatateamount = 0.03 
	local x = pal["emotion_level_wanted"][1] -pal["emotion_level"][1]
	local y = pal["emotion_level_wanted"][2] -pal["emotion_level"][2]
	x = ( x /( x+y ) ) *gravatateamount; y = ( y /( x+y ) ) *gravatateamount
	pal["emotion_level"][1] = pal["emotion_level"][1] +x
	pal["emotion_level"][2] = pal["emotion_level"][2] +y
end

function pal:Loop() --runs every second but it only a simulation meaning anything that envolves printing can not be done in this
pal:EmotionGravatate()
--put any code 
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
	
	pal["currentresponceimportance"] = -999
	pal["matchlevel_wordsprocessed_old"] = -1
	local currentresponceindex = -1

for index = 1, #pal["info_database"] do

	pal["matchlevel_lengthprocessed"] = 0
	pal["matchlevel_wordsprocessed"] = 0

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
	local run, err = load( "return"..string.sub( text, 2, string.len( text ) ) )
	pal["found_tag"] = ( run() == true )
else
	local starts, ends = string.find( input, text, 1, true )
if starts ~= nil then
	pal["found_tag"]  = true
	pal["found_tag_at"] = ends
   end
end


if pal["found_tag"]  == true then 
if pal["found_tag_at"] >= pal["matchlevel_lengthprocessed"] then
	pal["matchlevel_lengthprocessed"] = pal["found_tag_at"]
	pal["matchlevel_wordsprocessed"] = pal["matchlevel_wordsprocessed"] +1
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
	local run, err = load( "return"..string.sub( text, 2, string.len( text ) ) )
	pal["found_tag"]  = ( run() == true )
else
	local starts, ends = string.find( input, text, 1, true )
if starts ~= nil then
	pal["found_tag"]  = true
	pal["found_tag_at"] = ends
   end
end

if pal["found_tag"]  == true then 
if pal["found_tag_at"] >= pal["matchlevel_lengthprocessed"] then
	pal["matchlevel_lengthprocessed"] = pal["found_tag_at"]
	pal["matchlevel_wordsprocessed"] = pal["matchlevel_wordsprocessed"] +1
else
	pal["found_tag_at"] = -999
end
else
	pal["found_tag_at"] = -999
      end 
   end 
end

if pal["matchlevel_lengthprocessed"] >= 1 then
if pal["matchlevel_wordsprocessed"] >= pal["matchlevel_wordsprocessed_old"] then
if importance >= pal["currentresponceimportance"] then

	pal["matchlevel_wordsprocessed_old"] = pal["matchlevel_wordsprocessed"]
	pal["currentresponceimportance"] = importance
	currentresponceindex = index

         end
      end
   end
end

if currentresponceindex ~= -1 then
	local result = pal["info_database"][currentresponceindex]
return {["sf"]=result["sf"],["sfl"]=result["sfl"],["ec"]=result["ec"],["aet"]=result["aet"],["a"]=result["a"],["i"]=result["i"],["responces"]=result["responces"],["subresponces"]=result["subresponces"],["id"]=result["id"],["append"]=result["append"]}
   end
end

function pal:BuildResponceTo( input ) --USE THIS TO GET THE AI TO MAKE A RESPONCE TO THE INPUT
	local master = input
	local output = ""

self:RunLoopSimulation()
	master = self:RunSpellCheck( master )
function pal:GetTextToRespondTo() return master end
self:RunAjustEmotionToEmotiveKeyWords( master )
	output = self:RunFindResponce( master )
if output == nil then return self:GetIDKresponce() end


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