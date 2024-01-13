
	local InRunTime = false
	local CurrentDirCommandData = io.popen( "cd" )
	local CurrentDir = CurrentDirCommandData:read( "*L" )
for Z = 1, string.len( CurrentDir ) do if string.sub( CurrentDir, Z, Z ) == string.char( 92 ) then CurrentDir = string.sub( CurrentDir, 1, Z -1 ).."/"..string.sub( CurrentDir, Z +1, string.len( CurrentDir ) ) end end
if string.sub( CurrentDir, string.len( CurrentDir ), string.len( CurrentDir ) ) == string.char( 10 ) then CurrentDir = string.sub( CurrentDir, 1, string.len( CurrentDir ) -1 ) end
CurrentDirCommandData:close()

	pal = {}
	pal["IDK_Responces"] = {}
	pal["IDK_TailoredResponces"] = {}
	pal["IDK_FailTailoredTagIfOver"] = 6
	pal["Info_Database"] = {}
	pal["Info_DatabaseAdded"] = {}
	pal["Info_DatabaseRemoved"] = {}
	pal["Info_DegradeLevel"] = {}
	pal["Emotion_Level"] = {3,2}
	pal["Emotion_LevelWanted"] = {3,2}
	pal["Emotion_Grid"] = {}
	pal["Emotion_GridMaxSize"] = 3
	pal["Emotion_Sensitivity"] = 0.2
	pal["Emotion_GravatatePower"] = 0.003
	pal["Annoyance_MaxLevel"] = 4
	pal["Annoyance_ResponceCounter"] = {}
	pal["Annoyance_ResponcesAttachment"] = {}
	pal["Annoyance_DecreeseIn"] = 15
	pal["Annoyance_Responces"] = {}
	pal["Annoyance_EffectEmotionBy"] = {-0.5,-0.5}
	pal["Tag_Groups"] = {}
	pal["Synonyms_Groups"] = {}
	pal["SelfHooks"] = {}
	pal["Spellchecking"] = {}
	pal["PriorEnteredInput"] = ""
	pal["MaxGenderMemoryTime"] = 240
	pal["Sandbox"] = {["Funcs"]={},}
	pal["RunFunctionKey"] = "|"

-- end of seting pal vars start of sandbox -------------------------------------------------------------------------------------------------------------------

function pal:GetVar( V ) return pal["Sandbox"][V] end --sandbox is for data that pal needs to access
function pal:SetVar( K, V ) pal["Sandbox"][K] = V end
function pal:SandBox() return pal["Sandbox"]["Funcs"] end --use the sandbox so that if you need to restore the AI to a prior point you can also restore function and values you created

-- end of sandbox start of hooks -----------------------------------------------------------------------------------------------------------------------------

function pal:SetNewSelfHook( Catagory, ID, Func ) --catagory, hook ID, function --adds hooks so systems can better interract with the AI
if pal["SelfHooks"][Catagory] == nil then pal["SelfHooks"][Catagory] = {} end
	pal["SelfHooks"][Catagory][ID] = Func
end

function pal:RemoveSelfHook( Catagory, ID )
if Catagory == nil then pal["SelfHooks"] = nil;  pal["SelfHooks"] = {}; return end
if ID == nil then pal["SelfHooks"][Catagory] = nil; return end
	pal["SelfHooks"][Catagory][ID] = nil
end

function pal:GetSelfHooksAsTable() --gets all the hooks
return pal["SelfHooks"]
end

function pal:RunSelfHooks( Catagory, VarTable ) --runs hooks
	local IsPalHookIdenifier = "PALOn"
if string.sub( Catagory, 1, string.len( IsPalHookIdenifier ) ) ~= IsPalHookIdenifier then return nil end --to make it only useable for pal functions as to not mess stuff up
	local Returns = {}
	local MostCommonValues = {}

if pal["SelfHooks"][Catagory] ~= nil then
for K, V in pairs( pal["SelfHooks"][Catagory] ) do
	local temp = {V( table.unpack( VarTable ) )} --runs the hook and collects the returns
	
for L, W in pairs( temp ) do
if MostCommonValues[L] == nil then MostCommonValues[L] = {} end --L = value posistion
if MostCommonValues[L]["*"..tostring( W )] == nil then MostCommonValues[L]["*"..tostring( W )] = 0 end --W = the value; * is used to pervent clashes with MCVR which stands for most common value result
	
	MostCommonValues[L]["*"..tostring( W )] = MostCommonValues[L]["*"..tostring( W )] +1 --if value is detected increece its common level
if MostCommonValues[L]["MCVR"] == nil then MostCommonValues[L]["MCVR"] = 0 end --MCVR is where we store the highest common level

if MostCommonValues[L]["*"..tostring( W )] >= MostCommonValues[L]["MCVR"] then --if is most common for posistion
	MostCommonValues[L]["MCVR"] = MostCommonValues[L]["*"..tostring( W )]
	Returns[L] = W --file under returns
         end
      end
   end
end

return table.unpack( Returns ) --we only return the most common values because thats the only one you will care about
end

-- end of hooks start of data/info control functions ---------------------------------------------------------------------------------------------------------

function pal:NRT( Tag ) --for tags/words you want it to seach for but only mark down the result and not desqalify it if result cant be found
	local CombinedTagLength = pal["FoundTagAt"]
if string.find( pal:BRTGetTextToRespondTo(), " "..tostring( Tag ).." ", pal["FoundTagAt"], true ) ~= nil or Tag == true then
	CombinedTagLength = CombinedTagLength +string.len( Tag )
else
if pal["FoundTagAt"] >= pal["MatchLevelLengthProcessed"] then
	pal["MatchLevelTagsProcessed"] = pal["MatchLevelTagsProcessed"] -1
   end
end
return true, CombinedTagLength
end --also stands for non reqired tag

function pal:MWTG( ID ) --compares input to a tag group and if one tag in the group is found in input it returns true and pal["FoundTagAt"] +tag length --also stands for match with tag group
if pal["Tag_Groups"][ID] == nil then return false end
for K, V in pairs( pal["Tag_Groups"][ID] ) do
if string.find( pal:BRTGetTextToRespondTo(), " "..V.." ", pal["FoundTagAt"], true ) ~= nil then return true, pal["FoundTagAt"] +string.len( V ) end --if found say
end   
return false, pal["FoundTagAt"] --if no tag is found it retuns false and ends
end --also stands for match with tag group

function pal:MemGen( ID, PronownTable ) --connets ids to pronows and then puts it into short term memory
pal:AddNewSpellChecking( ID, PronownTable )
if pal["GenderMemory"] == nil then pal["GenderMemory"] = {} end
	pal["GenderMemory"][#pal["GenderMemory"] +1] = ID
	pal["GenderMemoryTime"] = pal["MaxGenderMemoryTime"] --time it takes to lose it's short term memory for pronowns should be 4 minutes
end

function pal:SetMaxPronounMemoryAssociationTime( Seconds ) --time in seconds
	pal["MaxGenderMemoryTime"] = Seconds
end

function pal:GetMaxPronounMemoryAssociationTime() --time in seconds
return pal["MaxGenderMemoryTime"]
end

function pal:GetPronounMemoryAssociationTime() --time in seconds
return pal["GenderMemoryTime"] --not the max time
end

function pal:DegradeInfoOverXCycles( ID, CyclesInfoStayesInMemory ) --makes info eventually degrades to nothing use to simulates forgetfulness
if pal:RunSelfHooks( "PALOnDegradeInfoOverXCycles", {ID,CyclesInfoStayesInMemory} ) == false then return end
for K, V in pairs( pal["Info_Database"] ) do
if V["ID"] == ID then
	pal["Info_DegradeLevel"][K] = CyclesInfoStayesInMemory -1
	  end
   end
end

function pal:SetNewInfo( SearchFor, SearchForPrior, EmotionChange, EmotionAppend, Annoyable, Inportance, Responces, SubInfo, Append, ID ) --SearchFor is done like so {"hodey","hello","hi"} it can ethier even functions like "֍hi( true )"
if pal:RunSelfHooks( "PALOnSetNewInfo", {SearchFor,SearchForPrior,EmotionChange,Annoyable,Inportance,Responces,SubInfo,ID,Append} ) == false then return end
	pal["Info_Database"][#pal["Info_Database"] +1] = {["SearchFor"]=SearchFor,["PriorSearchFor"]=SearchForPrior,["EmotionChange"]=EmotionChange,["AppendEmotionStatment"]=EmotionAppend,["Annoyable"]=Annoyable,["Importance"]=Importance,["Responces"]=Responces,["SubInfo"]=SubInfo,["AppendAllResponcesWith"]=Append,["ID"]=ID}

if InRunTime == true then pal["Info_DatabaseAdded"][#pal["Info_DatabaseAdded"] +1] = pal["Info_Database"][#pal["Info_Database"]] end
for K, V in pairs( pal["Info_DatabaseRemoved"] ) do
if V == ID then pal["Info_DatabaseRemoved"][K] = nil end
   end
end

function pal:SetNewInfoTbl( InfoTable, DenySaveLoging ) --an unscure but fast way of adding info
if pal:RunSelfHooks( "PALOnSetNewInfoTbl", {InfoTable} ) == false then return end
	pal["Info_Database"][#pal["Info_Database"] +1] = InfoTable

if DenySaveLoging ~= true then --this function has a deny saveing var because using it can result in the same info being saved more than once
if InRunTime == true then pal["Info_DatabaseAdded"][#pal["Info_DatabaseAdded"] +1] = pal["Info_Database"][#pal["Info_Database"]] end
for K, V in pairs( pal["Info_DatabaseRemoved"] ) do
if V == ID then pal["Info_DatabaseRemoved"][K] = nil end
      end
   end
end

function pal:ReturnInfo( SearchFor, SearchForPrior, EmotionChange, EmotionAppend, Annoyable, Importance, Responces, SubInfo, Append, ID ) --format like so {"word","word","word"}, {"word","from","the","prior","text","responded","to"}, {0.15,0.001}, true, 1, {"hi","bye","gay"}, {ReturnInfo( DATA ),ReturnInfo( DATA )}, "code_for_editing_info", "Appends_to_all_Responces"
if pal:RunSelfHooks( "PALOnReturnInfo", {SearchFor,SearchForPrior,EmotionChange,Annoyable,Importance,Responces,SubInfo,ID,Append} ) == false then return end
return {["SearchFor"]=SearchFor,["PriorSearchFor"]=SearchForPrior,["EmotionChange"]=EmotionChange,["AppendEmotionStatment"]=EmotionAppend,["Annoyable"]=Annoyable,["Importance"]=Importance,["Responces"]=Responces,["SubInfo"]=SubInfo,["AppendAllResponcesWith"]=Append,["ID"]=ID,}
end

function pal:RemoveInfo( ID ) -- removes info by id
if pal:RunSelfHooks( "PALOnRemoveInfo", ID ) == false then return end
if InRunTime == true then pal["Info_DatabaseRemoved"][#pal["Info_DatabaseRemoved"] +1] = ID end
for K, V in pairs( pal["Info_Database"] ) do
if ID == V["ID"] then pal["Info_Database"][K] = nil end
end
   
for K, V in pairs( pal["Info_DatabaseAdded"] ) do
if ID == V["ID"] then pal["Info_DatabaseAdded"][K] = nil end
   end   
end

function pal:RemoveAllInfo() --removes all the info and all memory of it ever exsisting
if pal:RunSelfHooks( "PALOnRemoveAllInfo", {} ) == false then return end
	pal["Info_Database"] = nil
	pal["Info_DatabaseAdded"] = nil
	pal["Info_DatabaseRemoved"] = nil
	pal["Info_DatabaseRemoved"] = {}
	pal["Info_DatabaseAdded"] = {}
	pal["Info_Database"] = {}
end

function pal:GetInfoByIndex( Index ) --finds info by the index which repasents its placement it the database
	local ResultIn = pal["Info_Database"][Index]
	local ResultOut = {}
if ResultIn == nil then return {} end
for K, V in pairs( ResultIn ) do ResultOut[K] = V end --to keep the noraml info table safe from changes to the retuned info
return ResultOut
end

function pal:GetInfoById( ID ) --finds info by id
	local Results = {}
for K, V in pairs( pal["Info_Database"] ) do
if V["ID"] == ID then
	local ResultOut = {}
for L, W in pairs( V ) do ResultOut[L] = W end
	Results[#Results +1] = ResultOut
   end
end
return Results
end

function pal:GetInfoIndexById( ID ) --finds info indexs by id
	local Results = {}
for K, V in pairs( pal["Info_Database"] ) do
if V["ID"] == ID then
	Results[#Results +1] = K --K should be index
   end
end
return Results
end

function pal:AddNewTagGroup( ID, Collection ) --a collection of tags which if refrenced like so @TAG_ID, in the search for sections of added info will be replaced with collection
if pal:RunSelfHooks( "PALOnAddNewTagGroup", {ID,Collection} ) == false then return end
	pal["Tag_Groups"][ID] = Collection
end

function pal:RemoveTagGroup( ID ) --remove tag group
if pal:RunSelfHooks( "PALOnRemoveTagGroup", {ID} ) == false then return end
	pal["Tag_Groups"][ID] = nil
end

function pal:AddNewSpellChecking( Correct, IncorrectTbl ) --spellchecker
if pal:RunSelfHooks( "PALOnAddNewSpellChecking", {Correct,IncorrectTbl} ) == false then return end
	pal["Spellchecking"][#pal["Spellchecking"] +1] = {["CorrectWord"]=Correct,["IncorrectWords"]=IncorrectTbl}
end

function pal:RemoveSpellChecking( Correct ) --spellchecker
if pal:RunSelfHooks( "PALOnRemoveSpellChecking", {Correct} ) == false then return end
for K, V in pairs( pal["Spellchecking"] ) do if V["CorrectWord"] == Correct then pal["Spellchecking"][K] = nil end end
end

function pal:AddNewSynonymsGroup( ID, SynonymTbl ) --for grouping synonyms togethed so that one could be select via the id
if pal:RunSelfHooks( "PALOnSetNewSynonymsGroup", {ID,SynonymTbl} ) == false then return end
	pal["Synonyms_Groups"][ID] = SynonymTbl
end

function pal:RemoveSynonymsGroup( ID ) --spellchecker
if pal:RunSelfHooks( "PALOnRemoveSynonymsGroup", {ID} ) == false then return end
	pal["Synonyms_Groups"][ID] = nil
end

function pal:GetSynonymsWord( ID ) --gets a synonym from a synonym id
if pal["Synonyms_Groups"][ID] == nil then return "" end
return pal["Synonyms_Groups"][ID][math.random( 1, #pal["Synonyms_Groups"][ID] )]
end

function pal:BuildEmotionGrid( Size ) --sets the play field used for emotion simulation
if pal:RunSelfHooks( "PALOnBuildEmotionGrid", {Size} ) == false then return end
	pal["Emotion_GridMaxSize"] = Size
for X = 1, Size do
for Y = 1, Size do
	pal["Emotion_Grid"][X] = {}
	pal["Emotion_Grid"][X][Y] = {}
      end
   end 
end

function pal:AddNewEmotion( GridLocation, EmotiveWords, WordsThatMakeTheAIFeelMoreLikeThis, Emotionclass, sentanceAppending ) --for when the ai dose not have a responce
if pal:RunSelfHooks( "PALOnAddNewEmotion", {GridLocation,EmotiveWords,WordsThatMakeTheAIFeelMoreLikeThis,Emotionclass,SentanceAppending} ) == false then return end
	pal["Emotion_Grid"][GridLocation[1]][GridLocation[2]] = {["Words"]=EmotiveWords,["WTMIFMLT"]=WordsThatMakeTheAIFeelMoreLikeThis,["EmotionClass"]=Emotionclass,["SentanceAppending"]=sentanceAppending,}
end

function pal:EmotionLevelEquals( EmotionTbl ) --can be used in Responces to determin if this responce could or should have a chance of selection
return ( EmotionTbl[1] == math.floor( pal["Emotion_Level"][1] +0.50 ) and EmotionTbl[2] == math.floor( pal["Emotion_Level"][2] +0.50 ) )
end

function pal:EmotionLevelNotEquals( EmotionTbl ) 
return ( EmotionTbl[1] ~= math.floor( pal["Emotion_Level"][1] +0.50 ) or EmotionTbl[2] ~= math.floor( pal["Emotion_Level"][2] +0.50 ) )
end

function pal:EmotionLevelEqualsOr( ... ) --give it a bunch of emotion points and if the emotion level = one of them it will return true
	local OrTable = {...}
	local ReturnState = false
for Z = 1, #OrTable do if pal:EmotionLevelEquals( OrTable[Z] ) == true then ReturnState = true end end
return ReturnState
end

function pal:EmotionLevelNotEqualsOr( ... ) --if the emotion level ~= any of the emotion points, it will return true
	local OrTable = {...}
	local ReturnState = true
for Z = 1, #OrTable do if pal:EmotionLevelEquals( OrTable[Z] ) == true then ReturnState = false end end
return ReturnState
end

function pal:GetEmotiveWord() --words that describe what it thinks of the user
if pal["Emotion_Grid"][math.floor( 0.50 +pal["Emotion_Level"][1] )][math.floor( 0.50 +pal["Emotion_Level"][2] )] == nil then return "" end
if pal["Emotion_Grid"][math.floor( 0.50 +pal["Emotion_Level"][1] )][math.floor( 0.50 +pal["Emotion_Level"][2] )]["Words"] == nil then return "" end
return pal["Emotion_Grid"][math.floor( 0.50 +pal["Emotion_Level"][1] )][math.floor( 0.50 +pal["Emotion_Level"][2] )]["Words"][math.random( 1, #pal["Emotion_Grid"][math.floor( 0.50 +pal["Emotion_Level"][1] )][math.floor( 0.50 +pal["Emotion_Level"][2] )]["Words"] )]
end

function pal:GetEmotiveClass() --words that describe how it is feeling in genral
if pal["Emotion_Grid"][math.floor( 0.50 +pal["Emotion_Level"][1] )][math.floor( 0.50 +pal["Emotion_Level"][2] )] == nil then return "" end
if pal["Emotion_Grid"][math.floor( 0.50 +pal["Emotion_Level"][1] )][math.floor( 0.50 +pal["Emotion_Level"][2] )]["EmotionClass"] == nil then return "" end
return pal["Emotion_Grid"][math.floor( 0.50 +pal["Emotion_Level"][1] )][math.floor( 0.50 +pal["Emotion_Level"][2] )]["EmotionClass"][math.random( 1, #pal["Emotion_Grid"][math.floor( 0.50 +pal["Emotion_Level"][1] )][math.floor( 0.50 +pal["Emotion_Level"][2] )]["EmotionClass"] )]
end

function pal:GetEmotiveEnd() --an emotive ending to a sentence
if pal["Emotion_Grid"][math.floor( 0.50 +pal["Emotion_Level"][1] )][math.floor( 0.50 +pal["Emotion_Level"][2] )] == nil then return "" end
if pal["Emotion_Grid"][math.floor( 0.50 +pal["Emotion_Level"][1] )][math.floor( 0.50 +pal["Emotion_Level"][2] )]["SentanceAppending"] == nil then return "" end
return pal["Emotion_Grid"][math.floor( 0.50 +pal["Emotion_Level"][1] )][math.floor( 0.50 +pal["Emotion_Level"][2] )]["SentanceAppending"][math.random( 1, #pal["Emotion_Grid"][math.floor( 0.50 +pal["Emotion_Level"][1] )][math.floor( 0.50 +pal["Emotion_Level"][2] )]["SentanceAppending"] )]
end

function pal:SetEmotiiveGravity( Point, GravityAmount ) --sets its main emotion
if pal:RunSelfHooks( "PALOnSetEmotiiveGravity", {Point,GravityAmount} ) == false then return end
	pal["Emotion_Level"] = Point
	pal["Emotion_LevelWanted"], pal["Emotion_GravatatePower"] = point, GravityAmount
end

function pal:GetEmotiiveGravity()
return pal["Emotion_LevelWanted"], pal["Emotion_GravatatePower"]
end

function pal:SetEmotiveWordPower( Num ) --sets how strong it reacts to words like sware words
if pal:RunSelfHooks( "PALOnSetEmotiveWordPower", {Num} ) == false then return end
	pal["Emotion_Sensitivity"] = Num
end

function pal:GetEmotiveWordPower()
return pal["Emotion_Sensitivity"]
end

function pal:AddNewIDKResponce( Responce ) --for when the ai dose not have a responce
	pal["IDK_Responces"][#pal["IDK_Responces"] +1] = Responce
end

function pal:AddNewIDKTailoredResponce( TalioredTag, Responce ) --for when the ai dose not have a responce
if pal["IDK_TailoredResponces"][TalioredTag] == nil then pal["IDK_TailoredResponces"][TalioredTag] = {} end
	pal["IDK_TailoredResponces"][TalioredTag][(#pal["IDK_TailoredResponces"][TalioredTag]) +1] = Responce
end

function pal:GetIDKResponce( TalioredTag )
if #pal["IDK_Responces"] <= 0 then return "ERROR: AI TRIED TO MAKE AN IDK RESPONCE BUT HAS NO IDK DATA" end
return pal["IDK_Responces"][math.random( 1, #pal["IDK_Responces"] )]
end

function pal:GetIDKTailoredResponce( TalioredTag )
if #pal["IDK_Responces"] <= 0 then return "ERROR: AI TRIED TO MAKE AN IDK RESPONCE BUT HAS NO IDK DATA" end
return pal["IDK_TailoredResponces"][TalioredTag][math.random( 1, #pal["IDK_TailoredResponces"][TalioredTag] )]
end

function pal:SetMaxAnnoyanceAmount( Num )
	pal["Annoyance_MaxLevel"] = Num
end

function pal:GetMaxAnnoyanceAmount()
return pal["Annoyance_MaxLevel"]
end

function pal:SetNewAnnoyanceRespoces( Level, Responce ) --for if you ask the same question to many times
if pal:RunSelfHooks( "PALOnSetNewAnnoyanceRespoces", {level,Responce} ) == false then return end
if Level == 1 then pal["Annoyance_ResponcesAttachment"][#pal["Annoyance_ResponcesAttachment"] +1] = Responce end --at level 1 it will still awnser questions and stuff but it will tell you this is getting annoying
if Level == 2 then pal["Annoyance_Responces"][#pal["Annoyance_Responces"] +1] = Responce end --at level 2 it will refuse to awnser questions
end

function pal:GetAnnoyanceRespoce( Level ) --for if you ask the same question to many times
if #pal["Annoyance_ResponcesAttachment"] <= 0 then return "ERROR: AI TRIED TO Append ANOYANCE BUT THERE IS NO ANNOYANCE DATA" end
if #pal["Annoyance_Responces"] <= 0 then return "ERROR: AI TRIED TO MAKE AN ANNOYED RESPONCE BUT HAS NO ANNOYED RESPONCE DATA" end
if Level == 1 then return pal["Annoyance_ResponcesAttachment"][math.random( 1, #pal["Annoyance_ResponcesAttachment"] )] end
if Level == 2 then return pal["Annoyance_Responces"][math.random( 1, #pal["Annoyance_Responces"] )] end
end

function pal:GetAnnoyanceLevel( InputIndex ) --for if you ask the same question to many times
	local AnnoyedLevel = pal["Annoyance_ResponceCounter"][InputIndex] or 0 --how many times as the same question been asked
if AnnoyedLevel >= 1 then
if AnnoyedLevel >= pal["Annoyance_MaxLevel"] then
   return 2 --to much repeat asking
else
   return 1 --some repeat asking
   end
else
   return 0 --no repeat asking
   end
end

function pal:SetPriorInput( Text ) --sets the previous thing the player said
if pal:RunSelfHooks( "PALOnSetPriorInput", {Text} ) == false then return end
	pal["PriorEnteredInput"] = Text
end

function pal:GetPriorInput() --the previous thing the player said
return pal["PriorEnteredInput"]
end

pal:BuildEmotionGrid( pal["Emotion_GridMaxSize"] )

-- end of data/info control functions and start of AI loop ---------------------------------------------------------------------------------------------------

function pal:EmotionGravatate() --allows for emotion to go back to normal levels
	local X = pal["Emotion_LevelWanted"][1] -pal["Emotion_Level"][1]
	local Y = pal["Emotion_LevelWanted"][2] -pal["Emotion_Level"][2]
if X ~= 0 then X = ( X /( math.abs( X ) +math.abs( Y ) ) ) *pal["Emotion_GravatatePower"] end
if Y ~= 0 then Y = ( Y /( math.abs( X ) +math.abs( Y ) ) ) *pal["Emotion_GravatatePower"] end
    pal["Emotion_Level"][1] = pal["Emotion_Level"][1] +X
	pal["Emotion_Level"][2] = pal["Emotion_Level"][2] +Y
	pal["Emotion_Level"][1] = math.min( math.max( 1, pal["Emotion_Level"][1] ), pal["Emotion_GridMaxSize"] ) --remove here to remove emotion change
	pal["Emotion_Level"][2] = math.min( math.max( 1, pal["Emotion_Level"][2] ), pal["Emotion_GridMaxSize"] )
end

function pal:AnnoyanceDecreese() --allows for annoyence to war off over time
if pal["Annoyance_DecreeseTime"] == nil then pal["Annoyance_DecreeseTime"] = pal["Annoyance_DecreeseIn"] end
	pal["Annoyance_DecreeseTime"] = pal["Annoyance_DecreeseTime"] -1
if pal["Annoyance_DecreeseTime"] <= 0 then
	pal["Annoyance_DecreeseTime"] = nil
for K, V in pairs( pal["Annoyance_ResponceCounter"] ) do
	pal["Annoyance_ResponceCounter"][K] = pal["Annoyance_ResponceCounter"][K] -1
if V <= 0 then pal["Annoyance_ResponceCounter"][K] = nil end
      end
   end
end

function pal:MemGenDecreese() --forgets which pronowns gose to who
if pal["GenderMemoryTime"] == nil then return end
	pal["GenderMemoryTime"] = pal["GenderMemoryTime"] -1

if pal["GenderMemoryTime"] <= 0 then
	pal["GenderMemoryTime"] = nil
for K, V in pairs( pal["GenderMemory"] ) do
pal:RemoveSpellChecking( V )
     end
   end
end

function pal:DegradeInfo() --dose the actually info degradeing
for K, V in pairs( pal["Info_DegradeLevel"] ) do
	pal["Info_DegradeLevel"][K] = pal["Info_DegradeLevel"][K] -1
if pal["Info_DegradeLevel"][K] <= 0 then
	pal["Info_DatabaseRemoved"][#pal["Info_DatabaseRemoved"] +1] = pal["Info_Database"][K]["ID"]
	pal["Info_Database"][K], pal["Info_DegradeLevel"][K] = nil, nil
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
if pal["LoopSimLastRunTime"] == nil then pal["LoopSimLastRunTime"] = os.time() end
	local SimLength = os.time() -pal["LoopSimLastRunTime"]
	pal["LoopSimLastRunTime"] = os.time()	
for Z = 1, SimLength do pal:Loop() end
end

function pal:RunSpellCheck( Input ) --fixes spelling issues in what theplayer says so it is easyer to find the best responce to what the player says
if pal:RunSelfHooks( "PALOnRunSpellCheck", {Input} ) == false then return end
	local CorrectedReturnText = ( string.gsub( Input, ".", {["("]="%(",[")"]="%)",["."]="%.",["%"]="%%",["+"]="%+",["-"]="%-",["*"]="%*",["?"]="%?",["["]="%[",["]"]="%]",["^"]="%^",["$"]="%$",["\0"]="%Z"} ) )
	local Nul = 0
for K, V in pairs( pal["Spellchecking"] ) do
for Z = 1, #V["IncorrectWords"] do
	CorrectedReturnText, Nul = string.gsub( CorrectedReturnText, " "..V["IncorrectWords"][Z].." ", " "..V["CorrectWord"].." " )
if Input == " "..V["IncorrectWords"][Z].." " then CorrectedReturnText = " "..V["CorrectWord"].." " end
   end
end
return CorrectedReturnText
end

--remove function below to get rid of emotion change
function pal:RunAjustEmotionToEmotiveKeyWords( Input ) --allows for to AI to feel hurt by the manner of which the player speeks
if pal:RunSelfHooks( "PALOnRunAjustEmotionToEmotiveKeyWords", {Input} ) == false then return end
	local XY = {0,0}

for X = 1, pal["Emotion_GridMaxSize"] do
for Y = 1, pal["Emotion_GridMaxSize"] do
if pal["Emotion_Grid"][X] ~= nil and pal["Emotion_Grid"][X][Y] ~= nil and pal["Emotion_Grid"][X][Y]["Words"] ~= nil then
for Z = 1, #pal["Emotion_Grid"][X][Y]["Words"] do
if string.find( Input, pal["Emotion_Grid"][X][Y]["Words"][Z], 1, true ) ~= nil then
	XY[1] = X
	XY[2] = Y
      end
   end
end

if pal["Emotion_Grid"][X] ~= nil and pal["Emotion_Grid"][X][Y] ~= nil and pal["Emotion_Grid"][X][Y]["WTMIFMLT"] ~= nil then
for Z = 1, #pal["Emotion_Grid"][X][Y]["WTMIFMLT"] do
if string.find( Input, pal["Emotion_Grid"][X][Y]["WTMIFMLT"][Z], 1, true ) ~= nil then
	XY[1] = X
	XY[2] = Y
            end
         end
      end
   end
end

if XY[1] ~= 0 then XY[1] = XY[1] /( math.abs( XY[1] ) +math.abs( XY[2] ) ) end
if XY[2] ~= 0 then XY[2] = XY[2] /( math.abs( XY[1] ) +math.abs( XY[2] ) ) end

	pal["Emotion_Level"][1]	= pal["Emotion_Level"][1] +( XY[1] *pal["Emotion_Sensitivity"] )
	pal["Emotion_Level"][2] = pal["Emotion_Level"][2] +( XY[2] *pal["Emotion_Sensitivity"] )
	pal["Emotion_Level"][1] = math.min( math.max( 1, pal["Emotion_Level"][1] ), pal["Emotion_GridMaxSize"] )
	pal["Emotion_Level"][2] = math.min( math.max( 1, pal["Emotion_Level"][2] ), pal["Emotion_GridMaxSize"] )
if pal:RunSelfHooks( "PALRunAjustEmotionToEmotiveKeyWordsNewEmotion", {Input,{math.floor( 0.50 +pal["Emotion_Level"][1] ),math.floor( 0.50 +pal["Emotion_Level"][2] )}} ) == false then return end
end

function pal:RunFindResponce( Input )
if pal:RunSelfHooks( "PALOnRunFindResponce", {Input} ) == false then return end

	pal["CurrentResponceImportance"] = -999
	pal["MatchLevelTagsProcessedOld"] = -999
	local CurrentResponceIndex = -1

if pal["Info_Database"] ~= nil then
for K, V in pairs( pal["Info_Database"] ) do --pulls thougth all infomation in pal's info_database for it to be compare aginst

	local SearchIn = V["SearchFor"]
	local SearchInPrior = V["PriorSearchFor"]
	local Importance = V["Importance"] or 0

	pal["MatchLevelTagsProcessed"] = 0 --this data needs to not be lost in order for compareing results to add up

if SearchIn ~= nil and next( SearchIn ) ~= nil then --checks to see if the text the player entered shares enougth words with the current infomation being searched thougth
	pal["MatchLevelLengthProcessed"] = 0 --this data needs to be lost for all compareing oparations
	pal["FoundTagAt"] = 0 --this data can not be lost unitll all input/level 1 compareing is complete but it dose need to be lost at the start 
for L, W in pairs( SearchIn ) do
	pal["found_tag"] = false --this data need to be lost per tag check or it could cause isssues
	local Tag = W
if string.sub( Tag, 1, 1 ) == pal["RunFunctionKey"] and string.sub( Tag, string.len( Tag ), string.len( Tag ) ) == pal["RunFunctionKey"] then --is tag in a function string if so run it
	local Run, Error = load( "return "..string.sub( Tag, 2, string.len( Tag ) -1 ) ) -- runs function
	local FoundTag, FoundTagAt = Run()
	pal["found_tag"] = ( FoundTag == true ) --did function say it found tag
	pal["FoundTagAt"] = ( FoundTagAt or pal["FoundTagAt"] ) --did function say where to start searching for the next tag
else
if string.find( Input, " "..Tag.." ", pal["FoundTagAt"], true ) ~= nil then  --if tag is not a function find it in player input as plain text
	pal["found_tag"] = true --tag was found
	pal["FoundTagAt"] = pal["FoundTagAt"] +string.len( Tag ) --where to start the search for the next one
   end
end

if pal["found_tag"] == true then 
if pal["FoundTagAt"] >= pal["MatchLevelLengthProcessed"] then
	pal["MatchLevelLengthProcessed"] = pal["FoundTagAt"]  --if length processed <= 0 then current search will be disguarded and it also hels as an extra means to compare data
	pal["MatchLevelTagsProcessed"] = pal["MatchLevelTagsProcessed"] +1 --tag found
else
	pal["FoundTagAt"] = -99999999 --basiclly disguards current search if found tag at < length processed
	pal["MatchLevelLengthProcessed"] = -99999999 --basiclly disguards current search if found tag at < length processed
end
else
	pal["FoundTagAt"] = -99999999 --basiclly disguards current search if found tag == false
	pal["MatchLevelLengthProcessed"] = -99999999 --basiclly disguards current search if found tag == false
      end
   end
end

if pal["FoundTagAt"] >= 0 and pal["MatchLevelLengthProcessed"] >= 0 and pal["MatchLevelTagsProcessed"] >= 0 then --to pervent prior search if first search already failed as if we dont do this it could result in broken returns
if SearchInPrior ~= nil and next( SearchInPrior ) ~= nil then --checks to see if the text the player entered previously shares enougth words with the current infomation being searched thougth
	pal["MatchLevelLengthProcessed"] = 0
	pal["FoundTagAt"] = 0
for L, W in pairs( SearchInPrior ) do
	pal["found_tag"] = false
	local Tag = W
if string.sub( Tag, 1, 1 ) == pal["RunFunctionKey"] and string.sub( Tag, string.len( Tag ), string.len( Tag ) ) == pal["RunFunctionKey"] then
	local Run, Error = load( "return "..string.sub( Tag, 2, string.len( Tag ) -1 ) ) -- runs function
	local FoundTag, FoundTagAt = Run()
	pal["found_tag"] = ( FoundTag == true )
	pal["FoundTagAt"] = ( FoundTagAt or pal["FoundTagAt"] )
else
if string.find( pal["PriorEnteredInput"], " "..Tag.." ", pal["FoundTagAt"], true ) ~= nil then  --if tag is not a function find it in player input as plain text
	pal["found_tag"] = true
	pal["FoundTagAt"] = pal["FoundTagAt"] +string.len( Tag )
   end
end

if pal["found_tag"] == true then 
if pal["FoundTagAt"] >= pal["MatchLevelLengthProcessed"] then
	pal["MatchLevelLengthProcessed"] = pal["FoundTagAt"]
	pal["MatchLevelTagsProcessed"] = pal["MatchLevelTagsProcessed"] +1
else
	pal["FoundTagAt"] = -99999999
	pal["MatchLevelLengthProcessed"] = -99999999
end
else
	pal["FoundTagAt"] = -99999999
	pal["MatchLevelLengthProcessed"] = -99999999
         end
      end
   end
end

if pal["MatchLevelLengthProcessed"] >= 1 then --checks acceptablity
if pal["MatchLevelTagsProcessed"] >= pal["MatchLevelTagsProcessedOld"] then --checks acceptablity
if Importance >= pal["CurrentResponceImportance"] then --checks acceptablity

	pal["MatchLevelTagsProcessedOld"] = pal["MatchLevelTagsProcessed"] --updates minmal acceptablity level
	pal["CurrentResponceImportance"] = Importance --updates minmal acceptablity level
	CurrentResponceIndex = K

            end
         end
      end
   end
end

if CurrentResponceIndex ~= -1 then
if pal:RunSelfHooks( "PALOnRunFindResponceFound", {CurrentResponceIndex} ) == false then return end
	return CurrentResponceIndex
   end
end

function pal:RunBestIDKResponce( Input )
if pal:RunSelfHooks( "PALOnRunBestIDKResponce", {Input} ) == false then return end

	local FoundTailoredTagAt = 999999
	local TheFoundTag = "nil"
	
for K, V in pairs( pal["IDK_TailoredResponces"] ) do
 local Starts, Ends = string.find( Input, " "..V.." ", 1, true )
if Starts ~= nil and Starts <= FoundTailoredTagAt then
	FoundTailoredTagAt = Starts
	TheFoundTag = V
   end
end

if TheFoundTag ~= "nil" and FoundTaliredTagAt <= pal["IDK_FailTailoredTagIfOver"] then 
return pal:GetIDKTailoredResponce( k )
else
return pal:GetIDKResponce()
   end
end

function pal:RunAnnoyanceTest( InputIndex, Input ) --simulate annoyance
	local AnnoyedLevel = pal["Annoyance_ResponceCounter"][InputIndex] or 0
if pal:RunSelfHooks( "PALOnRunAnnoyanceTest", {InputIndex, Input, AnnoyedLevel} ) == false then return end

	pal["Annoyance_ResponceCounter"][InputIndex] = math.min( AnnoyedLevel +1, pal["Annoyance_MaxLevel"] )

if AnnoyedLevel >= 1 then
	pal["Emotion_Level"][1] = pal["Emotion_Level"][1] +pal["Annoyance_EffectEmotionBy"][1]
	pal["Emotion_Level"][2] = pal["Emotion_Level"][2] +pal["Annoyance_EffectEmotionBy"][2]
	pal["Emotion_Level"][1] = math.min( math.max( 1, pal["Emotion_Level"][1] ), pal["Emotion_GridMaxSize"] ) --remove here to remove emotion change
	pal["Emotion_Level"][2] = math.min( math.max( 1, pal["Emotion_Level"][2] ), pal["Emotion_GridMaxSize"] )

if AnnoyedLevel >= pal["Annoyance_MaxLevel"] then
	return pal:GetAnnoyanceRespoce( 2 )
else
   return Input.." "..pal:GetAnnoyanceRespoce( 1 )
end
else
   return Input
   end
end

function pal:RunLuaCodeInResponce( Input ) --exacutes any lua code in a responce from the responce section of infomation 
if Input == nil then return end
if pal:RunSelfHooks( "PALOnRunLuaCodeInResponce", {Input} ) == false then return end

	local OutString = Input
	local StringDiffreance = 0
	local CodeStart = 0
	local CodeEnd = 0

for Z = 1, string.len( Input ) do
if string.sub( Input, Z, Z ) == pal["RunFunctionKey"] then
if CodeStart == 0 then CodeStart = Z else CodeEnd = Z end
if CodeStart ~= 0 and CodeEnd ~= 0 then
  
	local exe, null = load( "return "..string.sub( Input, CodeStart +1, CodeEnd -1 ) )
	local result = exe()  
  
if result ~= nil then
	OutString = string.sub( OutString, 1, CodeStart -1 +StringDiffreance )..tostring( result )..string.sub( OutString, CodeEnd +1 +StringDiffreance, string.len( OutString ) )
	StringDiffreance = string.len( OutString ) -string.len( Input )	
else
	OutString = string.sub( OutString, 1, CodeStart -1 +StringDiffreance )..string.sub( OutString, CodeEnd +1 +StringDiffreance, string.len( OutString ) )
	StringDiffreance = string.len( OutString ) -string.len( Input )	
end
	CodeStart, CodeEnd = 0, 0
      end  
   end 
end

if pal:RunSelfHooks( "PALOnRunLuaCodeInResponceChange", {Input,OutString} ) == false then return end
return OutString
end

function pal:BuildResponceTo( Input ) --USE THIS TO GET THE AI TO MAKE A RESPONCE TO THE INPUT
function pal:BRTGetTextToRespondToOrignal() return Input end --added just encase someone wants the orignal text the player types
	local Master = pal:RunSpellCheck( string.lower( " "..Input.." " ) ) --stage one: spellchecking
function pal:BRTGetTextToRespondTo() return Master end --spell checking is done before this so that functions like the NRT do not have to continusely do spellchecking
	
	local A, B = pal:RunSelfHooks( "PALOnBuildResponceTo", {Master} )
if A == false then return B end

pal:RunLoopSimulation() --stage two: this makes it so that the loop runs every second kinda
pal:RunAjustEmotionToEmotiveKeyWords( Master ) --stage three: remove here to remove emotion change

	local OutputIndex = pal:RunFindResponce( Master ) --stage four: find a suitable set responce
	local OutputData = pal:GetInfoByIndex( OutputIndex ) --stage four: fetch set responce

function pal:BRTGetInfoIndex() return OutputIndex end

if OutputIndex == nil then --if no responce could be found to what the user says run this code
	local A, B = pal:RunSelfHooks( "PALOnIDKoutput", {Master} )
if A == false then return B end
return pal:RunBestIDKResponce( Master ) 
end

	local OutputResponce = "" --stage five: pick a responce out of the set
	local EmotiveEnding = pal:GetEmotiveEnd()
	
if OutputData["Responces"] ~= nil then OutputResponce = OutputData["Responces"][math.random( 1, #OutputData["Responces"] )] end
if OutputData["AppendEmotionStatment"] ~= false and EmotiveEnding ~= "" and EmotiveEnding ~= nil then OutputResponce = OutputResponce.." "..EmotiveEnding end --stage six: Appending of responce section --emotion Appending
if OutputData["Annoyable"] ~= false then OutputResponce = pal:RunAnnoyanceTest( OutputIndex, OutputResponce ) end --stage six: annoyence Appending
if pal:GetAnnoyanceLevel( OutputIndex ) == 2 then --stage six: end function if to annoyed Appending
	local str = pal:RunSelfHooks( "PALOnMaxAnnoyanceoutput", {Input} )
if str ~= nil and str ~= false then return str end
return OutputResponce
end
	OutputResponce = OutputResponce..( OutputData["AppendAllResponcesWith"] or "" ) --stage six

if OutputData["EmotionChange"] ~= nil then --stage seven: remove here to remove emotion change
	pal["Emotion_Level"][1] = pal["Emotion_Level"][1] +OutputData["EmotionChange"][1]  --stage seven: remove here to remove emotion change
	pal["Emotion_Level"][2] = pal["Emotion_Level"][2] +OutputData["EmotionChange"][2]  --stage seven: remove here to remove emotion change
	pal["Emotion_Level"][1] = math.min( math.max( 1, pal["Emotion_Level"][1] ), pal["Emotion_GridMaxSize"] ) --stage seven: remove here to remove emotion change
	pal["Emotion_Level"][2] = math.min( math.max( 1, pal["Emotion_Level"][2] ), pal["Emotion_GridMaxSize"] ) --stage seven: remove here to remove emotion change
end --stage seven: remove here to remove emotion change

	pal["PriorEnteredInput"] = master --stage eight: alllows us to search througth what the player said before what there currently saying 
	OutputResponce = pal:RunLuaCodeInResponce( OutputResponce )
	
if OutputData["SubInfo"] ~= nil then --stage nine: add sub Responces this was move to after to make it easy to replace id'ed Responces
for Z = 1, #OutputData["SubInfo"] do
if OutputData["SubInfo"][Z] ~= nil then 
pal:SetNewInfoTbl( OutputData["SubInfo"][Z], ( pal["Info_Database"][OutputIndex]["SubInfoadded"] == true ) )
   end
end
	pal["Info_Database"][OutputIndex]["SubInfoadded"] = true --stage nine: ensure that the save system only logs the responce being added once
end

local A, B = pal:RunSelfHooks( "PALOnGotResponce", {master} )
if A == false then return B end

return OutputResponce
end

pal:RunLoopSimulation()

-- end of main ai loop and start of loading external data ----------------------------------------------------------------------------------------------------

function pal:SetInRunTime( IRT ) --just encase you want to turn it off to load content without the save system taking note
	InRunTime = IRT
end

function pal:GetInRunTime() --just encase you want to turn it off to load content without the save system taking note
return InRunTime
end

function pal:SaveInfo() --saves all info added to AI after intal loading
if pal:RunSelfHooks( "PALOnSaveInfo", {} ) == false then return end

	local FileData = "" --start of saveing to file

for K, V in pairs( pal["Info_DatabaseAdded"] ) do
	local Responces = ""
	local SearchFor = ""
	local SearchForPrior = ""

if V["SearchFor"] ~= nil then
for Y = 1, #V["SearchFor"] do --reformats search data so thay can be saved with ease
if SearchFor == "" then
	SearchFor = SearchFor.."'"..V["SearchFor"][Y].."'"
else
	SearchFor = SearchFor..",".."'"..V["SearchFor"][Y].."'"
      end
   end
end

if V["PriorSearchFor"] ~= nil then
for Y = 1, #V["PriorSearchFor"] do --reformats prior search data so thay can be saved with ease
if SearchForPrior == "" then
	SearchForPrior = SearchForPrior.."'"..V["PriorSearchFor"][Y].."'"
else
	SearchForPrior = SearchForPrior..",".."'"..V["PriorSearchFor"][Y].."'"
      end
   end
end

if V["Responces"] ~= nil then
for Y = 1, #V["Responces"] do --reformats Responces so thay can be saved with ease
if Responces == "" then
Responces = Responces.."'"..V["Responces"][Y].."'"
else
Responces = Responces..",".."'"..V["Responces"][Y].."'"
      end
   end
end

if V["EmotionChange"] == nil then V["EmotionChange"] = {0,0} end --pervents saveing issues

	local currentline = "pal:SetNewInfo( {"..tostring( SearchFor ).."}, {"..tostring( SearchForPrior ).."}, {"..tostring( V["EmotionChange"][1] )..","..tostring( V["EmotionChange"][2] ).."}, "..tostring( V["Annoyable"] )..", "..tostring( V["Importance"] )..", {"..tostring( Responces ).."}, nil, "..tostring( V["AppendAllResponcesWith"] )..", "..tostring( V["ID"] ).." )"
if FileData == "" then --responce saveing
FileData = FileData..currentline
else
FileData = FileData..string.char( 10 )..currentline
   end
end

for K, V in pairs( pal["Info_DatabaseRemoved"] ) do
	local currentdata = "pal:RemoveInfo( "..V.." )"
if FileData == "" then
FileData = FileData..currentdata
else
FileData = FileData..string.char( 10 )..currentdata
   end
end

	local IsAlreadyAddedCheck = {}
for K, V in pairs( pal["Info_DegradeLevel"] ) do
	local currentdata = "pal:DegradeInfoOverXCyclesByIndex( "..tostring( pal["Info_Database"][K]["ID"] )..","..tostring( V ).." )"
if pal["Info_Database"][K] ~= nil and pal["Info_Database"][K]["ID"] ~= nil and IsAlreadyAddedCheck[pal["Info_Database"][K]["ID"]] ~= true then
	IsAlreadyAddedCheck[pal["Info_Database"][K]["ID"]] = true
if FileData == "" then
FileData = FileData..currentdata
else
FileData = FileData..string.char( 10 )..currentdata
      end
   end
end

io.output( "main_save.dat" ) --we are doing files this way because the other way just kept giving me grife
io.write( FileData )
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

for K, V in pairs( pal ) do
if K ~= "last_sim_time" then
	PAL_RESTORE_TABLE[K] = V
      end
   end
end

function pal:LoadRestorePoint() --loades restore point
if pal:RunSelfHooks( "PALOnLoadRestorePoint", {} ) == false then return end
if PAL_RESTORE_TABLE ~= nil then
	pal = nil
	pal = {}
for K, V in pairs( PAL_RESTORE_TABLE ) do
	pal[K] = V
      end
   end
end

-- end of loading external data start of everything ----------------------------------------------------------------------------------------------------------

dofile( CurrentDir.."/AI/loads.lua" )

	InRunTime = true
	
pal:LoadInfo()
pal:SetRestorePoint()

return pal
