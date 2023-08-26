	local sandbox = pal:SandBox() --by using the sandbox we can also send this content back to the last restore point as well if we need to

function sandbox:DoMaths() --this dose do math but it can also be used as a code injection point REMOVE IF USING FOR PUBLIC CONSUMTION
	local text = pal:BRTGetTextToRespondTo()
	local extractpointA, extractpointB = 999999, 0
	
for z = 1, string.len( text ) do
	local fixtext = string.sub( text, z, z +1 )
if fixtext == "%+" then text = string.sub( text, 1, z -1 ).." +"..string.sub( text, z +2, string.len( text ) ) end --removes % which happens when you type special characters
if fixtext == "%-" then text = string.sub( text, 1, z -1 ).." -"..string.sub( text, z +2, string.len( text ) ) end
if fixtext == "%*" then text = string.sub( text, 1, z -1 ).." *"..string.sub( text, z +2, string.len( text ) ) end
if fixtext == "%/" then text = string.sub( text, 1, z -1 ).." /"..string.sub( text, z +2, string.len( text ) ) end
if fixtext == "%^" then text = string.sub( text, 1, z -1 ).." ^"..string.sub( text, z +2, string.len( text ) ) end
if fixtext == "%<" then text = string.sub( text, 1, z -1 ).." <"..string.sub( text, z +2, string.len( text ) ) end
if fixtext == "%>" then text = string.sub( text, 1, z -1 ).." >"..string.sub( text, z +2, string.len( text ) ) end
if fixtext == "%=" then text = string.sub( text, 1, z -1 ).." ="..string.sub( text, z +2, string.len( text ) ) end	
	local subtext = string.sub( text, z, z ) --checks where the math starts and ends
if tonumber( subtext ) ~= nil then 
if z <= extractpointA then extractpointA = z end	
	extractpointB = z	
   end
end

if extractpointA == 999999 or extractpointB == 0 then return "ERROR UNABLE TO DO MATHS" end --ISSUE FINDING MATHS DATA

	text = string.sub( text, extractpointA, extractpointB ) --gets the maths
	local exe, null = load( "return "..text ) --runs the maths CAN ALSO RUN MECILOUS CODE SO ETHIER IMPROVE SECURITY OR REMOVE THIS FUNCTION BUT I WOULD DO THE SECOND ONE FOR SAFETY
	local result = exe()  

return tostring( result )
end

function sandbox:CheckMaths() --this checks math but it can also be used as a code injection point REMOVE IF USING FOR PUBLIC CONSUMTION
	local text = pal:BRTGetTextToRespondTo()
	local extractpointA, extractpointB, extractpointC = 999999, 0, 0
	
for z = 1, string.len( text ) do
	local fixtext = string.sub( text, z, z +1 )
if fixtext == "%+" then text = string.sub( text, 1, z -1 ).." +"..string.sub( text, z +2, string.len( text ) ) end
if fixtext == "%-" then text = string.sub( text, 1, z -1 ).." -"..string.sub( text, z +2, string.len( text ) ) end
if fixtext == "%*" then text = string.sub( text, 1, z -1 ).." *"..string.sub( text, z +2, string.len( text ) ) end
if fixtext == "%/" then text = string.sub( text, 1, z -1 ).." /"..string.sub( text, z +2, string.len( text ) ) end
if fixtext == "%^" then text = string.sub( text, 1, z -1 ).." ^"..string.sub( text, z +2, string.len( text ) ) end
if fixtext == "%<" then text = string.sub( text, 1, z -1 ).." <"..string.sub( text, z +2, string.len( text ) ) end
if fixtext == "%>" then text = string.sub( text, 1, z -1 ).." >"..string.sub( text, z +2, string.len( text ) ) end
if fixtext == "%=" then text = string.sub( text, 1, z -1 ).." ="..string.sub( text, z +2, string.len( text ) ) end	
	local subtext = string.sub( text, z, z )
if subtext == "=" then extractpointC = z end --the point extractpointB cant go path and the number past it is what we check the users math agienst
if tonumber( subtext ) ~= nil then 
if z <= extractpointA then extractpointA = z end	
if extractpointC == 0 then extractpointB = z end
   end
end
	text = string.sub( text, extractpointA, extractpointB )
	local exe, null = load( "return "..text )
	local result = tostring( exe() )  

if extractpointA == 999999 or extractpointB == 0 or extractpointC == 0 then return "ERROR UNABLE TO CHECK MATHS" end
if result == string.sub( text, extractpointC, string.len( text ) ) then
	local randresptbl = {"Yes that is correct.","You are right.","Correct","That is right.","Yes that is correct user.","You are right user.","Correct user.","That is right user."}
return randresptbl[math.random( 1, #randresptbl )]
else
	local randresptbl = {"No that is wrong.","You are wrong.","Wrong","That is wrong.","No that is wrong user.","You are wrong user.","Wrong user.","That is wrong user."}
	
pal:SetNewInfo( {"what","correct","answer",}, nil, {-0.70,0}, false, nil, nil, {"The correct answer is "..tostring( result )..".","The correct answer was "..tostring( result )..".","It is "..tostring( result )..".","It was "..tostring( result ).."."}, nil, nil, "MATH_AWNSER" )
pal:DegradeInfoOverXCycles( "MATH_AWNSER", 180 ) --this whay they dont ge the awnser unless they ask for it

return randresptbl[math.random( 1, #randresptbl )]
   end
end

function sandbox:SwareWordLearningPervention()
	local text = pal:BRTGetTextToRespondTo()
	local theswarewords = {"fuck","fucking","fucker","cunt","bitch","ass","ho","faggot","fag","retard"} --add words here you DONT want the AI to learn
for z = 1, #theswarewords do if string.find( text, theswarewords[z], 1, true ) ~= nil then return true end
return false
   end
end

function sandbox:LearnGeneral() 
	local text = pal:BRTGetTextToRespondTo()
	local infoid = "LEARNED_GENERAL_INFO"
	local learningactavityies = {"make","build","create","destroy","remove"," do "," an "," a "," the ",}
	local howtodoit = {"via","by","using","with","to do so","all you have to do is","some"}
	local wasabletolearn = false
	
if sandbox:SwareWordLearningPervention() == true then
	local randresptbl = {"sorry user I wil have to ingore what you just said as it has a sware word.","I will have to ingore this.","I am programmed not to do anything involving sware words.","You swared. I cant learn things with sware words.","Swareing will pervent me from remembering that."} --responecs to finding out the player swore while it is learning
return randresptbl[math.random( 1, #randresptbl )] 
end

	local doonece = false
for z = 1, #howtodoit do
	local starts, ends = string.find( text, howtodoit[z], 1, true )
if starts ~= nil and doonece ~= true then --we dont want the risk of it runnig twice 
	doonece = true
	wasabletolearn = true
	
	local beforeprimarycut = string.sub( text, 1, starts -2 ) --everything befor the howtodoit word
	local afterprimarycut = string.sub( text, ends +2, string.len( text ) ) --everything after the howtodoit

if string.sub( afterprimarycut, string.len( afterprimarycut ), string.len( afterprimarycut ) ) == "." then afterprimarycut = string.sub( afterprimarycut, 1, string.len( afterprimarycut ) -1 ) end --makes ending a sentance easy
	local result = {afterprimarycut..".",afterprimarycut.." user.",afterprimarycut.." |pal:GetEmotiveWord()| user."}
	local searchcontent = {}
	local lastsearchpoint = 1
	
for z = 1, string.len( beforeprimarycut ) do --converts all words in the beforeprimarycut into the own NRT tags
if string.sub( beforeprimarycut, z, z ) == " " or z == string.len( beforeprimarycut ) then
	searchcontent[#searchcontent +1] = "|pal:NRT( '"..string.sub( beforeprimarycut, lastsearchpoint, z -1 ).."' )|"
if z == string.len( beforeprimarycut ) then searchcontent[#searchcontent] = string.sub( beforeprimarycut, lastsearchpoint, z ) end
	lastsearchpoint = z +1
   end
end

pal:SetNewInfo( searchcontent, nil, nil, nil, nil, 1, result, nil, nil, infoid ) --adds the learned info

   end
end

if wasabletolearn == true then
local randresptbl = {"Got it.","Yep ok.","Understood","I will remember that.","Noted","Got it user.","Yep ok user.","Understood user","I will remember that user.","Noted user.","My power grows with more information gordon."} --respons with a clarafcation ask
   return randresptbl[math.random( 1, #randresptbl )] --IT LEARND SOMETHING
else
   return pal:GetIDKresponce() --IT DIDNT HAVE A CLUE WHAT THE USER WAS SPEAKING ABOUT
   end
end

function sandbox:LearnAboutUser() 
	local text = pal:BRTGetTextToRespondTo()
	local findtext = {"favourite","like","best","most liked","have","most hated","hate","most dislike","dislike","hate the most","job"} --what is the AI learning about the player
	local findtextafter = {"the ","a ","lot ","is ","then "}
	local choppoint, choppointb, chopword = 0, string.len( text ), ""
	local responce = ""
	local infoid = "LEARNED_USER_INFO"

if sandbox:SwareWordLearningPervention() == true then
	local randresptbl = {"sorry user I wil have to ingore what you just said as it has a sware word.","I will have to ingore this.","I am programmed not to do anything involving sware words.","You swared. I cant learn things with sware words.","Swareing will pervent me from remembering that."} --responecs to finding out the player swore while it is learning
return randresptbl[math.random( 1, #randresptbl )] 
end

for z = 1, #findtext do
	local starts, ends = string.find( text, findtext[z], 1, true ) --finds the starting point of content it needs to learn
if ends ~= nil and ends >= choppoint then choppoint, chopword = ends, findtext[z] end
end
if string.sub( text, choppoint +1, choppoint +3 ) == "is" then choppoint = choppoint +3 end

for z = 1, #findtextafter do --finds the ending point of content it needs to learn
	local starts, ends = string.find( text, findtextafter[z], choppoint, true )
if ends ~= nil and ends <= choppointb then choppointb = starts end
end

	local responce = string.sub( text, choppoint +1, choppointb -2 ) --content to be learnd
	local mostcheck = false

if string.find( chopword, "most", 1, true ) == nil then --checks for if something has been specifiend as most liked or hated then asks for clafcation if true
for z = 1, #findtext do if findtext[z] == "most "..chopword then mostcheck, chopword = true, "most "..chopword end end
else
	mostcheck = true
end

if mostcheck == true then --if the user has said that this "something" is there most heated thing but after a whie they say "something else" is
	
	infoid = chopword.."_USER_INFO_MOST" --this will take note of that and asks for which one is actually there most something thing 
if pal:GetInfoIndexById( infoid ) ~= nil and math.random( -2, 1 ) == 1 then --adds some randomness to spruce it up

pal:SetNewSelfHook( "PALOnBuildResponceTo", "OBTAIN_CLARAFCATION_ON_MOST_USER_DATA", function( input )
	local randresptbl = {"Ok understood.","Got it.","Noted"} --infomes the player that it understands the clarafcation
pal:RemoveSelfHook( "PALOnBuildResponceTo", "OBTAIN_CLARAFCATION_ON_MOST_USER_DATA" ) --stop the AI from trying to get clafcation over and over and over aging

if string.find( input, "yes", 1, true ) ~= nil or string.find( input, "positive", 1, true ) ~= nil or string.find( input, "yep", 1, true ) ~= nil or string.find( input, "sure", 1, true ) ~= nil then
pal:SetNewInfo( {"what","my",chopword}, {"that would be"..responce,"I belive it is"..responce,"that would be"..responce}, {-0.70,0}, true, 0, {}, {}, nil, infoid )
return false, randresptbl[math.random( 1, #randresptbl )] 
end
if string.find( input, "no", 1, true ) ~= nil or string.find( input, "negtive", 1, true ) ~= nil or string.find( input, "nope", 1, true ) ~= nil then
return false, randresptbl[math.random( 1, #randresptbl )]
end
	randresptbl = {"I didnt understand thait so I am just moving on.","Didnt catch that but ok.","I am just going to move on.","I could not understand that.",} --infomes the player that it could not understand anything in the wrold, universe and life
return false, randresptbl[math.random( 1, #randresptbl )]
end)

local randresptbl = {"Are you sure this is your new "..chopword.." thing.","Do you really think"..responce.."is your"..chopword.."think.",} --respons with a clarafcation ask
	return randresptbl[math.random( 1, #randresptbl )] 

   end
end

pal:SetNewInfo( {"pal:NRT( 'what' )","pal:NRT( 'is' )","pal:NRT( 'my' )","pal:NRT( 'do' )",chopword}, nil, nil, nil, nil, nil, {"that would be"..responce,"I belive it is"..responce,"that would be"..responce}, nil, nil, infoid )
	local randresptbl = {"Got it.","I will remember this.","Noted","Thanks for telling me that.","My power grows with more information gordon.",""}
return randresptbl[math.random( 1, #randresptbl )]
end

