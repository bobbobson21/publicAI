
	inruntime = false

	pal = {}
	pal["info_database"] = {}
	pal["info_database_added"] = {}
	pal["info_database_removed"] = {}
	pal["synonyms_groups"] = {}
	pal["spellchecking"] = {}
	pal["last_input"] = ""
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

-- end of seting pal vars start of data control functions ----------------------------------------------------------------------------------------------------

function pal:getvar( v ) return pal["sandbox"][v] end
function pal:setvar( k, v ) return pal["sandbox"][k] = v end

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

function pal:AddInfo( searchfor, searchfor_last, emotion_change, add_emotion_text, annoying, inportance, responces, subresponces, id, removealid ) --SearchFor is done like so {"hodey","hello","hi"} it can ethier contain functions
	pal["info_database"][#pal["info_database"] +1] = {["sf"]=searchfor,["sfl"]=searchfor_last,["ec"]=emotion_change,["aet"]=add_emotion_text,["a"]=annoying,["i"]=inportance,["responces"]=responces,["subresponces"]=subresponces,["id"]=id,["rid"]=removealid}
if inruntime == true then pal["info_database_added"][#pal["info_database_added"] +1] = pal["info_database"][#pal["info_database"]] end
for z = 1, pal["info_database_removed"] do
if pal["info_database_removed"][z] == id then pal["info_database_removed"][z] = nil end
   end
end

function pal:ReturnInfo( searchfor, searchfor_last, emotion_change, add_emotion_text, annoying, inportance, responces, subresponces, id, removealid )
return {["sf"]=searchfor,["sfl"]=searchfor_last,["ec"]=emotion_change,["aet"]=add_emotion_text,["a"]=annoying,["i"]=inportance,["responces"]=responces,["subresponces"]=subresponces,["id"]=id,["rid"]=removealid}
end

function pal:AddSpellChecking( correct, ... )
	pal["spellchecking"][#pal["spellchecking"] +1] = {["c"]=correct,["i"]={...}}
end

function pal:AddSynonymsGroup( ... )
	pal["synonyms_groups"][#pal["synonyms_groups"] +1] = {...}
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

function pal:AddIDKresponces( responce ) --for when the ai dose not have a responce
	pal["idk_responces"][#pal["idk_responces"] +1] = responce
end

function pal:AddAnnoyedRespoces( level, responce ) --for if you ask the same question to many times
if leve == 1 then pal["annoyed_responces_attachment"][#pal["annoyed_responces_attachment"] +1] = responce end
if leve == 2 then pal["annoyed_responces"][#pal["annoyed_responces"] +1] = responce end
end

pal:BuildEmotionGrid( pal["emotion_grid_max_size"] )

-- end of data control functions and start of main ai loop ---------------------------------------------------------------------------------------------------

function pal:RunSpellCheck( input )
	local mstr = input
	local nul = 0
for z = 1, #pal["spellchecking"] do
for y = 1, #pal["spellchecking"][z]["i"] do
	mstr, nul = string.gsub( mstr, pal["spellchecking"][z]["i"][y].." ", pal["spellchecking"]["c"][z].." " )
   end
end
return mstr
end

function pal:BuildResponceTo( input ) --USE THIS TO GET THE AI TO MAKE A RESPONCE TO THE INPUT
	local master = input

	master = self:RunSpellCheck( master )

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