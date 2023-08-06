
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
	pal["emotion_gravatate_power"] = 0.003
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

function pal:NRT( tag ) --for tags/words you want it to seach for but only mark down the result and not desqalify it if result cant be found
	local starts, ends = string.find( pal:BRTGetTextToRespondTo(), tag, pal["found_tag_at"], true )
	local strlen = pal["found_tag_at"]
if starts ~= nil then
	strlen = pal["found_tag_at"] +starts +string.len( tag )
else
	pal["match_level_words_processed"] = pal["match_level_words_processed"] -1
end
return true, strlen
end

function pal:MemGen( name, ... ) --connets names to pronows and then puts it into short term memory
pal:AddSpellChecking( name, ... )
if pal["gender_momory"] == nil then pal["gender_momory"] = {} end
	pal["gender_momory"][#pal["gender_momory"] +1] = name
	pal["gender_momory_time"] = 240 --time it takes to lose it's short term memory for pronowns should be 4 minutes
end

function pal:DegradeInfoOverXCycles( id, cyclesinfostayesinmemory ) --makes info eventually degrades to nothing use to simulates forgetfulness
if pal:RunSelfHooks( "PALOnDegradeInfoOverXCycles", {id,cyclesinfostayesinmemory} ) == false then return end
for k, v in pairs( pal["info_database"] ) do
if v["id"] == id then
	pal["info_degrade_level"][k] = cyclesinfostayesinmemory -1
      end
   end
end

function pal:AddNewTagGroup( name, collection ) --a collection of tags which if refrenced like so @TAG_NAME, in the search for sections of added info will be replaced with collection
if pal:RunSelfHooks( "PALOnAddTagGroup", {name,collection} ) == false then return end
	pal["searchfor_groups"][#pal["searchfor_groups"] +1] = {["groupname"]=name,["tags"]=collection}
end

function pal:LoadTagGroups( searchfor, searchfor_prior ) --puts the tag groups into the info
if searchfor ~= nil then
for k, v in pairs( searchfor ) do
for y = 1, #pal["searchfor_groups"] do
if v == "@"..pal["searchfor_groups"][y]["groupname"] then 
	searchfor[k] = nil
for x = 1, #pal["searchfor_groups"][y]["tags"] do
	searchfor[#searchfor +1] = pal["runfunctionkey"].."pal:NRT("..pal["searchfor_groups"][y]["tags"][x].."' )"..pal["runfunctionkey"]
		    end
	     end
      end
   end
end

if searchfor_prior ~= nil then
for k, v in pairs( searchfor_prior ) do
for y = 1, #pal["searchfor_groups"] do
if v == "@"..pal["searchfor_groups"][y]["groupname"] then 
	searchfor_prior[k] = nil
for x = 1, #pal["searchfor_groups"][y]["tags"] do
	searchfor_prior[#searchfor_prior +1] = pal["runfunctionkey"].."pal:NRT("..pal["searchfor_groups"][y]["tags"][x].."' )"..pal["runfunctionkey"]
	        end
	     end
      end
   end
end

return searchfor, searchfor_prior
end

function pal:RemoveInfo( id )
if pal:RunSelfHooks( "PALOnRemoveInfo", id ) == false then return end
if inruntime == true then pal["info_database_removed" +1] = id end
for k, v in pairs( pal["info_database"] ) do
if id == v["id"] then pal["info_database"][k] = nil end
end
   
for k, v in pairs( pal["info_database"] ) do
if id == v["id"] then pal["info_database_added"][k] = nil end
   end   
end

function pal:SetNewInfo( searchfor, searchfor_prior, emotion_change, annoyable, inportance, responces, subinfo, id, append ) --SearchFor is done like so {"hodey","hello","hi"} it can ethier even functions like "֍hi( true )"
if pal:RunSelfHooks( "PALOnSetNewInfo", {searchfor,searchfor_prior,emotion_change,annoyable,inportance,responces,subinfo,id,append} ) == false then return end
	searchfor, searchfor_prior = pal:LoadTagGroups( searchfor, searchfor_prior )
	pal["info_database"][#pal["info_database"] +1] = {["sf"]=searchfor,["sfl"]=searchfor_prior,["ec"]=emotion_change,["a"]=annoyable,["i"]=inportance,["responces"]=responces,["subinfo"]=subinfo,["id"]=id,["append"]=append}
if inruntime == true then pal["info_database_added"][#pal["info_database_added"] +1] = pal["info_database"][#pal["info_database"]] end
for k, v in pairs( pal["info_database_removed"] ) do
if v == id then pal["info_database_removed"][k] = nil end
   end
end

function pal:SetNewInfoTbl( tbl ) --an unscure but fast way of adding info
if pal:RunSelfHooks( "PALOnSetNewInfoTbl", {tbl} ) == false then return end
	a, b = pal:LoadTagGroups( tbl["sf"], tbl["sfl"] )
	pal["info_database"][#pal["info_database"] +1] = tbl

if inruntime == true then pal["info_database_added"][#pal["info_database_added"] +1] = pal["info_database"][#pal["info_database"]] end
for k, v in pairs( pal["info_database_removed"] ) do
if v == id then pal["info_database_removed"][k] = nil end
   end
end

function pal:ReturnInfo( searchfor, searchfor_prior, emotion_change, annoyable, inportance, responces, subinfo, id, append ) --format like so {"word","word","word"}, {"word","from","the","prior","text","responded","to"}, {0.15,0.001}, true, 1, {"hi","bye","gay"}, {ReturnInfo( DATA ),ReturnInfo( DATA )}, "code_for_editing_info", "appends_to_all_responces"
if pal:RunSelfHooks( "PALOnReturnInfo", {searchfor,searchfor_prior,emotion_change,annoyable,inportance,responces,subinfo,id,append} ) == false then return end
	searchfor, searchfor_prior = pal:LoadTagGroups( searchfor, searchfor_prior )
return {["sf"]=searchfor,["sfl"]=searchfor_prior,["ec"]=emotion_change,["a"]=annoyable,["i"]=inportance,["responces"]=responces,["subinfo"]=subinfo,["id"]=id,["append"]=append}
end

function pal:RemoveAllInfo() --removes all the info and all memory of it ever exsisting
if pal:RunSelfHooks( "PALOnRemoveAllInfo", {} ) == false then return end
	pal["info_database"] = nil
	pal["info_database_added"] = nil
	pal["info_database_removed"] = nil
	pal["info_database_removed"] = {}
	pal["info_database_added"] = {}
	pal["info_database"] = {}
end

function pal:GetInfoByIndex( index ) --finds info by the index which repasents its placement it the database
	local result = pal["info_database"][index]
if result == nil then return {} end
return {["sf"]=result["sf"],["sfl"]=result["sfl"],["ec"]=result["ec"],["a"]=result["a"],["i"]=result["i"],["responces"]=result["responces"],["subinfo"]=result["subinfo"],["id"]=result["id"],["append"]=result["append"]}
end

function pal:GetInfoById( id ) --finds info by id
	local results = {}
for k, v in pairs( pal["info_database"] ) do
if v["id"] == id then
	results[#results +1] = {["sf"]=v["sf"],["sfl"]=v["sfl"],["ec"]=v["ec"],["a"]=v["a"],["i"]=v["i"],["responces"]=v["responces"],["subinfo"]=v["subinfo"],["id"]=v["id"],["append"]=v["append"]}
   end
end
if #results <= 1 then return results[1] else return results end
end

function pal:GetInfoIndexById( id ) --finds info indexs by id
	local results = {}
for k, v in pairs( pal["info_database"] ) do
if v["id"] == id then
	results[#results +1] = k --k should be index
   end
end
if #results <= 1 then return results[1] else return results end
end

function pal:AddSpellChecking( correct, tbl ) --spellchecker
if pal:RunSelfHooks( "PALOnAddSpellChecking", {correct,tbl} ) == false then return end
	pal["spellchecking"][#pal["spellchecking"] +1] = {["c"]=correct,["i"]=tbl}
end

function pal:RemoveSpellChecking( correct ) --spellchecker
if pal:RunSelfHooks( "PALOnAddSpellChecking", {correct} ) == false then return end
for k, v in pairs( pal["spellchecking"] ) do if v["c"] == correct then pal["spellchecking"][k] = nil end end
end

function pal:SetNewSynonymsGroup( id, tbl ) --for grouping synonyms togethed so that one could be select via the id
if pal:RunSelfHooks( "PALOnSetNewSynonymsGroup", {correct,tbl} ) == false then return end
	pal["synonyms_groups"][id] = tbl
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

function pal:EmotionLevelEqualsOr( ... ) --give it a bunch of emotion points and if the emotion level = one of them it will return true
	local ortable = {...}
	local returnstate = false
for z = 1, #ortable do if pal:EmotionLevelEquals( ortable[z] ) == true then returnstate = true end end
return returnstate
end

function pal:EmotionLevelNotEqualsOr( ... ) --if the emotion level ~= any of the emotion points, it will return true
	local ortable = {...}
	local returnstate = true
for z = 1, #ortable do if pal:EmotionLevelEquals( ortable[z] ) == true then returnstate = fase end end
return returnstate
end

function pal:GetEmotiveWord() --words that describe what it thinks of the user
if pal["emotion_grid"][math.floor( 0.50 +pal["emotion_level"][1] )][math.floor( 0.50 +pal["emotion_level"][2] )]["words"] == nil then return "" end
return pal["emotion_grid"][math.floor( 0.50 +pal["emotion_level"][1] )][math.floor( 0.50 +pal["emotion_level"][2] )]["words"][math.random( 1, #pal["emotion_grid"][math.floor( 0.50 +pal["emotion_level"][1] )][math.floor( 0.50 +pal["emotion_level"][2] )]["words"] )]
end

function pal:GetEmotiveClass() --words that describe how it is feeling in genral
if pal["emotion_grid"][math.floor( 0.50 +pal["emotion_level"][1] )][math.floor( 0.50 +pal["emotion_level"][2] )]["emotionclass"] == nil then return "" end
return pal["emotion_grid"][math.floor( 0.50 +pal["emotion_level"][1] )][math.floor( 0.50 +pal["emotion_level"][2] )]["emotionclass"][math.random( 1, #pal["emotion_grid"][math.floor( 0.50 +pal["emotion_level"][1] )][math.floor( 0.50 +pal["emotion_level"][2] )]["emotionclass"] )]
end

function pal:GetEmotiveEnd() --an emotive ending to a sentence
if pal["emotion_grid"][math.floor( 0.50 +pal["emotion_level"][1] )][math.floor( 0.50 +pal["emotion_level"][2] )]["sentanceappending"] == nil then return "" end
return pal["emotion_grid"][math.floor( 0.50 +pal["emotion_level"][1] )][math.floor( 0.50 +pal["emotion_level"][2] )]["sentanceappending"][math.random( 1, #pal["emotion_grid"][math.floor( 0.50 +pal["emotion_level"][1] )][math.floor( 0.50 +pal["emotion_level"][2] )]["sentanceappending"] )]
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
if x ~= 0 then x = ( x /( math.abs( x ) +math.abs( y ) ) ) *pal["emotion_gravatate_power"] end
if y ~= 0 then y = ( y /( math.abs( x ) +math.abs( y ) ) ) *pal["emotion_gravatate_power"] end
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

function pal:MemGenDecreese() --forgets which pronowns gose to who
if pal["gender_momory_time"] == nil then return end
	pal["gender_momory_time"] = pal["gender_momory_time"] -1
	
if pal["gender_momory_time"] <= 0 then
	pal["gender_momory_time"] = nil
for k, v in pairs( pal["gender_momory"] ) do
pal:RemoveSpellChecking( v )
     end
   end
end

function pal:DegradeInfo() --dose the actually info degradeing
for k, v in pairs( pal["info_degrade_level"] ) do
	pal["info_degrade_level"][k] = pal["info_degrade_level"][k] -1
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
pal:MemGenDecreese()
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
for k, v in pairs( pal["spellchecking"] ) do
for y = 1, #v["i"] do
	mstr, nul = string.gsub( mstr, v["i"][y].." ", v["c"].." " )
if input == v["i"][y] then mstr = v["c"] end
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

if xy[1] ~= 0 then xy[1] = xy[1] /( math.abs( xy[1] ) +math.abs( xy[2] ) ) end
if xy[2] ~= 0 then xy[2] = xy[2] /( math.abs( xy[1] ) +math.abs( xy[2] ) ) end

	pal["emotion_level"][1]	= pal["emotion_level"][1] +( xy[1] *pal["emotion_sensitivity"] )
	pal["emotion_level"][2] = pal["emotion_level"][2] +( xy[2] *pal["emotion_sensitivity"] )
if pal:RunSelfHooks( "PALRunAjustEmotionToEmotiveKeyWordsNewEmotion", {input,{math.floor( 0.50 +pal["emotion_level"][1] ),math.floor( 0.50 +pal["emotion_level"][2] )}} ) == false then return end
end

function pal:RunFindResponce( input )
if pal:RunSelfHooks( "PALOnRunFindResponce", {input} ) == false then return end
	input = string.lower( input )

	pal["current_responce_importance"] = -999
	pal["match_level_words_processed_old"] = -1
	local currentresponceindex = -1

if pal["info_database"] ~= nil then
for k, v in pairs( pal["info_database"] ) do --searches thougth all infomation in pal's info_database

	pal["match_level_length_processed"] = 0
	pal["match_level_words_processed"] = 0

	local searchin = v["sf"]
	local searchin_prior = v["sfl"]
	local importance = v["i"] or 0

if searchin ~= nil then --checks to see if the text the player entered shares enougth words with the current infomation being searched thougth
	pal["found_tag_at"] = 0
for l, w in pairs( searchin ) do
	pal["found_tag"]  = false
	local text = w
if string.len( text ) <= 4 then text = text.." " end
if string.sub( text, 1, 1 ) == pal["runfunctionkey"] and string.sub( text, string.len( text ), string.len( text ) ) == pal["runfunctionkey"] then
	local run, err = load( "return "..string.sub( text, 2, string.len( text ) -1 ) )
	local ft, fta = run()
	pal["found_tag"] = ( ft == true )
	pal["found_tag_at"] = ( fta or 999999 )
else
	local starts, ends = string.find( input, text, pal["found_tag_at"], true )
if starts ~= nil then
	pal["found_tag"] = true
	pal["found_tag_at"] = starts +string.len( text )
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

if searchin_prior ~= nil then --checks to see if the text the player entered previously shares enougth words with the current infomation being searched thougth
for l, w in pairs( searchin_prior ) do
	pal["found_tag"]  = false
	local text = w
if string.len( text ) <= 4 then text = text.." " end
if string.sub( text, 1, 1 ) == pal["runfunctionkey"] and string.sub( text, string.len( text ), string.len( text ) ) == pal["runfunctionkey"] then
	local run, null = load( "return"..string.sub( text, 2, string.len( text ) -1 ) )
	local ft, fta = run()
	pal["found_tag"] = ( ft == true )
	pal["found_tag_at"] = ( fta or 999999 )
else
	local starts, ends = string.find( input, text, pal["found_tag_at"], true )
if starts ~= nil then
	pal["found_tag"] = true
	pal["found_tag_at"] = starts
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
	currentresponceindex = k

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
  
	local exe, null = load( "return "..string.sub( input, pointa +1, pointb -1 ) )
	local result = exe()  
  
if result ~= nil then
	outstring = string.sub( outstring, 1, pointa -1 +stringdiffreance )..result..string.sub( outstring, pointb +1 +stringdiffreance, string.len( outstring ) )
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

pal:RunLoopSimulation()

	master = pal:RunSpellCheck( master )
pal:RunAjustEmotionToEmotiveKeyWords( master ) --remove here to remove emotion change

	local outputindex = pal:RunFindResponce( master )
	local outputdata = pal:GetInfoByIndex( outputindex )

function pal:BRTGetInfoIndex() return outputindex end
if outputindex == nil then
	local str = pal:RunSelfHooks( "PALOnIDKoutput", {input} )
if str ~= nil and str ~= false then return str end
return pal:GetIDKresponce() 
end

	local outputresponce = outputdata["responces"][math.random( 1, #outputdata["responces"] )]..( outputdata["sentanceappending"] or "" )
	
if outputdata["a"] ~= false then outputresponce = pal:RunAnnoyanceTest( outputindex, outputresponce ) end

	pal["emotion_level"][1] = pal["emotion_level"][1] +outputdata["ec"][1]  --remove here to remove emotion change
	pal["emotion_level"][2] = pal["emotion_level"][2] +outputdata["ec"][2]  --remove here to remove emotion change

	pal["prior_input"] = input --used in the prior search
	outputresponce = pal:RunLuaCodeInResponce( outputresponce )
	
if outputdata["subinfo"] ~= nil then --add sub responces this was move to after to make it easy to replace id'ed responces
for z = 1, #outputdata["subinfo"] do
if outputdata["subinfo"][z] ~= nil then 
	local t = outputdata["subinfo"][z]
pal:SetNewInfoTbl( outputdata["subinfo"][z] )
      end
   end
end
	
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
	local subinfo = ""

for y = 1, currententry["responces"] do --reformats responces so thay can be saved with ease
if responces == "" then
responces = responces..currententry["responces"][y]
else
responces = responces..","..currententry[z]["responces"][y]
   end
end

for y = 1, pal["info_database_added"][z]["subinfo"] do --reformats sub info so thay can be saved with ease
	local currententryB = currententry["subinfo"][y]
	local currentdata = "{['sf']="..currententryB["sf"]..",['sfl']="..currententryB["sfl"]..",['ec']="..currententryB["ec"]..",['a']="..currententryB["a"]..",['i']="..currententryB["i"]..",['id']="..currententryB["id"]..",['append']="..currententryB["append"].."}"
if subinfo == "" then
subinfo = subinfo..currentdata
else
subinfo = subinfo..","..currentdata
   end
end
	

	local currentline = "pal:AddInfo( "..tostring( currententry["sf"] )..", "..tostring( currententry["sfl"] )..", {"..tostring( currententry["ec"][1] )..","..tostring( currententry["ec"][2] ).."}, "..tostring( currententry["a"] )..", "..tostring( currententry["i"] )..", {"..tostring( responces ).."}, {"..tostring( subinfo ).."}, "..tostring( currententry["id"] )..", "..tostring( currententry["append"] ).." )"
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
