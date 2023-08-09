	local sandbox = pal:Sandbox() --by using the sandbox we can also send this content back to the last restore point as well if we need to

function sandbox:DoMaths() --this dose do math but it can also be used as a code injection point REMOVE IF USING FOR PUBLIC CONSUMTION
	local text = pal:BRTGetTextToRespondTo()
	local extractpointA, extractpointB = 999999, 0
	
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
if tonumber( subtext ) ~= nil then 
if z <= extractpointA then extractpointA = z end	
	extractpointB = z	
   end
end
	text = string.sub( text, extractpointA, extractpointB )
	local exe, null = load( "return "..text )
	local result = exe()  

if extractpointA == 999999 or extractpointB == 0 then return "ERROR UNABLE TO DO MATHS" end

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
if subtext == "=" then extractpointC = z end
if tonumber( subtext ) ~= nil then 
if z <= extractpointA then extractpointA = z end	
if extractpointC == 0 then extractpointB = z end
   end
end
	text = string.sub( text, extractpointA, extractpointB )
	local exe, null = load( "return "..text )
	local result = exe()  

if extractpointA == 999999 or extractpointB == 0 or extractpointC == 0 then return "ERROR UNABLE TO CHECK MATHS" end
if result == string.sub( text, extractpointC, string.len( text ) ) then
	local randresptbl = {"Yes that is correct.","You are right.","Correct","That is right.","Yes that is correct user.","You are right user.","Correct user.","That is right user."}
return randresptbl[math.random( 1, #randresptbl )]
else
	local randresptbl = {"No that is wrong.","You are wrong.","Wrong","That is wrong.","No that is wrong user.","You are wrong user.","Wrong user.","That is wrong user."}
	
pal:SetNewInfo( {"what","correct","answer",}, {}, {-0.70,0}, true, 0, {"The correct answer is "..tostring( result )..".","The correct answer was "..tostring( result )..".","It is "..tostring( result )..".","It was "..tostring( result ).."."}, {}, nil, "MATH_AWNSER" )
pal:DegradeInfoOverXCycles( "MATH_AWNSER", 180 )

return randresptbl[math.random( 1, #randresptbl )]
   end
end

function sandbox:LearnAboutUser() 
	local text = pal:BRTGetTextToRespondTo()



end

function sandbox:LearnGeneral() 
	local text = pal:BRTGetTextToRespondTo()


end
