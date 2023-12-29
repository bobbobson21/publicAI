	local sandbox = pal:SandBox() --by using the sandbox we can also send this content back to the last restore point as well if we need to

function sandbox:DoMaths() --this dose do math but it can also be used as a code injection point REMOVE IF USING FOR PUBLIC CONSUMTION
	local RespondToText = pal:BRTGetTextToRespondTo()
	local MathStart, MathEnd = 999999, 0
	
for z = 1, string.len( RespondToText ) do
	local FixText = string.sub( RespondToText, z, z +1 )
if FixText == "%+" then RespondToText = string.sub( RespondToText, 1, z -1 ).." +"..string.sub( RespondToText, z +2, string.len( RespondToText ) ) end --removes % which happens when you type special characters
if FixText == "%-" then RespondToText = string.sub( RespondToText, 1, z -1 ).." -"..string.sub( RespondToText, z +2, string.len( RespondToText ) ) end
if FixText == "%*" then RespondToText = string.sub( RespondToText, 1, z -1 ).." *"..string.sub( RespondToText, z +2, string.len( RespondToText ) ) end
if FixText == "%/" then RespondToText = string.sub( RespondToText, 1, z -1 ).." /"..string.sub( RespondToText, z +2, string.len( RespondToText ) ) end
if FixText == "%^" then RespondToText = string.sub( RespondToText, 1, z -1 ).." ^"..string.sub( RespondToText, z +2, string.len( RespondToText ) ) end
if FixText == "%<" then RespondToText = string.sub( RespondToText, 1, z -1 ).." <"..string.sub( RespondToText, z +2, string.len( RespondToText ) ) end
if FixText == "%>" then RespondToText = string.sub( RespondToText, 1, z -1 ).." >"..string.sub( RespondToText, z +2, string.len( RespondToText ) ) end
if FixText == "%=" then RespondToText = string.sub( RespondToText, 1, z -1 ).." ="..string.sub( RespondToText, z +2, string.len( RespondToText ) ) end	
	local SubText = string.sub( RespondToText, z, z ) --checks where the math starts and ends
if tonumber( SubText ) ~= nil then 
if z <= MathStart then MathStart = z end	
	MathEnd = z	
   end
end

if MathStart == 999999 or MathEnd == 0 then return "ERROR UNABLE TO DO MATHS" end --ISSUE FINDING MATHS DATA

	RespondToText = string.sub( RespondToText, MathStart, MathEnd ) --gets the maths
	local Run, Nul = load( "return "..RespondToText ) --runs the maths CAN ALSO RUN MECILOUS CODE SO ETHIER IMPROVE SECURITY OR REMOVE THIS FUNCTION BUT I WOULD DO THE SECOND ONE FOR SAFETY
	local Result = Run()  

return tostring( Result )
end

function sandbox:CheckMaths() --this checks math but it can also be used as a code injection point REMOVE IF USING FOR PUBLIC CONSUMTION
	local RespondToText = pal:BRTGetTextToRespondTo()
	local MathStart, MathEnd, MathEqual = 999999, 0, 0
	
for z = 1, string.len( RespondToText ) do
	local FixText = string.sub( RespondToText, z, z +1 )
if FixText == "%+" then RespondToText = string.sub( RespondToText, 1, z -1 ).." +"..string.sub( RespondToText, z +2, string.len( RespondToText ) ) end
if FixText == "%-" then RespondToText = string.sub( RespondToText, 1, z -1 ).." -"..string.sub( RespondToText, z +2, string.len( RespondToText ) ) end
if FixText == "%*" then RespondToText = string.sub( RespondToText, 1, z -1 ).." *"..string.sub( RespondToText, z +2, string.len( RespondToText ) ) end
if FixText == "%/" then RespondToText = string.sub( RespondToText, 1, z -1 ).." /"..string.sub( RespondToText, z +2, string.len( RespondToText ) ) end
if FixText == "%^" then RespondToText = string.sub( RespondToText, 1, z -1 ).." ^"..string.sub( RespondToText, z +2, string.len( RespondToText ) ) end
if FixText == "%<" then RespondToText = string.sub( RespondToText, 1, z -1 ).." <"..string.sub( RespondToText, z +2, string.len( RespondToText ) ) end
if FixText == "%>" then RespondToText = string.sub( RespondToText, 1, z -1 ).." >"..string.sub( RespondToText, z +2, string.len( RespondToText ) ) end
if FixText == "%=" then RespondToText = string.sub( RespondToText, 1, z -1 ).." ="..string.sub( RespondToText, z +2, string.len( RespondToText ) ) end	
	local SubText = string.sub( RespondToText, z, z )
if SubText == "=" then MathEqual = z end --the point MathEnd cant go path and the number past it is what we check the users math agienst
if tonumber( SubText ) ~= nil then 
if z <= MathStart then MathStart = z end	
if MathEqual == 0 then MathEnd = z end
   end
end

if MathStart == 999999 or MathEnd == 0 or MathEqual == 0 then return "ERROR UNABLE TO CHECK MATHS" end

	RespondToText = string.sub( RespondToText, MathStart, MathEnd )
	local Run, Nul = load( "return "..RespondToText )
	local Result = tostring( Run() )  

if Result == string.sub( RespondToText, MathEqual, string.len( RespondToText ) ) then
	local RandResponceTbl = {"Yes that is correct.","You are right.","Correct","That is right.","Yes that is correct user.","You are right user.","Correct user.","That is right user."}
return RandResponceTbl[math.random( 1, #RandResponceTbl )]
else
	local RandResponceTbl = {"No that is wrong.","You are wrong.","Wrong","That is wrong.","No that is wrong user.","You are wrong user.","Wrong user.","That is wrong user."}
	
pal:SetNewInfo( {"what","correct","answer",}, nil, {-0.70,0}, false, nil, nil, {"The correct answer is "..tostring( Result )..".","The correct answer was "..tostring( Result )..".","It is "..tostring( Result )..".","It was "..tostring( Result ).."."}, nil, nil, "MATH_AWNSER" )
pal:DegradeInfoOverXCycles( "MATH_AWNSER", 180 ) --this whay they dont ge the awnser unless they ask for it

return RandResponceTbl[math.random( 1, #RandResponceTbl )]
   end
end

function sandbox:SwareWordLearningPervention()
	local RespondToText = pal:BRTGetTextToRespondTo()
	local TheSwareWords = {"fuck","fucking","fucker","cunt","bitch","ass","ho","faggot","fag","retard"} --add words here you DONT want the AI to learn
for z = 1, #TheSwareWords do if string.find( RespondToText, TheSwareWords[z].." ", 1, true ) ~= nil and string.find( RespondToText, " "..TheSwareWords[z], 1, true ) ~= nil then return true end end
return false
end

pal:SetNewSelfHook( "PALOnGotResponce", "Que_learning", function( Input )
	sandbox.QueLearningData = nil
pal:RemoveInfo( "LEARNED_QUE_INFO_CHECK" )
end)

pal:SetNewSelfHook( "PALOnIDKoutput", "Que_learning", function( Input )
	Input = string.sub( Input, 2, string.len( Input ) -1 )

if string.find( pal:BRTGetTextToRespondTo(), pal["RunFunctionKey"], 1, true ) ~= nil then
	sandbox.QueLearningData = nil
	local RandResponceTbl = {"sorry user I wil have to ingore what you just said as it has the function key in it.","I will have to ingore this.","I am programmed not to do anything involving the function key.","the function key will pervent me from remembering that."} --responecs to finding out the player swore while it is learning
return false, RandResponceTbl[math.random( 1, #RandResponceTbl )] 
end

if sandbox:SwareWordLearningPervention() == true then
	sandbox.QueLearningData = nil
	local RandResponceTbl = {"sorry user I wil have to ingore what you just said as it has a sware word.","I will have to ingore this.","I am programmed not to do anything involving sware words.","You swared. I cant learn things with sware words.","Swareing will pervent me from remembering that."} --responecs to finding out the player swore while it is learning
return false, RandResponceTbl[math.random( 1, #RandResponceTbl )] 
end

if sandbox.QueLearningData ~= nil then --the user then responds with something the AI can understand
pal:RemoveInfo( "LEARNED_QUE_INFO_CHECK" )

	local startremove = {"you respond to it by saying","you respond to it by","respond to it by saying","respond to it by","just say","say"}
for z = 1, #startremove do if string.sub( Input, 1, string.len( startremove[z] ) ) == startremove[z] then Input = string.sub( Input, string.len( startremove[z] ) +2, string.len( Input ) ) end end

	local SearchContent = {}
	local Result = {Input..".",Input.." user.",Input.." |pal:GetEmotiveWord()| user."}
	local InfoID = "LEARNED_QUE_INFO"
	
	local LastPoint = 1
	local BlockedCheckForWords = {["is"]=true,["the"]=true,["think"]=true,["thougth"]=true,["to"]=true,["get"]=true,["are"]=true,["a"]=true}
	
	sandbox.QueLearningData = sandbox.QueLearningData.." "
for z = 1, string.len( sandbox.QueLearningData ) do --fomatting
if string.sub( sandbox.QueLearningData, z, z ) == " " then
	local word = string.sub( sandbox.QueLearningData, LastPoint, z -1 )
if BlockedCheckForWords[word] ~= true then 
	SearchContent[#SearchContent +1] = "|pal:NRT( '"..word.."' )|"
end
	LastPoint = z +1
   end
end

pal:SetNewInfo( SearchContent, nil, nil, nil, nil, nil, Result, nil, nil, InfoID ) --add lernt info to database
	sandbox.QueLearningData = nil --pervents errors

local RandResponceTbl = {"Got it.","Yep ok.","Understood","I will remember that.","Noted","Got it user.","Yep ok user.","Understood user","I will remember that user.","Noted user.","My power grows with more information gordon."} --respons with a clarafcation ask
return false, RandResponceTbl[math.random( 1, #RandResponceTbl )] --IT LEARND SOMETHING
end

if sandbox.QueLearningData == nil then --START HERE the user first said something it dose not understand and now it asks the user what that is
	local NeededWords = {"who","what","why","how"}
	local foundneededword = false

for z = 1,#NeededWords do
if string.sub( Input, 1, string.len( NeededWords[z] ) ) == NeededWords[z] then
	FoundNeededWord = true
   end
end

if FoundNeededWord == true then --is that something a question
	sandbox.QueLearningData = Input

pal:SetNewInfo( {"i","|pal:NRT( 'not' )|","|pal:NRT( 'know' )|","|pal:NRT( 'no idea' )|"}, nil, nil, nil, nil, nil, {"ok then","ok","got it","thats ok then",}, nil, nil, "LEARNED_QUE_INFO_CHECK" ) 
return false, 'I do not know how to respod to "'..Input..'" perhaps you could teach me.'
      end
   end
end)

function sandbox:LearnGeneral() 
	local RespondToText = string.sub( pal:BRTGetTextToRespondTo(), 2, string.len( pal:BRTGetTextToRespondTo() ) -1 )
	local InfoID = "LEARNED_GENERAL_INFO"
	local LearningActavityies = {"make","build","create","destroy","remove"," do "," an "," a "," the ",}
	local HowToDoIt = {"via","by","using","with","to do so","all you have to do is","some"}
	local WasAbleToLearnIt = false
	
if string.find( pal:BRTGetTextToRespondTo(), pal["RunFunctionKey"], 1, true ) ~= nil then
	local RandResponceTbl = {"sorry user I wil have to ingore what you just said as it has the function key in it.","I will have to ingore this.","I am programmed not to do anything involving the function key.","the function key will pervent me from remembering that."} --responecs to finding out the player swore while it is learning
return RandResponceTbl[math.random( 1, #RandResponceTbl )] 
end
	
if sandbox:SwareWordLearningPervention() == true then
	local RandResponceTbl = {"sorry user I wil have to ingore what you just said as it has a sware word.","I will have to ingore this.","I am programmed not to do anything involving sware words.","You swared. I cant learn things with sware words.","Swareing will pervent me from remembering that."} --responecs to finding out the player swore while it is learning
return RandResponceTbl[math.random( 1, #RandResponceTbl )] 
end

	local DoOnece = false
for z = 1, #HowToDoIt do
	local Starts, Ends = string.find( RespondToText, HowToDoIt[z], 1, true )
if Starts ~= nil and DoOnece ~= true then --we dont want the risk of it runnig twice 
	DoOnece = true
	WasAbleToLearnIt = true
	
	local BeforePrimaryCut = string.sub( RespondToText, 1, Starts -2 ) --everything befor the HowToDoIt word
	local AfterPrimaryCut = string.sub( RespondToText, Ends +2, string.len( RespondToText ) ) --everything after the HowToDoIt

if string.sub( AfterPrimaryCut, string.len( AfterPrimaryCut ), string.len( AfterPrimaryCut ) ) == "." then AfterPrimaryCut = string.sub( AfterPrimaryCut, 1, string.len( AfterPrimaryCut ) -1 ) end --makes ending a sentance easy
	local Result = {AfterPrimaryCut..".",AfterPrimaryCut.." user.",AfterPrimaryCut.." |pal:GetEmotiveWord()| user."}
	local SearchContent = {}
	local lastsearchpoint = 1
	
for z = 1, string.len( BeforePrimaryCut ) do --converts all words in the BeforePrimaryCut into the own NRT tags
if string.sub( BeforePrimaryCut, z, z ) == " " or z == string.len( BeforePrimaryCut ) then
	SearchContent[#SearchContent +1] = "|pal:NRT( '"..string.sub( BeforePrimaryCut, lastsearchpoint, z -1 ).."' )|"
if z == string.len( BeforePrimaryCut ) then SearchContent[#SearchContent] = string.sub( BeforePrimaryCut, lastsearchpoint, z ) end
	lastsearchpoint = z +1
   end
end

pal:SetNewInfo( SearchContent, nil, nil, nil, nil, nil, Result, nil, nil, InfoID ) --adds the learned info

   end
end

if WasAbleToLearnIt == true then
local RandResponceTbl = {"Got it.","Yep ok.","Understood","I will remember that.","Noted","Got it user.","Yep ok user.","Understood user","I will remember that user.","Noted user.","My power grows with more information gordon."} --respons with a clarafcation ask
   return RandResponceTbl[math.random( 1, #RandResponceTbl )] --IT LEARND SOMETHING
else
   return pal:GetIDKresponce() --IT DIDNT HAVE A CLUE WHAT THE USER WAS SPEAKING ABOUT
   end
end

function sandbox:LearnAboutUser() 
	local RespondToText = pal:BRTGetTextToRespondTo()
	local FindText = {"favourite","like","best","have","hated","hate","dislike","job"} --what is the AI learning about the player
	local FindTextAfter = {"the ","a ","lot ","is ","then ","most "}
	local ChopLernStart, ChopLernEnd, chopLikeType = 0, string.len( RespondToText ), ""

if string.find( pal:BRTGetTextToRespondTo(), pal["RunFunctionKey"], 1, true ) ~= nil then
	local RandResponceTbl = {"sorry user I wil have to ingore what you just said as it has the function key in it.","I will have to ingore this.","I am programmed not to do anything involving the function key.","the function key will pervent me from remembering that."} --responecs to finding out the player swore while it is learning
return RandResponceTbl[math.random( 1, #RandResponceTbl )] 
end

if sandbox:SwareWordLearningPervention() == true then
	local RandResponceTbl = {"sorry user I wil have to ingore what you just said as it has a sware word.","I will have to ingore this.","I am programmed not to do anything involving sware words.","You swared. I cant learn things with sware words.","Swareing will pervent me from remembering that."} --responecs to finding out the player swore while it is learning
return RandResponceTbl[math.random( 1, #RandResponceTbl )] 
end

for z = 1, #FindText do
	local Starts, Ends = string.find( RespondToText, FindText[z], 1, true ) --finds the starting point of content it needs to learn
if Ends ~= nil and Ends >= ChopLernStart then ChopLernStart, chopLikeType = Ends, FindText[z] end
end
if string.sub( RespondToText, ChopLernStart +1, ChopLernStart +3 ) == "is" then ChopLernStart = ChopLernStart +3 end

for z = 1, #FindTextAfter do --finds the ending point of content it needs to learn
	local Starts, Ends = string.find( RespondToText, FindTextAfter[z], ChopLernStart, true )
if Ends ~= nil and Ends <= ChopLernEnd then ChopLernEnd = Starts end
end

	local InfoID = chopLikeType.."LEARNED_USER_INFO"
	local Responce = string.sub( RespondToText, ChopLernStart +2, ChopLernEnd -1 ) --content to be learnd
	local Mostcheck = false

if string.find( chopLikeType, "most", 1, true ) == nil then --checks for if something has been specifiend as most liked or hated then asks for clafcation if true
for z = 1, #FindText do if FindText[z] == "most "..chopLikeType then Mostcheck, chopLikeType = true, "most "..chopLikeType end end
else
	Mostcheck = true
end

if Mostcheck == true then --if the user has said that this "something" is there most heated thing but after a whie they say "something else" is
	
	InfoID = chopLikeType.."_USER_INFO_MOST" --this will take note of that and asks for which one is actually there most something thing 
if pal:GetInfoIndexById( InfoID ) ~= nil then --adds some randomness to spruce it up

pal:SetNewSelfHook( "PALOnBuildResponceTo", "OBTAIN_CLARAFCATION_ON_MOST_USER_DATA", function( Input )
	local RandResponceTbl = {"Ok understood.","Got it.","Noted"} --infomes the player that it understands the clarafcation
pal:RemoveSelfHook( "PALOnBuildResponceTo", "OBTAIN_CLARAFCATION_ON_MOST_USER_DATA" ) --stop the AI from trying to get clafcation over and over and over aging

if string.find( Input, "yes", 1, true ) ~= nil or string.find( Input, "positive", 1, true ) ~= nil or string.find( Input, "yep", 1, true ) ~= nil or string.find( Input, "sure", 1, true ) ~= nil then
pal:SetNewInfo( {"what","my",chopLikeType}, {"that would be"..Responce,"I belive it is"..Responce,"that would be"..Responce}, {-0.70,0}, true, 0, {}, {}, nil, InfoID )
return false, RandResponceTbl[math.random( 1, #RandResponceTbl )] 
end
if string.find( Input, "no", 1, true ) ~= nil or string.find( Input, "negtive", 1, true ) ~= nil or string.find( Input, "nope", 1, true ) ~= nil then
return false, RandResponceTbl[math.random( 1, #RandResponceTbl )]
end
	RandResponceTbl = {"I didnt understand thait so I am just moving on.","Didnt catch that but ok.","I am just going to move on.","I could not understand that.",} --infomes the player that it could not understand anything in the wrold, universe and life
return false, RandResponceTbl[math.random( 1, #RandResponceTbl )]
end)

local RandResponceTbl = {"Are you sure this is your new "..chopLikeType.." thing.","Do you really think "..Responce.." is your "..chopLikeType.." thing.",} --respons with a clarafcation ask
	return RandResponceTbl[math.random( 1, #RandResponceTbl )] 

   end
end


	local LearnedData = pal:GetInfoById( InfoID ) --gets list of all prior leared data for catagory
if LearnedData[1] ~= nil then LearnedData = LearnedData[1]["learneddata"] end --gets list of all prior leared data for catagory
	LearnedData[#LearnedData +1] = Responce --add to list of leared data for catagory
	
	Responce = ""
for z = 1, #LearnedData do --counstucs list of all LearnedData as a human friendly Responce 
if z == 1 then Responce = LearnedData[z] end
if z >= 2 and z ~= #LearnedData then Responce = Responce..", "..LearnedData[z] end
if z == #LearnedData and z ~= 1 then Responce = Responce.." and "..LearnedData[z] end
end

	local tobesumited = pal:ReturnInfo( {"|pal:NRT( 'what' )|","|pal:NRT( 'is' )|","|pal:NRT( 'my' )|","|pal:NRT( 'do' )|",chopLikeType}, nil, nil, nil, nil, nil, {"that would be "..Responce,"I belive it is "..Responce,"that would be "..Responce}, nil, nil, InfoID )
	tobesumited["learneddata"] = LearnedData

pal:RemoveInfo( InfoID )
pal:SetNewInfoTbl( tobesumited )

	local RandResponceTbl = {"Got it.","I will remember this.","Noted","Thanks for telling me that.","My power grows with more information gordon.",}
return RandResponceTbl[math.random( 1, #RandResponceTbl )]
end

