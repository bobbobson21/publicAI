
	local inruntime = false
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
	pal["annoyance_effectemotionby"] = {-0.5,-0.5}
	pal["searchfor_groups"] = {}
	pal["max_gender_momory_time"] = 240
	pal["sandbox"] = {["funcs"]={},}
	pal["runfunctionkey"] = "|"

-- end of seting pal vars start of sandbox -------------------------------------------------------------------------------------------------------------------

function pal:GetVar( v ) return pal["sandbox"][v] end --sandbox is for data that pal needs to access
function pal:SetVar( k, v ) pal["sandbox"][k] = v end
function pal:SandBox() return pal["sandbox"]["funcs"] end --use the sandbox so that if you need to restore the AI to a prior point you can also restore function and values you created

-- end of sandbox start of hooks -----------------------------------------------------------------------------------------------------------------------------

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
	local mostcommonvalues = {}

if pal["selfhooks"][cat] ~= nil then
for k, v in pairs( pal["selfhooks"][cat] ) do
	local temp = {v( table.unpack( tbl ) )} --runs the hook and collects the returns
	
for l, w in pairs( temp ) do
if mostcommonvalues[l] == nil then mostcommonvalues[l] = {} end --l = value posistion
if mostcommonvalues[l]["*"..tostring( w )] == nil then mostcommonvalues[l]["*"..tostring( w )] = 0 end --w = the value; * is used to pervent clashes with MCVR which stands for most common value result
	mostcommonvalues[l]["*"..tostring( w )] = mostcommonvalues[l]["*"..tostring( w )] +1 --if value is detected increece its common level
if mostcommonvalues[l]["MCVR"] == nil then mostcommonvalues[l]["MCVR"] = 0 end --PAL_MCVR_!£$%^&*()_qwerty is where we store the highest common level
if mostcommonvalues[l]["*"..tostring( w )] >= mostcommonvalues[l]["MCVR"] then --if is most common for posistion
	mostcommonvalues[l]["MCVR"] = mostcommonvalues[l]["*"..tostring( w )]
	returns[l] = w --file under returns
         end
      end
   end
end

return table.unpack( returns ) --we only return the most common values because thats the only one you will care about
end

-- end of hooks start of data/info control functions ---------------------------------------------------------------------------------------------------------

function pal:NRT( tag ) --for tags/words you want it to seach for but only mark down the result and not desqalify it if result cant be found
	local starts, ends = string.find( pal:BRTGetTextToRespondTo(), " "..tag.." ", pal["found_tag_at"], true )
	local strlen = pal["found_tag_at"]
if starts ~= nil then
	strlen = strlen +string.len( tag )
else
if pal["found_tag_at"] >= pal["match_level_length_processed"] then
	pal["match_level_tags_processed"] = pal["match_level_tags_processed"] -1
   end
end
return true, strlen
end --also stands for non reqired tag

function pal:MWTG( name ) --compares input to a tag group and if one tag is found in input it returns true and pal["found_tag_at"] +tag length
if pal["searchfor_groups"][name] == nil then return false end
for k, v in pairs( pal["searchfor_groups"][name] ) do
	local starts, ends = string.find( pal:BRTGetTextToRespondTo(), " "..v.." ", pal["found_tag_at"], true )
if starts ~= nil then return true, pal["found_tag_at"] +string.len( v ) end --if found say
end   
return false, pal["found_tag_at"] --if no tag is found it retuns false and ends
end --also stands for match with tag group

function pal:MemGen( name, tbl ) --connets names to pronows and then puts it into short term memory
pal:AddNewSpellChecking( name, tbl )
if pal["gender_momory"] == nil then pal["gender_momory"] = {} end
	pal["gender_momory"][#pal["gender_momory"] +1] = name
	pal["gender_momory_time"] = pal["max_gender_momory_time"] --time it takes to lose it's short term memory for pronowns should be 4 minutes
end

function pal:DegradeInfoOverXCycles( id, cyclesinfostayesinmemory ) --makes info eventually degrades to nothing use to simulates forgetfulness
if pal:RunSelfHooks( "PALOnDegradeInfoOverXCycles", {id,cyclesinfostayesinmemory} ) == false then return end
for k, v in pairs( pal["info_database"] ) do
if v["id"] == id then
	pal["info_degrade_level"][k] = cyclesinfostayesinmemory -1
	  end
   end
end

function pal:SetNewInfo( searchfor, searchfor_prior, emotion_change, emotionappend, annoyable, inportance, responces, subinfo, append, id ) --SearchFor is done like so {"hodey","hello","hi"} it can ethier even functions like "֍hi( true )"
if pal:RunSelfHooks( "PALOnSetNewInfo", {searchfor,searchfor_prior,emotion_change,annoyable,inportance,responces,subinfo,id,append} ) == false then return end
	pal["info_database"][#pal["info_database"] +1] = {["sf"]=searchfor,["sfl"]=searchfor_prior,["ec"]=emotion_change,["ea"]=emotionappend,["a"]=annoyable,["i"]=inportance,["responces"]=responces,["subinfo"]=subinfo,["append"]=append,["id"]=id}

if inruntime == true then pal["info_database_added"][#pal["info_database_added"] +1] = pal["info_database"][#pal["info_database"]] end
for k, v in pairs( pal["info_database_removed"] ) do
if v == id then pal["info_database_removed"][k] = nil end
   end
end

function pal:SetNewInfoTbl( tbl, denysaving ) --an unscure but fast way of adding info
if pal:RunSelfHooks( "PALOnSetNewInfoTbl", {tbl} ) == false then return end
	pal["info_database"][#pal["info_database"] +1] = tbl

if denysaving ~= true then --this function has a deny saveing var because using it can result in the same info being saved more than once
if inruntime == true then pal["info_database_added"][#pal["info_database_added"] +1] = pal["info_database"][#pal["info_database"]] end
for k, v in pairs( pal["info_database_removed"] ) do
if v == id then pal["info_database_removed"][k] = nil end
      end
   end
end

function pal:ReturnInfo( searchfor, searchfor_prior, emotion_change, emotionappend, annoyable, inportance, responces, subinfo, append, id ) --format like so {"word","word","word"}, {"word","from","the","prior","text","responded","to"}, {0.15,0.001}, true, 1, {"hi","bye","gay"}, {ReturnInfo( DATA ),ReturnInfo( DATA )}, "code_for_editing_info", "appends_to_all_responces"
if pal:RunSelfHooks( "PALOnReturnInfo", {searchfor,searchfor_prior,emotion_change,annoyable,inportance,responces,subinfo,id,append} ) == false then return end
return {["sf"]=searchfor,["sfl"]=searchfor_prior,["ec"]=emotion_change,["ea"]=emotionappend,["a"]=annoyable,["i"]=inportance,["responces"]=responces,["subinfo"]=subinfo,["append"]=append,["id"]=id,}
end

function pal:RemoveInfo( id ) -- removes info by id
if pal:RunSelfHooks( "PALOnRemoveInfo", id ) == false then return end
if inruntime == true then pal["info_database_removed"][#pal["info_database_removed"] +1] = id end
for k, v in pairs( pal["info_database"] ) do
if id == v["id"] then pal["info_database"][k] = nil end
end
   
for k, v in pairs( pal["info_database_added"] ) do
if id == v["id"] then pal["info_database_added"][k] = nil end
   end   
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
	local resultin = pal["info_database"][index]
	local resultout = {}
if resultin == nil then return {} end
for k, v in pairs( resultin ) do resultout[k] = v end --to keep the noraml info table safe from changes to the retuned info
return resultout
end

function pal:GetInfoById( id ) --finds info by id
	local results = {}
for k, v in pairs( pal["info_database"] ) do
if v["id"] == id then
	local resultout = {}
for l, w in pairs( v ) do resultout[l] = w end
	results[#results +1] = resultout
   end
end
return results
end

function pal:GetInfoIndexById( id ) --finds info indexs by id
	local results = {}
for k, v in pairs( pal["info_database"] ) do
if v["id"] == id then
	results[#results +1] = k --k should be index
   end
end
return results
end

function pal:AddNewTagGroup( name, collection ) --a collection of tags which if refrenced like so @TAG_NAME, in the search for sections of added info will be replaced with collection
if pal:RunSelfHooks( "PALOnAddNewTagGroup", {name,collection} ) == false then return end
	pal["searchfor_groups"][name] = collection
end

function pal:RemoveTagGroup( name ) --remove tag group
if pal:RunSelfHooks( "PALOnRemoveTagGroup", {name} ) == false then return end
	pal["searchfor_groups"][name] = nil
end

function pal:AddNewSpellChecking( correct, tbl ) --spellchecker
if pal:RunSelfHooks( "PALOnAddNewSpellChecking", {correct,tbl} ) == false then return end
	pal["spellchecking"][#pal["spellchecking"] +1] = {["c"]=correct,["i"]=tbl}
end

function pal:RemoveSpellChecking( correct ) --spellchecker
if pal:RunSelfHooks( "PALOnRemoveSpellChecking", {correct} ) == false then return end
for k, v in pairs( pal["spellchecking"] ) do if v["c"] == correct then pal["spellchecking"][k] = nil end end
end

function pal:AddNewSynonymsGroup( id, tbl ) --for grouping synonyms togethed so that one could be select via the id
if pal:RunSelfHooks( "PALOnSetNewSynonymsGroup", {correct,tbl} ) == false then return end
	pal["synonyms_groups"][id] = tbl
end

function pal:RemoveSynonymsGroup( id ) --spellchecker
if pal:RunSelfHooks( "PALOnRemoveSynonymsGroup", {id} ) == false then return end
	pal["synonyms_groups"][id] = nil
end

function pal:GetSynonymsWord( id ) --gets a synonym from a synonym id
if pal["synonyms_groups"][id] == nil then return "" end
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
return ( tbl[1] == math.floor( pal["emotion_level"][1] +0.50 ) and tbl[2] == math.floor( pal["emotion_level"][2] +0.50 ) )
end

function pal:EmotionLevelNotEquals( tbl ) 
return ( tbl[1] ~= math.floor( pal["emotion_level"][1] +0.50 ) or tbl[2] ~= math.floor( pal["emotion_level"][2] +0.50 ) )
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
for z = 1, #ortable do if pal:EmotionLevelEquals( ortable[z] ) == true then returnstate = false end end
return returnstate
end

function pal:GetEmotiveWord() --words that describe what it thinks of the user
if pal["emotion_grid"][math.floor( 0.50 +pal["emotion_level"][1] )][math.floor( 0.50 +pal["emotion_level"][2] )] == nil then return "" end
if pal["emotion_grid"][math.floor( 0.50 +pal["emotion_level"][1] )][math.floor( 0.50 +pal["emotion_level"][2] )]["words"] == nil then return "" end
return pal["emotion_grid"][math.floor( 0.50 +pal["emotion_level"][1] )][math.floor( 0.50 +pal["emotion_level"][2] )]["words"][math.random( 1, #pal["emotion_grid"][math.floor( 0.50 +pal["emotion_level"][1] )][math.floor( 0.50 +pal["emotion_level"][2] )]["words"] )]
end

function pal:GetEmotiveClass() --words that describe how it is feeling in genral
if pal["emotion_grid"][math.floor( 0.50 +pal["emotion_level"][1] )][math.floor( 0.50 +pal["emotion_level"][2] )] == nil then return "" end
if pal["emotion_grid"][math.floor( 0.50 +pal["emotion_level"][1] )][math.floor( 0.50 +pal["emotion_level"][2] )]["emotionclass"] == nil then return "" end
return pal["emotion_grid"][math.floor( 0.50 +pal["emotion_level"][1] )][math.floor( 0.50 +pal["emotion_level"][2] )]["emotionclass"][math.random( 1, #pal["emotion_grid"][math.floor( 0.50 +pal["emotion_level"][1] )][math.floor( 0.50 +pal["emotion_level"][2] )]["emotionclass"] )]
end

function pal:GetEmotiveEnd() --an emotive ending to a sentence
if pal["emotion_grid"][math.floor( 0.50 +pal["emotion_level"][1] )][math.floor( 0.50 +pal["emotion_level"][2] )] == nil then return "" end
if pal["emotion_grid"][math.floor( 0.50 +pal["emotion_level"][1] )][math.floor( 0.50 +pal["emotion_level"][2] )]["sentanceappending"] == nil then return "" end
return pal["emotion_grid"][math.floor( 0.50 +pal["emotion_level"][1] )][math.floor( 0.50 +pal["emotion_level"][2] )]["sentanceappending"][math.random( 1, #pal["emotion_grid"][math.floor( 0.50 +pal["emotion_level"][1] )][math.floor( 0.50 +pal["emotion_level"][2] )]["sentanceappending"] )]
end

function pal:SetEmotiiveGravity( point, gravity ) --sets its main emotion
if pal:RunSelfHooks( "PALOnSetEmotiiveGravity", {point,gravity} ) == false then return end
	pal["emotion_level"] = point
	pal["emotion_level_wanted"], pal["emotion_gravatate_power"] = point, gravity
end

function pal:GetEmotiiveGravity()
return pal["emotion_level_wanted"], pal["emotion_gravatate_power"]
end

function pal:SetEmotiveWordPower( num ) --sets how strong it reacts to words like sware words
if pal:RunSelfHooks( "PALOnSetEmotiveWordPower", {num} ) == false then return end
	pal["emotion_sensitivity"] = num
end

function pal:GetEmotiveWordPower()
return pal["emotion_sensitivity"]
end

function pal:SetNewIDKresponces( responce ) --for when the ai dose not have a responce
	pal["idk_responces"][#pal["idk_responces"] +1] = responce
end

function pal:GetIDKresponce()
if #pal["idk_responces"] <= 0 then return "ERROR: AI TRIED TO MAKE AN IDK RESPONCE BUT HAS NO IDK DATA" end
return pal["idk_responces"][math.random( 1, #pal["idk_responces"] )]
end

function pal:SetMaxAnnoyanceAmount( num )
	pal["annoyance_maxlevel"] = num
end

function pal:GetMaxAnnoyanceAmount()
return pal["annoyance_maxlevel"]
end

function pal:SetNewAnnoyanceRespoces( level, responce ) --for if you ask the same question to many times
if pal:RunSelfHooks( "PALOnSetNewAnnoyanceRespoces", {level,responce} ) == false then return end
if level == 1 then pal["annoyance_responces_attachment"][#pal["annoyance_responces_attachment"] +1] = responce end --at level 1 it will still awnser questions and stuff but it will tell you this is getting annoying
if level == 2 then pal["annoyance_responces"][#pal["annoyance_responces"] +1] = responce end --at level 2 it will refuse to awnser questions
end

function pal:GetAnnoyanceRespoce( level ) --for if you ask the same question to many times
if #pal["annoyance_responces_attachment"] <= 0 then return "ERROR: AI TRIED TO APPEND ANOYANCE BUT THERE IS NO ANNOYANCE DATA" end
if #pal["annoyance_responces"] <= 0 then return "ERROR: AI TRIED TO MAKE AN ANNOYED RESPONCE BUT HAS NO ANNOYED RESPONCE DATA" end
if level == 1 then return pal["annoyance_responces_attachment"][math.random( 1, #pal["annoyance_responces_attachment"] )] end
if level == 2 then return pal["annoyance_responces"][math.random( 1, #pal["annoyance_responces"] )] end
end

function pal:GetAnnoyanceLevel( inputindex ) --for if you ask the same question to many times
	local annoyedlevel = pal["annoyance_responcecounter"][inputindex] or 0
if annoyedlevel >= 1 then
if annoyedlevel >= pal["annoyance_maxlevel"] then
   return 2
else
   return 1
   end
else
   return 0
   end
end

function pal:SetPriorInput( text ) --sets the previous thing the player said
if pal:RunSelfHooks( "PALOnSetPriorInput", {text} ) == false then return end
	pal["prior_input"] = text
end

function pal:GetPriorInput() --the previous thing the player said
return pal["prior_input"]
end

pal:BuildEmotionGrid( pal["emotion_grid_max_size"] )

-- end of data/info control functions and start of AI loop ---------------------------------------------------------------------------------------------------

function pal:EmotionGravatate() --allows for emotion to go back to normal levels
	local x = pal["emotion_level_wanted"][1] -pal["emotion_level"][1]
	local y = pal["emotion_level_wanted"][2] -pal["emotion_level"][2]
if x ~= 0 then x = ( x /( math.abs( x ) +math.abs( y ) ) ) *pal["emotion_gravatate_power"] end
if y ~= 0 then y = ( y /( math.abs( x ) +math.abs( y ) ) ) *pal["emotion_gravatate_power"] end
    pal["emotion_level"][1] = pal["emotion_level"][1] +x
	pal["emotion_level"][2] = pal["emotion_level"][2] +y
	pal["emotion_level"][1] = math.min( math.max( 1, pal["emotion_level"][1] ), pal["emotion_grid_max_size"] ) --remove here to remove emotion change
	pal["emotion_level"][2] = math.min( math.max( 1, pal["emotion_level"][2] ), pal["emotion_grid_max_size"] )
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
if pal["info_degrade_level"][k] <= 0 then
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
	mstr, nul = string.gsub( mstr, " "..v["i"][y].." ", " "..v["c"].." " )
if input == " "..v["i"][y].." " then mstr = " "..v["c"].." " end
   end
end
return mstr
end

--remove function below to get rid of emotion change
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
	pal["emotion_level"][1] = math.min( math.max( 1, pal["emotion_level"][1] ), pal["emotion_grid_max_size"] )
	pal["emotion_level"][2] = math.min( math.max( 1, pal["emotion_level"][2] ), pal["emotion_grid_max_size"] )
if pal:RunSelfHooks( "PALRunAjustEmotionToEmotiveKeyWordsNewEmotion", {input,{math.floor( 0.50 +pal["emotion_level"][1] ),math.floor( 0.50 +pal["emotion_level"][2] )}} ) == false then return end
end

function pal:RunFindResponce( input )
if pal:RunSelfHooks( "PALOnRunFindResponce", {input} ) == false then return end

	pal["current_responce_importance"] = -999
	pal["match_level_tags_processed_old"] = -999
	local currentresponceindex = -1

if pal["info_database"] ~= nil then
for k, v in pairs( pal["info_database"] ) do --pulls thougth all infomation in pal's info_database for it to be compare aginst

	local searchin = v["sf"]
	local searchin_prior = v["sfl"]
	local importance = v["i"] or 0

	pal["match_level_tags_processed"] = 0 --this data needs to not be lost in order for compareing results to add up

if searchin ~= nil and next( searchin ) ~= nil then --checks to see if the text the player entered shares enougth words with the current infomation being searched thougth
	pal["match_level_length_processed"] = 0 --this data needs to be lost for all compareing oparations
	pal["found_tag_at"] = 0 --this data can not be lost unitll all input/level 1 compareing is complete but it dose need to be lost at the start 
for l, w in pairs( searchin ) do
	pal["found_tag"] = false --this data need to be lost per tag check or it could cause isssues
	local tag = w
if string.sub( tag, 1, 1 ) == pal["runfunctionkey"] and string.sub( tag, string.len( tag ), string.len( tag ) ) == pal["runfunctionkey"] then --is tag in a function string if so run it
	local run, err = load( "return "..string.sub( tag, 2, string.len( tag ) -1 ) ) -- runs function
	local ft, fta = run()
	pal["found_tag"] = ( ft == true ) --did function say it found tag
	pal["found_tag_at"] = ( fta or pal["found_tag_at"] ) --did function say where to start searching for the next tag
else
	local starts, ends = string.find( input, " "..tag.." ", pal["found_tag_at"], true ) --if tag is not a function find it in player input as plain text
if starts ~= nil or input == " "..tag.." " then
	pal["found_tag"] = true --tag was found
	pal["found_tag_at"] = pal["found_tag_at"] +string.len( tag ) --where to start the search for the next one
   end
end

if pal["found_tag"] == true then 
if pal["found_tag_at"] >= pal["match_level_length_processed"] then
	pal["match_level_length_processed"] = pal["found_tag_at"]  --if length processed <= 0 then current search will be disguarded and it also hels as an extra means to compare data
	pal["match_level_tags_processed"] = pal["match_level_tags_processed"] +1 --tag found
else
	pal["found_tag_at"] = -99999999 --basiclly disguards current search if found tag at < length processed
	pal["match_level_length_processed"] = -99999999 --basiclly disguards current search if found tag at < length processed
end
else
	pal["found_tag_at"] = -99999999 --basiclly disguards current search if found tag == false
	pal["match_level_length_processed"] = -99999999 --basiclly disguards current search if found tag == false
      end
   end
end

if pal["found_tag_at"] >= 0 and pal["match_level_length_processed"] >= 0 and pal["match_level_tags_processed"] >= 0 then --to pervent prior search if first search already failed as if we dont do this it could result in broken returns
if searchin_prior ~= nil and next( searchin_prior ) ~= nil then --checks to see if the text the player entered previously shares enougth words with the current infomation being searched thougth
	local oldmatchleveltagsprocessed = pal["match_level_tags_processed"]
	pal["match_level_length_processed"] = 0
	pal["found_tag_at"] = 0
for l, w in pairs( searchin_prior ) do
	pal["found_tag"] = false
	local tag = w
if string.sub( tag, 1, 1 ) == pal["runfunctionkey"] and string.sub( tag, string.len( tag ), string.len( tag ) ) == pal["runfunctionkey"] then
	local run, err = load( "return "..string.sub( tag, 2, string.len( tag ) -1 ) )
	local ft, fta = run()
	pal["found_tag"] = ( ft == true )
	pal["found_tag_at"] = ( fta or pal["found_tag_at"] )
else
	local starts, ends = string.find( pal["prior_input"], " "..tag.." ", pal["found_tag_at"], true )
if starts ~= nil or pal["prior_input"] == " "..tag.." " then
	pal["found_tag"] = true
	pal["found_tag_at"] = pal["found_tag_at"] +string.len( tag )
   end
end

if pal["found_tag"] == true then 
if pal["found_tag_at"] >= pal["match_level_length_processed"] then
	pal["match_level_length_processed"] = pal["found_tag_at"]
	pal["match_level_tags_processed"] = pal["match_level_tags_processed"] +1
else
	pal["found_tag_at"] = -99999999
	pal["match_level_length_processed"] = -99999999
end
else
	pal["found_tag_at"] = -99999999
	pal["match_level_length_processed"] = -99999999
         end
      end
   end
end

if pal["match_level_length_processed"] >= 1 then --checks acceptablity
if pal["match_level_tags_processed"] >= pal["match_level_tags_processed_old"] then --checks acceptablity
if importance >= pal["current_responce_importance"] then --checks acceptablity

	pal["match_level_tags_processed_old"] = pal["match_level_tags_processed"] --updates minmal acceptablity level
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
	pal["emotion_level"][1] = pal["emotion_level"][1] +pal["annoyance_effectemotionby"][1]
	pal["emotion_level"][2] = pal["emotion_level"][2] +pal["annoyance_effectemotionby"][2]
	pal["emotion_level"][1] = math.min( math.max( 1, pal["emotion_level"][1] ), pal["emotion_grid_max_size"] ) --remove here to remove emotion change
	pal["emotion_level"][2] = math.min( math.max( 1, pal["emotion_level"][2] ), pal["emotion_grid_max_size"] )

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
else
	outstring = string.sub( outstring, 1, pointa -1 +stringdiffreance )..string.sub( outstring, pointb +1 +stringdiffreance, string.len( outstring ) )
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
function pal:BRTGetTextToRespondToOrignal() return input end --added just encase someone wants the orignal text the player types
	local master = pal:RunSpellCheck( string.lower( " "..input.." " ) ) --stage one: spellchecking
function pal:BRTGetTextToRespondTo() return master end --spell checking is done before this so that functions like the NRT do not have to continusely do spellchecking
	
	local A, B = pal:RunSelfHooks( "PALOnBuildResponceTo", {master} )
if A == false then return B end

pal:RunLoopSimulation() --stage two: this makes it so that the loop runs every second kinda
pal:RunAjustEmotionToEmotiveKeyWords( master ) --stage three: remove here to remove emotion change

	local outputindex = pal:RunFindResponce( master ) --stage four: find a suitable set responce
	local outputdata = pal:GetInfoByIndex( outputindex ) --stage four: fetch set responce

function pal:BRTGetInfoIndex() return outputindex end

if outputindex == nil then --if no responce could be found to what the user says run this code
	local A, B = pal:RunSelfHooks( "PALOnIDKoutput", {master} )
if A == false then return B end
return pal:GetIDKresponce() 
end

	local outputresponce = "" --stage five: pick a responce out of the set
	
if outputdata["responces"] ~= nil then outputresponce = outputdata["responces"][math.random( 1, #outputdata["responces"] )] end
if outputdata["ea"] ~= false then outputresponce = outputresponce.." "..pal:GetEmotiveEnd() end --stage six: appending of responce section --emotion appending
if outputdata["a"] ~= false then outputresponce = pal:RunAnnoyanceTest( outputindex, outputresponce ) end --stage six: annoyence appending
if pal:GetAnnoyanceLevel( outputindex ) == 2 then --stage six: end function if to annoyed appending
	local str = pal:RunSelfHooks( "PALOnMaxAnnoyanceoutput", {input} )
if str ~= nil and str ~= false then return str end
return outputresponce
end
	outputresponce = outputresponce..( outputdata["append"] or "" ) --stage six

if outputdata["ec"] ~= nil then --stage seven: remove here to remove emotion change
	pal["emotion_level"][1] = pal["emotion_level"][1] +outputdata["ec"][1]  --stage seven: remove here to remove emotion change
	pal["emotion_level"][2] = pal["emotion_level"][2] +outputdata["ec"][2]  --stage seven: remove here to remove emotion change
	pal["emotion_level"][1] = math.min( math.max( 1, pal["emotion_level"][1] ), pal["emotion_grid_max_size"] ) --stage seven: remove here to remove emotion change
	pal["emotion_level"][2] = math.min( math.max( 1, pal["emotion_level"][2] ), pal["emotion_grid_max_size"] ) --stage seven: remove here to remove emotion change
end --stage seven: remove here to remove emotion change

	pal["prior_input"] = master --stage eight: alllows us to search througth what the player said before what there currently saying 
	outputresponce = pal:RunLuaCodeInResponce( outputresponce )
	
if outputdata["subinfo"] ~= nil then --stage nine: add sub responces this was move to after to make it easy to replace id'ed responces
	for z = 1, #outputdata["subinfo"] do
if outputdata["subinfo"][z] ~= nil then 
	local t = outputdata["subinfo"][z]
pal:SetNewInfoTbl( outputdata["subinfo"][z], ( pal["info_database"][outputindex]["subinfoadded"] == true ) )
   end
end
	pal["info_database"][outputindex]["subinfoadded"] = true --stage nine: ensure that the save system only logs the responce being added once
end

local A, B = pal:RunSelfHooks( "PALOnGotResponce", {master} )
if A == false then return B end

return outputresponce
end

pal:RunLoopSimulation()

-- end of main ai loop and start of loading external data ----------------------------------------------------------------------------------------------------

function pal:SetInRunTime( irt ) --just encase you want to turn it off to load content without the save system taking note
	inruntime = irt
end

function pal:GetInRunTime() --just encase you want to turn it off to load content without the save system taking note
return inruntime
end

function pal:SaveInfo() --saves all info added to AI after intal loading
if pal:RunSelfHooks( "PALOnSaveInfo", {} ) == false then return end

	local addresponcesfiledata = "" --start of saveing responce file data

for k, v in pairs( pal["info_database_added"] ) do
	local responces = ""
	local sf = ""
	local sfp = ""

if v["sf"] ~= nil then
for y = 1, #v["sf"] do --reformats search data so thay can be saved with ease
if sf == "" then
	sf = sf.."'"..v["sf"][y].."'"
else
	sf = sf..",".."'"..v["sf"][y].."'"
      end
   end
end

if v["sfl"] ~= nil then
for y = 1, #v["sfl"] do --reformats prior search data so thay can be saved with ease
if sfp == "" then
	sfp = sfp.."'"..v["sfl"][y].."'"
else
	sfp = sfp..",".."'"..v["sfl"][y].."'"
      end
   end
end

if v["responces"] ~= nil then
for y = 1, #v["responces"] do --reformats responces so thay can be saved with ease
if responces == "" then
responces = responces.."'"..v["responces"][y].."'"
else
responces = responces..",".."'"..v["responces"][y].."'"
      end
   end
end

if v["ec"] == nil then v["ec"] = {0,0} end --pervents saveing issues

	local currentline = "pal:SetNewInfo( {"..tostring( sf ).."}, {"..tostring( sfp ).."}, {"..tostring( v["ec"][1] )..","..tostring( v["ec"][2] ).."}, "..tostring( v["a"] )..", "..tostring( v["i"] )..", {"..tostring( responces ).."}, nil, "..tostring( v["append"] )..", "..tostring( v["id"] ).." )"
if addresponcesfiledata == "" then --responce saveing
addresponcesfiledata = addresponcesfiledata..currentline
else
addresponcesfiledata = addresponcesfiledata..string.char( 10 )..currentline
   end
end

for k, v in pairs( pal["info_database_removed"] ) do
	local currentdata = "pal:RemoveInfo( "..v.." )"
if addresponcesfiledata == "" then
addresponcesfiledata = addresponcesfiledata..currentdata
else
addresponcesfiledata = addresponcesfiledata..string.char( 10 )..currentdata
   end
end

	local hasitbeendonebefore = {}
for k, v in pairs( pal["info_degrade_level"] ) do
	local currentdata = "pal:DegradeInfoOverXCyclesByIndex( "..tostring( pal["info_database"][k]["id"] )..","..tostring( v ).." )"
if pal["info_database"][k] ~= nil and pal["info_database"][k]["id"] ~= nil and hasitbeendonebefore[pal["info_database"][k]["id"]] ~= true then
	hasitbeendonebefore[pal["info_database"][k]["id"]] = true
if addresponcesfiledata == "" then
addresponcesfiledata = addresponcesfiledata..currentdata
else
addresponcesfiledata = addresponcesfiledata..string.char( 10 )..currentdata
      end
   end
end

io.output( "main_save.dat" ) --we are doing files this way because the other way just kept giving me grife
io.write( addresponcesfiledata )
io.close()
io.output( io.stdout )
end

function pal:LoadInfo()
if pal:RunSelfHooks( "PALOnLoadInfo", {} ) == false then return end
	local file = io.open( "main_save.dat" ,"r")
if file ~=nil then io.close( file ); file = true else file = false end
if file == true then dofile( "main_save.dat" ) end
end

function pal:SetRestorePoint() --sets a restore point that we can undo to which is useful for siturations where you may have more then one pal AI but only have one pal core running
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
	pal = {}
for k, v in pairs( PAL_RESTORE_TABLE ) do
	pal[k] = v
      end
   end
end

-- end of loading external data start of everything ----------------------------------------------------------------------------------------------------------

dofile( current_dir.."/AI/loads.lua" )

	inruntime = true
	
pal:LoadInfo()
pal:SetRestorePoint()

return pal
