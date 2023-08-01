
	inruntime = false
	local cdc = io.popen( "cd" )
	local current_dir = cdc:read( "*l" )
for z = 1, string.len( current_dir ) do if string.sub( current_dir, z, z ) == string.char( 92 ) then current_dir = string.sub( current_dir, 1, z -1 ).."/"..string.sub( current_dir, z +1, string.len( current_dir ) ) end end
cdc:close()

	pal = {}
	pal["selfhooks"] = {}
	pal["info_database"] = {}
	pal["info_database_added"] = {}
	pal["info_database_removed"] = {}
	pal["info_degrade_level"] = {}
	pal["synonyms_groups"] = {}
	pal["spellchecking"] = {}
	pal["prior_input"] = ""
	pal["emotion_level"] = {3,2}
	pal["emotion_level_wanted"] = {3,2}
	pal["emotion_grid"] = {}
	pal["emotion_grid_max_size"] = 3
	pal["emotion_sensitivity"] = 0.2
	pal["emotion_gravatate_power"] = 0.03
	pal["idk_responces"] = {}
	pal["annoyance_maxlevel"] = 4
	pal["annoyance_responcecounter"] = {}
	pal["annoyance_responces_attachment"] = {}
	pal["annoyance_decreese_in"] = 15
	pal["annoyance_responces"] = {}
	pal["searchfor_groups"] = {}
	pal["sandbox"] = {["funcs"]={},}
	pal["runfunctionkey"] = "|"
	pal["save_directory"] = ( current_dir ).."/savdata"

-- end of seting pal vars start of data control functions ----------------------------------------------------------------------------------------------------

function pal:GetVar( v ) return pal["sandbox"][v] end --sandbox is for data that pal needs to access
function pal:SetVar( k, v ) pal["sandbox"][k] = v end
function pal:Sandbox() return pal["sandbox"]["funcs"] end --use the sandbox so that if you need to restore the AI to a prior point you can also restore function and values you created

function pal:SetNewSelfHook( cat, name, v ) --catagory, hook name, function --adds hooks so systems can better interract with the AI
if pal["selfhooks"][cat] == nil then pal["selfhooks"][cat] = {} end
	pal["selfhooks"][cat][name] = v
end

function pal:RemoveSelfHook( cat, name )
if cat == nil then pal["selfhooks"] = nil;  pal["selfhooks"] = {}; return end
if name == nil then pal["selfhooks"][cat] = nil; return end
	pal["selfhooks"][cat][name] = nil
end

function pal:GetSelfHooksAsTable() --gets all the hooks
return pal["selfhooks"]
end

function pal:RunSelfHooks( cat, tbl ) --runs hooks
	local selfuseid = "PALOn"
if string.sub( cat, 1, string.len( selfuseid ) ) ~= selfuseid then return nil end --to make it only useable for pal functions as to not mess stuff up
	local returns = {}

if pal["selfhooks"][cat] ~= nil then
for k, v in pairs( pal["selfhooks"][cat] ) do
	returns = nil
	returns = {v( unpack( tbl ) )}
   end
end

if #returns <= 1 then return returns[1] else return unpack( returns ) end --we only use unpack here because there is no way you should need to loop througth returned data
end

function pal:NRT( tag ) --for tags you want it to seach for but only mark down the result and not desqalify it if result cant be found
	local starts, ends = string.find( self:BRTGetTextToRespondTo(), tag, 1, true )
	local strlen = 0
if starts ~= nil then
	pal["match_level_length_processed"] = pal["match_level_length_processed"] -string.len( tag )
	pal["match_level_words_processed"] = pal["match_level_words_processed"] -1
	strlen = string.len( tag )
end
return true, strlen
end

function pal:AddNewTagGroup( name, collection ) --a collection of tags which if refrenced like so @TAG_NAME, in the search for sections of added info will be replaced with collection
if RunSelfHooks( "PALOnAddTagGroup", {name,collection} ) == false then return end
	pal["searchfor_groups"][#pal["searchfor_groups"] +1] = {["groupname"]=name,["tags"]=collection}
end

function pal:DegradeInfoOverXCycles( id, cyclesinfostayesinmemory ) --makes info eventually degrades to nothing use to simulates forgetfulness
if RunSelfHooks( "PALOnDegradeInfoOverXCycles", {id,cyclesinfostayesinmemory} ) == false then return end
	local index = 0
for z = 1, #result do
if result[z]["id"] == id then
	index = z
   end
end
if pal["info_degrade_level"][index] == nil and index >= 1 then pal["info_degrade_level"][index] = cyclesinfostayesinmemory -1 end
end

function pal:RemoveInfo( id )
if RunSelfHooks( "PALOnRemoveInfo", id ) == false then return end
if inruntime == true then pal["info_database_removed" +1] = id end
for z = 1, #pal["info_database"] do
if id == pal["info_database"][z]["id"] then pal["info_database"][z] = nil end
end
   
for z = 1, #pal["info_database_added"] do
if id == pal["info_database_added"][z]["id"] then pal["info_database_added"][z] = nil end
   end   
end

function pal:SetNewInfo( searchfor, searchfor_prior, emotion_change, annoyable, inportance, responces, subresponces, id, append ) --SearchFor is done like so {"hodey","hello","hi"} it can ethier even functions like "֍hi( true )"
if pal:RunSelfHooks( "PALOnSetNewInfo", {searchfor,searchfor_prior,emotion_change,annoyable,inportance,responces,subresponces,id,append} ) == false then return end
for z = 1, #searchfor do
for y = 1, #pal["searchfor_groups"] do
if searchfor[z] == "@"..pal["searchfor_groups"][y]["groupname"] then 
for x = 1, #pal["searchfor_groups"][y]["tags"] do
	searchfor[#searchfor +1] = pal["searchfor_groups"][y]["tags"][x]
         end
	  end
   end
end

for z = 1, #searchfor_prior do
for y = 1, #pal["searchfor_groups"] do
if searchfor_prior[z] == "@"..pal["searchfor_groups"][y]["groupname"] then 
for x = 1, #pal["searchfor_groups"][y]["tags"] do
	searchfor_prior[#searchfor_prior +1] = pal["searchfor_groups"][y]["tags"][x]
         end
	  end
   end
end

	pal["info_database"][#pal["info_database"] +1] = {["sf"]=searchfor,["sfl"]=searchfor_prior,["ec"]=emotion_change,["a"]=annoyable,["i"]=inportance,["responces"]=responces,["subresponces"]=subresponces,["id"]=id,["append"]=append}
if inruntime == true then pal["info_database_added"][#pal["info_database_added"] +1] = pal["info_database"][#pal["info_database"]] end
for z = 1, #pal["info_database_removed"] do
if pal["info_database_removed"][z] == id then pal["info_database_removed"][z] = nil end
   end
end

function pal:SetNewInfoTbl( tbl ) --an unscure but fast way of adding info
if RunSelfHooks( "PALOnSetNewInfoTbl", {tbl} ) == false then return end

for z = 1, #searchfor do
for y = 1, #pal["searchfor_groups"] do
if searchfor[z] == "@"..pal["searchfor_groups"][y]["groupname"] then 
for x = 1, #pal["searchfor_groups"][y]["tags"] do
	searchfor[#searchfor +1] = pal["searchfor_groups"][y]["tags"][x]
         end
	  end
   end
end

for z = 1, #searchfor_prior do
for y = 1, #pal["searchfor_groups"] do
if searchfor_prior[z] == "@"..pal["searchfor_groups"][y]["groupname"] then 
for x = 1, #pal["searchfor_groups"][y]["tags"] do
	searchfor_prior[#searchfor_prior +1] = pal["searchfor_groups"][y]["tags"][x]
         end
	  end
   end
end
	pal["info_database"][#pal["info_database"] +1] = tbl
if inruntime == true then pal["info_database_added"][#pal["info_database_added"] +1] = pal["info_database"][#pal["info_database"]] end
for z = 1, pal["info_database_removed"] do
if pal["info_database_removed"][z] == id then pal["info_database_removed"][z] = nil end
   end
end

function pal:ReturnInfo( searchfor, searchfor_prior, emotion_change, annoyable, inportance, responces, subresponces, id, append ) --format like so {"word","word","word"}, {"word","from","the","prior","text","responded","to"}, {0.15,0.001}, true, 1, {"hi","bye","gay"}, {ReturnInfo( DATA ),ReturnInfo( DATA )}, "code_for_editing_info", "appends_to_all_responces"
if RunSelfHooks( "PALOnReturnInfo", {searchfor,searchfor_prior,emotion_change,annoyable,inportance,responces,subresponces,id,append} ) == false then return end

for z = 1, #searchfor do
for y = 1, #pal["searchfor_groups"] do
if searchfor[z] == "@"..pal["searchfor_groups"][y]["groupname"] then 
for x = 1, #pal["searchfor_groups"][y]["tags"] do
	searchfor[#searchfor +1] = pal["searchfor_groups"][y]["tags"][x]
         end
	  end
   end
end

for z = 1, #searchfor_prior do
for y = 1, #pal["searchfor_groups"] do
if searchfor_prior[z] == "@"..pal["searchfor_groups"][y]["groupname"] then 
for x = 1, #pal["searchfor_groups"][y]["tags"] do
	searchfor_prior[#searchfor_prior +1] = pal["searchfor_groups"][y]["tags"][x]
         end
	  end
   end
end

return {["sf"]=searchfor,["sfl"]=searchfor_prior,["ec"]=emotion_change,["a"]=annoyable,["i"]=inportance,["responces"]=responces,["subresponces"]=subresponces,["id"]=id,["append"]=append}
end

function pal:RemoveAllInfo() --removes all the info and all memory of it ever exsisting
if RunSelfHooks( "PALOnRemoveAllInfo", {} ) == false then return end
	pal["info_database"] = nil
	pal["info_database_added"] = nil
	pal["info_database_removed"] = nil
	pal["info_database_removed"] = {}
	pal["info_database_added"] = {}
	pal["info_database"] = {}
end

function pal:GetInfoByIndex( index ) --finds info by the index which repasents it placement it the database
	local result = pal["info_database"][index]
if result == nil then return {} end
return {["sf"]=result["sf"],["sfl"]=result["sfl"],["ec"]=result["ec"],["a"]=result["a"],["i"]=result["i"],["responces"]=result["responces"],["subresponces"]=result["subresponces"],["id"]=result["id"],["append"]=result["append"]}
end

function pal:GetInfoById( id ) --finds info by id
	local results = {}
for z = 1, #result do
if result[z]["id"] == id then
	local result = pal["info_database"][z]
	results[#results +1] = {["sf"]=result["sf"],["sfl"]=result["sfl"],["ec"]=result["ec"],["a"]=result["a"],["i"]=result["i"],["responces"]=result["responces"],["subresponces"]=result["subresponces"],["id"]=result["id"],["append"]=result["append"]}
   end
end
if #results <= 1 then return results[1] else return results end
end

function pal:GetInfoIndexById( id )
	local result = pal["info_database"]
	local results = {}
for z = 1, #result do
if result[z]["id"] == id then
	results[#results +1] = z
   end
end
if #results <= 1 then return results[1] else return results end
end

function pal:AddSpellChecking( correct, ... ) --spellchecker
if pal:RunSelfHooks( "PALOnAddSpellChecking", {correct,...} ) == false then return end
	pal["spellchecking"][#pal["spellchecking"] +1] = {["c"]=correct,["i"]={...}}
end

function pal:SetNewSynonymsGroup( id, ... ) --for grouping synonyms togethed so that one could be select via the id
if RunSelfHooks( "PALOnSetNewSynonymsGroup", {correct,...} ) == false then return end
	pal["synonyms_groups"][id] = {...}
end

function pal:GetSynonymsWord( id ) --gets a synonym from a synonym id
return pal["synonyms_groups"][id][math.random( 1, #pal["synonyms_groups"][id] )]
end

function pal:BuildEmotionGrid( size ) --sets the play field used for emotion simulation
if pal:RunSelfHooks( "PALOnBuildEmotionGrid", {size} ) == false then return end
	pal["emotion_grid_max_size"] = size
for x = 1, size do
for y = 1, size do
	pal["emotion_grid"][x] = {}
	pal["emotion_grid"][x][y] = {}
      end
   end 
end

function pal:AddNewEmotion( gridlocation, emotivewords, wordsthatmaketheaifeelmorelikethis, emotionclass, sentanceappending ) --for when the ai dose not have a responce
if pal:RunSelfHooks( "PALOnAddNewEmotion", {gridlocation,emotivewords,wordsthatmaketheaifeelmorelikethis,emotionclass,sentanceappending} ) == false then return end
	pal["emotion_grid"][gridlocation[1]][gridlocation[2]] = {["words"]=emotivewords,["wtmifmlt"]=wordsthatmaketheaifeelmorelikethis,["emotionclass"]=emotionclass,["sentanceappending"]=sentanceappending,}
end

function pal:EmotionLevelEquals( tbl ) --can be used in responces to determin if this responce could or should have a chance of selection
return ( tbl[1] == math.floor( 0.50 +pal["emotion_level"][1] ) and tbl[2] == math.floor( 0.50 +pal["emotion_level"][2] ) )
end

function pal:EmotionLevelNotEquals( tbl ) 
return ( tbl[1] ~= math.floor( 0.50 +pal["emotion_level"][1] ) or tbl[2] ~= math.floor( 0.50 +pal["emotion_level"][2] ) )
end

function pal:GetEmotiveWord() --words that describe what it thinks of the user
if pal["emotion_grid"][math.floor( 0.50 +pal["emotion_level"][1] )][math.floor( 0.50 +pal["emotion_level"][2] )]["words"] == nil then return "" end
return pal["emotion_grid"][math.floor( 0.50 +pal["emotion_level"][1] )][math.floor( 0.50 +pal["emotion_level"][2] )]["words"][math.random( 1, #pal["emotion_grid"][pal["emotion_level"][1]][pal["emotion_level"][2]]["words"] )]
end

function pal:GetEmotiveClass() --words that describe how it is feeling in genral
if pal["emotion_grid"][math.floor( 0.50 +pal["emotion_level"][1] )][math.floor( 0.50 +pal["emotion_level"][2] )]["emotionclass"] == nil then return "" end
return pal["emotion_grid"][math.floor( 0.50 +pal["emotion_level"][1] )][math.floor( 0.50 +pal["emotion_level"][2] )]["emotionclass"][math.random( 1, #pal["emotion_grid"][pal["emotion_level"][1]][pal["emotion_level"][2]]["emotionclass"] )]
end

function pal:GetEmotiveEnd() --an emotive ending to a sentence
if pal["emotion_grid"][math.floor( 0.50 +pal["emotion_level"][1] )][math.floor( 0.50 +pal["emotion_level"][2] )]["sentanceappending"] == nil then return "" end
return pal["emotion_grid"][math.floor( 0.50 +pal["emotion_level"][1] )][math.floor( 0.50 +pal["emotion_level"][2] )]["sentanceappending"][math.random( 1, #pal["emotion_grid"][pal["emotion_level"][1]][pal["emotion_level"][2]]["sentanceappending"] )]
end

function pal:SetNewIDKresponces( responce ) --for when the ai dose not have a responce
	pal["idk_responces"][#pal["idk_responces"] +1] = responce
end

function pal:GetIDKresponce()
if #pal["idk_responces"] <= 0 then return "ERROR: AI TRIED TO MAKE AN IDK RESPONCE BUT HAS NO IDK DATA" end
return pal["idk_responces"][math.random( 1, #pal["idk_responces"] )]
end

function pal:SetNewAnnoyanceRespoces( level, responce ) --for if you ask the same question to many times
if pal:RunSelfHooks( "PALOnSetNewAnnoyanceRespoces", {level,responce} ) == false then return end
if level == 1 then pal["annoyance_responces_attachment"][#pal["annoyance_responces_attachment"] +1] = responce end --at level 1 it will still awnser questions and stuff but it will tell you this is getting annoying
if level == 2 then pal["annoyance_responces"][#pal["annoyance_responces"] +1] = responce end --at level 2 it will refuse to awnser questions
end

function pal:GetAnnoyanceRespoce( level ) --for if you ask the same question to many times
if level == 1 then return pal["annoyance_responces_attachment"][math.random( 1, #pal["annoyance_responces_attachment"] )] end
if level == 2 then return pal["annoyance_responces"][math.random( 1, #pal["annoyance_responces"] )] end
end

function pal:SetPriorInput( text ) --sets the previous thing the player said
if pal:RunSelfHooks( "PALOnSetPriorInput", {text} ) == false then return end
	pal["prior_input"] = text
end

function pal:GetPriorInput() --the previous thing the player said
return pal["prior_input"]
end

pal:BuildEmotionGrid( pal["emotion_grid_max_size"] )

-- end of data control functions and start of AI loop --------------------------------------------------------------------------------------------------------

function pal:EmotionGravatate() --allows for emotion to go back to normal levels
	local x = pal["emotion_level_wanted"][1] -pal["emotion_level"][1]
	local y = pal["emotion_level_wanted"][2] -pal["emotion_level"][2]
	x = ( x /( x+y ) ) *pal["emotion_gravatate_power"]; y = ( y /( x+y ) ) *pal["emotion_gravatate_power"]
	pal["emotion_level"][1] = pal["emotion_level"][1] +x
	pal["emotion_level"][2] = pal["emotion_level"][2] +y
end

function pal:AnnoyanceDecreese() --allows for annoyence to war off over time
if pal["annoyance_decreese_time"] == nil then pal["annoyance_decreese_time"] = pal["annoyance_decreese_in"] end
	pal["annoyance_decreese_time"] = pal["annoyance_decreese_time"] -1
if pal["annoyance_decreese_time"] <= 0 then
	pal["annoyance_decreese_time"] = nil
for k, v in pairs( pal["annoyance_responcecounter"] ) do
	pal["annoyance_responcecounter"][k] = pal["annoyance_responcecounter"][k] -1
if v <= 0 then pal["annoyance_responcecounter"][k] = nil end
      end
   end
end

function pal:DegradeInfo() --dose the actually info degradeing
for k, v in pairs( pal["info_degrade_level"] ) do
	v = v -1
if v <= 0 then
	pal["info_database_removed"][#pal["info_database_removed"] +1] = pal["info_database"][k]["id"]
	pal["info_database"][k], pal["info_degrade_level"][k] = nil, nil
      end
   end
end

function pal:Loop() --runs every second but it only a simulation meaning anything that envolves printing can not be done in this
if pal:RunSelfHooks( "PALOnLoop", {} ) == false then return end
pal:EmotionGravatate()  --remove here to remove emotion change
pal:AnnoyanceDecreese()
pal:DegradeInfo()
--put any code here
end

function pal:RunLoopSimulation()
if pal["last_sim_time"] == nil then pal["last_sim_time"] = os.time() end
	local simlen = os.time() -pal["last_sim_time"]
	pal["last_sim_time"] = os.time()	
for z = 1, simlen do pal:Loop() end
end

function pal:RunSpellCheck( input ) --fixes spelling issues in what theplayer says so it is easyer to find the best responce to what the player says
if pal:RunSelfHooks( "PALOnRunSpellCheck", {input} ) == false then return end
	local mstr = ( string.gsub( input, ".", {["("]="%(",[")"]="%)",["."]="%.",["%"]="%%",["+"]="%+",["-"]="%-",["*"]="%*",["?"]="%?",["["]="%[",["]"]="%]",["^"]="%^",["$"]="%$",["\0"]="%z"} ) )
	local nul = 0
for z = 1, #pal["spellchecking"] do
for y = 1, #pal["spellchecking"][z]["i"] do
	mstr, nul = string.gsub( mstr, pal["spellchecking"][z]["i"][y].." ", pal["spellchecking"][z]["c"].." " )
if input == pal["spellchecking"][z]["i"][y] then mstr = pal["spellchecking"][z]["c"] end
   end
end
return mstr
end

function pal:RunAjustEmotionToEmotiveKeyWords( input ) --allows for to AI to feel hurt by the manner of which the player speeks
if pal:RunSelfHooks( "PALOnRunAjustEmotionToEmotiveKeyWords", {input} ) == false then return end
	local xy = {0,0}

for x = 1, pal["emotion_grid_max_size"] do
for y = 1, pal["emotion_grid_max_size"] do
if pal["emotion_grid"][x] ~= nil and pal["emotion_grid"][x][y] ~= nil and pal["emotion_grid"][x][y]["words"] ~= nil then
for z = 1, #pal["emotion_grid"][x][y]["words"] do
	local has, word = string.find( input, pal["emotion_grid"][x][y]["words"][z], 1, true )
if has ~= nil then
	xy[1] = x
	xy[2] = y
      end
   end
end

if pal["emotion_grid"][x] ~= nil and pal["emotion_grid"][x][y] ~= nil and pal["emotion_grid"][x][y]["wtmifmlt"] ~= nil then
for z = 1, #pal["emotion_grid"][x][y]["wtmifmlt"] do
	local has, word = string.find( input, pal["emotion_grid"][x][y]["wtmifmlt"][z], 1, true )
if has ~= nil then
	xy[1] = x
	xy[2] = y
            end
         end
      end
   end
end

	xy[1] = xy[1] /( xy[1] +xy[2] )
	xy[2] = xy[2] /( xy[1] +xy[2] )
	pal["emotion_level"][1]	= pal["emotion_level"][1] +( xy[1] *pal["emotion_sensitivity"] )
	pal["emotion_level"][2] = pal["emotion_level"][2] +( xy[2] *pal["emotion_sensitivity"] )
	pal["emotion_level"][1] = math.max( 1, math.min( pal["emotion_grid_max_size"], pal["emotion_level"][1] ) )
	pal["emotion_level"][2] = math.max( 1, math.min( pal["emotion_grid_max_size"], pal["emotion_level"][2] ) )
if pal:RunSelfHooks( "PALRunAjustEmotionToEmotiveKeyWordsNewEmotion", {input,{pal["emotion_level"][1],pal["emotion_level"][2]}} ) == false then return end
end

function pal:RunFindResponce( input )
if pal:RunSelfHooks( "PALOnRunFindResponce", {input} ) == false then return end

	pal["current_responce_importance"] = -999
	pal["match_level_words_processed_old"] = -1
	local currentresponceindex = -1

for index = 1, #pal["info_database"] do --searches thougth all infomation in pal's info_database
if pal["info_database"] ~= nil then

	pal["match_level_length_processed"] = 0
	pal["match_level_words_processed"] = 0

	local searchin = pal["info_database"][index]["sf"]
	local searchin_prior = pal["info_database"][index]["sfl"]
	local importance = pal["info_database"][index]["i"] or 0

if searchin ~= nil then --checks to see if the text the player entered shares enougth words with the current infomation being searched thougth
	pal["found_tag"]  = false
	pal["found_tag_at"] = 0
for z = 1, #searchin do
	local text = searchin[z]
if string.len( text ) <= 4 then text = text.." " end
if string.sub( text, 1, 1 ) == pal["runfunctionkey"] and string.sub( text, string.len( text ), string.len( text ) ) == pal["runfunctionkey"] then
	local run, err = load( "return "..string.sub( text, 2, string.len( text ) -1 ) )
	local ft, fta = run()
	pal["found_tag"] = ( ft == true )
	pal["found_tag_at"] = pal["found_tag_at"] +( fta or 999999 )
else
	local starts, ends = string.find( input, text, 1, true )
if starts ~= nil then
	pal["found_tag"] = true
	pal["found_tag_at"] = pal["found_tag_at"] +string.len( text )
   end
end


if pal["found_tag"]  == true then 
if pal["found_tag_at"] >= pal["match_level_length_processed"] then
	pal["match_level_length_processed"] = pal["found_tag_at"]
	pal["match_level_words_processed"] = pal["match_level_words_processed"] +1
else
	pal["found_tag_at"] = -99999999
end
else
	pal["found_tag_at"] = -99999999
   end 
end
if pal["match_level_words_processed"] >= #searchin then pal["found_tag_at"] = -99999999 end
end

if searchin_prior ~= nil then --checks to see if the text the player entered previously shares enougth words with the current infomation being searched thougth
	pal["found_tag"]  = false
for z = 1, #searchin_prior do
	local text = searchin_prior[z]
if string.len( text ) <= 4 then text = text.." " end
if string.sub( text, 1, 1 ) == pal["runfunctionkey"] and string.sub( text, string.len( text ), string.len( text ) ) == pal["runfunctionkey"] then
	local run, null = load( "return"..string.sub( text, 2, string.len( text ) -1 ) )
	local ft, fta = run()
	pal["found_tag"] = ( ft == true )
	pal["found_tag_at"] = pal["found_tag_at"] +( fta or 0 )
else
	local starts, ends = string.find( input, text, 1, true )
if starts ~= nil then
	pal["found_tag"]  = true
	pal["found_tag_at"] = pal["found_tag_at"] +string.len( text )
   end
end

if pal["found_tag"]  == true then 
if pal["found_tag_at"] >= pal["match_level_length_processed"] then
	pal["match_level_length_processed"] = pal["found_tag_at"]
	pal["match_level_words_processed"] = pal["match_level_words_processed"] +1
else
	pal["found_tag_at"] = -99999999
end
else
	pal["found_tag_at"] = -99999999
      end 
   end 
end

if pal["match_level_length_processed"] >= 1 then --checks acceptablity
if pal["match_level_words_processed"] >= pal["match_level_words_processed_old"] then --checks acceptablity
if importance >= pal["current_responce_importance"] then --checks acceptablity

	pal["match_level_words_processed_old"] = pal["match_level_words_processed"] --updates minmal acceptablity level
	pal["current_responce_importance"] = importance --updates minmal acceptablity level
	currentresponceindex = index

            end
         end
      end
   end
end

if currentresponceindex ~= -1 then
if pal:RunSelfHooks( "PALOnRunFindResponceFound", {currentresponceindex} ) == false then return end
	return currentresponceindex
   end
end

function pal:RunAnnoyanceTest( inputindex, input ) --simulate annoyance
	local annoyedlevel = pal["annoyance_responcecounter"][inputindex] or 0
if pal:RunSelfHooks( "PALOnRunAnnoyanceTest", {inputindex, input, annoyedlevel} ) == false then return end

	pal["annoyance_responcecounter"][inputindex] = math.min( annoyedlevel +1, pal["annoyance_maxlevel"] )

if annoyedlevel >= 1 then
if annoyedlevel >= pal["annoyance_maxlevel"] then
	return pal:GetAnnoyanceRespoce( 2 )
else
   return input.." "..pal:GetAnnoyanceRespoce( 1 )
end
else
   return input
   end
end

function pal:RunLuaCodeInResponce( input ) --exacutes any lua code in a responce from the responce section of infomation 
if input == nil then return end
if pal:RunSelfHooks( "PALOnRunLuaCodeInResponce", {input} ) == false then return end

	local outstring = input
	local stringdiffreance = 0
	local pointa = 0
	local pointb = 0

for z = 1, string.len( input ) do
if string.sub( input, z, z ) == pal["runfunctionkey"] then
if pointa == 0 then pointa = z else pointb = z end
if pointa ~= 0 and pointb ~= 0 then
  
	local exe, null = load( string.sub( input, pointa +1, pointb -1 ) )
	local result = exe()  
  
if result ~= nil then
	outstring = string.sub( outstring, 1, pointa -1 +stringdiffreance )..result..string.len( outstring, pointb +1 +stringdiffreance, string.len( outstring ) )
	stringdiffreance = string.len( outstring ) -string.len( input )	
end
	pointa, pointb = 0, 0
      end  
   end 
end

if pal:RunSelfHooks( "PALOnRunLuaCodeInResponceChange", {input,outstring} ) == false then return end
return outstring
end

function pal:BuildResponceTo( input ) --USE THIS TO GET THE AI TO MAKE A RESPONCE TO THE INPUT
	local master = input
	
function pal:BRTGetTextToRespondTo() return master end
if pal:RunSelfHooks( "PALOnBuildResponceTo", {input} ) == false then return end

self:RunLoopSimulation()

	master = self:RunSpellCheck( master )
self:RunAjustEmotionToEmotiveKeyWords( master ) --remove here to remove emotion change

	local outputindex = self:RunFindResponce( master )
	local outputdata = self:GetInfoByIndex( outputindex )

function pal:BRTGetInfoIndex() return outputindex end
if outputindex == nil then
	local str = pal:RunSelfHooks( "PALOnIDKoutput", {input} )
if str ~= nil and str ~= false then return str end
return self:GetIDKresponce() 
end
	
	local outputresponce = outputdata["responces"][math.random( 1, #outputdata["responces"] )]..( outputdata["sentanceappending"] or "" )
	
if outputdata["a"] ~= false then outputresponce = self:RunAnnoyanceTest( outputindex, outputresponce ) end

	pal["emotion_level"][1] = pal["emotion_level"][1] +outputdata["ec"][1]  --remove here to remove emotion change
	pal["emotion_level"][2] = pal["emotion_level"][2] +outputdata["ec"][2]  --remove here to remove emotion change
	pal["emotion_level"][1] = math.max( 1, math.min( pal["emotion_grid_max_size"], pal["emotion_level"][1] ) ) --remove here to remove emotion change
	pal["emotion_level"][2] = math.max( 1, math.min( pal["emotion_grid_max_size"], pal["emotion_level"][2] ) ) --remove here to remove emotion change

if outputdata["subresponces"] ~= nil then --add sub responces
for z = 1, #outputdata["subresponces"] do
self:AddInfoTbl( outputdata["subresponces"][z] )
   end
end

	pal["prior_input"] = input --used in the prior search
	outputresponce = pal:RunLuaCodeInResponce( outputresponce )
	
if pal:RunSelfHooks( "PALOnGotResponce", {outputresponce} ) == false then return end
	
return outputresponce
end

pal:RunLoopSimulation()

-- end of main ai loop and start of loading external data ----------------------------------------------------------------------------------------------------

function pal:SaveInfo() --saves all info added to AI after intal loading
if pal:RunSelfHooks( "PALOnSaveInfo", {} ) == false then return end

	local addresponcesfiledata = "" --start of saveing responce file data

for z = 1, #pal["info_database_added"] do
	local currententry = pal["info_database_added"][z]
	local responces = ""
	local subresponces = ""

for y = 1, currententry["responces"] do --reformats responces so thay can be saved with ease
if responces == "" then
responces = responces..currententry["responces"][y]
else
responces = responces..","..currententry[z]["responces"][y]
   end
end

for y = 1, pal["info_database_added"][z]["subresponces"] do --reformats sub info so thay can be saved with ease
	local currententryB = currententry["subresponces"][y]
	local currentdata = "{['sf']="..currententryB["sf"]..",['sfl']="..currententryB["sfl"]..",['ec']="..currententryB["ec"]..",['a']="..currententryB["a"]..",['i']="..currententryB["i"]..",['id']="..currententryB["id"]..",['append']="..currententryB["append"].."}"
if subresponces == "" then
subresponces = subresponces..currentdata
else
subresponces = subresponces..","..currentdata
   end
end
	

	local currentline = "pal:AddInfo( "..tostring( currententry["sf"] )..", "..tostring( currententry["sfl"] )..", {"..tostring( currententry["ec"][1] )..","..tostring( currententry["ec"][2] ).."}, "..tostring( currententry["a"] )..", "..tostring( currententry["i"] )..", {"..tostring( responces ).."}, {"..tostring( subresponces ).."}, "..tostring( currententry["id"] )..", "..tostring( currententry["append"] ).." )"
if addresponcesfiledata == "" then --responce saveing
addresponcesfiledata = addresponcesfiledata..currentline
else
addresponcesfiledata = addresponcesfiledata..string.char( 10 )..currentdata
   end
end

for z = 1, #pal["info_database_removed"] do --deleted responces saveing
	local currententry = pal["info_database_removed"][z]
	local currentdata = "pal:RemoveInfo( "..currententry.." )"
if addresponcesfiledata == "" then
addresponcesfiledata = addresponcesfiledata..currentdata
else
addresponcesfiledata = addresponcesfiledata..string.char( 10 )..currentdata
   end
end

	local file = io.open( pal["save_directory"].."/".."main_save.dat", "w" )
io.write( addresponcesfiledata )
file:close()

end

function pal:LoadInfo()
if pal:RunSelfHooks( "PALOnLoadInfo", {} ) == false then return end
	local file =io.open( pal["save_directory"].."/".."main_save.dat" ,"r")
if file ~=nil then io.close( file ); file = true else file = false end
if file == true then dofile( pal["save_directory"].."/".."main_save.dat" ) end
end

function pal:SetRestorePoint() --sets a restore point that we can undo to which is useful for siturations where you may have more then one pal AI but only have one pal file
if pal:RunSelfHooks( "PALOnSetRestorePoint", {} ) == false then return end
if PAL_RESTORE_TABLE == nil then PAL_RESTORE_TABLE = {} end

for k, v in pairs( pal ) do
if k ~= "last_sim_time" then
	PAL_RESTORE_TABLE[k] = v
      end
   end
end

function pal:LoadRestorePoint() --loades restore point
if pal:RunSelfHooks( "PALOnLoadRestorePoint", {} ) == false then return end
if PAL_RESTORE_TABLE ~= nil then
	pal = nil
	pal = PAL_RESTORE_TABLE
   end
end

dofile( current_dir.."/AI/loads.lua" )

	inruntime = true
	
pal:LoadInfo()
pal:SetRestorePoint()

return pal
