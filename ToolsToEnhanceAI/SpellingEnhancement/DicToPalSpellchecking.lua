
	local dicfile =  "wordextractorresults.txt" --"jmonty42_dic.txt" --sadly it made a file that was to big to put on git hub
	local outputfile = "pal_spellchecker_2.lua"
	local outputfiledata = ""
	local savepercentage = 10
	local saveprogresskey = "--@@ "
	local keyboardaragmentkeys = {
	{"q","w","e","r","t","y","u","i","o","p",},
	{"a","s","d","f","g","h","j","k","l",},
	{"z","x","c","v","b","n",}
	}
	local keyboardaragmentindexes = {
	{["q"]=1,["w"]=2,["e"]=3,["r"]=4,["t"]=5,["y"]=6,["u"]=7,["i"]=8,["o"]=9,["p"]=10,},
	{["a"]=1,["s"]=2,["d"]=3,["f"]=4,["g"]=5,["h"]=6,["j"]=7,["k"]=8,["l"]=9,},
	{["z"]=1,["x"]=2,["c"]=3,["v"]=4,["b"]=5,["n"]=6,}
	}
	
	
	
-- end of setting start of outputfile saveing and loading ----------------------------------------------------------------------------------------------------
	
function SaveProgesss( progress ) --this was made so that it could progress an entier diconary bit by bit but it was not needed in the end
	local apstart = ""
	local lastpoint = 1	
	
if progress ~= nil then apstart = saveprogresskey..tostring( progress )..string.char( 10 ) end
io.output( outputfile ) --we are doing files this way because the other way just kept giving me grife
io.write( apstart..outputfiledata )
io.close()

io.output( io.stdout )
end

function LoadProgesss()  --this was made so that it could progress an entier diconary bit by bit but it was not needed in the end
	local file = io.open( outputfile ,"r")
if file == nil then return end
	local filedata = file:read( "*all" )
	local endofprogressdata = 0
	
if string.sub( filedata, 1, string.len( saveprogresskey ) ) == saveprogresskey then
for z = 1, 500 do --progress can not be save if it gose over 500 char so if the progress number is longer the the distance from the left to right side of this file baseicly
if string.sub( filedata, z, z ) == string.char( 10 ) then
if endofprogressdata == 0 then endofprogressdata = z end
   end
end

	outputfiledata = string.sub( filedata, endofprogressdata +1, string.len( filedata ) ) 
	local num = tostring( string.sub( filedata, string.len( saveprogresskey ) +1, endofprogressdata -1 ) )
   return num
   end
end

-- end of outputfile saveing and loading start of outputfile genaration --------------------------------------------------------------------------------------
	
	local file = io.open( dicfile ,"r")
	local dicfiledata = file:read( "*all" )..string.char( 10 )..""
	local dicfiledatablock = {}
	local lastprogresspoint = LoadProgesss() or 0
	local lastpoint = lastprogresspoint
	
file:close()

for s in string.gmatch( dicfiledata, "[^%"..string.char( 10 ).."]+") do dicfiledatablock[s] = true end --pervents word repeats in the outputfile missspellings

for z = lastprogresspoint, string.len( dicfiledata ) do
if string.sub( dicfiledata, z, z ) == string.char( 10 ) then
	local correctword = string.sub( dicfiledata, lastpoint, z -1 )
	local incorrectwords = ""
	lastpoint = z +1

if string.len( correctword ) >= 2 then
for y = 1, string.len( correctword ) do --spellchecking by clicking wrong button
	local letter = string.sub( correctword, y, y )
	local wordleft, wordright = string.sub( correctword, 1, y -1 ), string.sub( correctword, y +1, string.len( correctword ) )
	local letterloc, letterrow = 0, 0
if keyboardaragmentindexes[1][letter] ~= nil then letterloc, letterrow = keyboardaragmentindexes[1][letter], 1 end --finding right button
if keyboardaragmentindexes[2][letter] ~= nil then letterloc, letterrow = keyboardaragmentindexes[2][letter], 2 end
if keyboardaragmentindexes[3][letter] ~= nil then letterloc, letterrow = keyboardaragmentindexes[3][letter], 3 end

if letterloc ~= 0 then
if keyboardaragmentkeys[letterrow][letterloc -1] ~= nil then --finding possible wrong buttons from that
	local incorrectword = wordleft..keyboardaragmentkeys[letterrow][letterloc -1]..wordright
if dicfiledatablock[incorrectword] == nil then incorrectwords = incorrectwords.."'"..incorrectword.."'," end
end
if keyboardaragmentkeys[letterrow][letterloc +1] ~= nil then
	local incorrectword = wordleft..keyboardaragmentkeys[letterrow][letterloc +1]..wordright
if dicfiledatablock[incorrectword] == nil then incorrectwords = incorrectwords.."'"..incorrectword.."'," end
end

if keyboardaragmentkeys[letterrow -1] ~= nil then
if keyboardaragmentkeys[letterrow -1][letterloc] ~= nil then
	local incorrectword = wordleft..keyboardaragmentkeys[letterrow -1][letterloc]..wordright
if dicfiledatablock[incorrectword] == nil then incorrectwords = incorrectwords.."'"..incorrectword.."'," end
end
if keyboardaragmentkeys[letterrow -1][letterloc -1] ~= nil then
	local incorrectword = wordleft..keyboardaragmentkeys[letterrow -1][letterloc -1]..wordright
if dicfiledatablock[incorrectword] == nil then incorrectwords = incorrectwords.."'"..incorrectword.."'," end
end
if keyboardaragmentkeys[letterrow -1][letterloc +1] ~= nil then
	local incorrectword = wordleft..keyboardaragmentkeys[letterrow -1][letterloc]..wordright
if dicfiledatablock[incorrectword] == nil then incorrectwords = incorrectwords.."'"..incorrectword.."'," end
         end
      end
   end
end

for y = 1, string.len( correctword ) do --spellchecking by not pressing a button
	local letter = string.sub( correctword, y, y )
	local priorletter = string.sub( correctword, y -1, y -1 )
	local incorrectword = string.sub( correctword, 1, y -1 )..string.sub( correctword, y +1, string.len( correctword ) )
if letter ~= priorletter then --anoter pervention of repeats
if dicfiledatablock[incorrectword] == nil then incorrectwords = incorrectwords.."'"..incorrectword.."'," end
   end
end

	correctword = "'"..correctword.."'"
	outputfiledata = outputfiledata.."pal:AddNewSpellChecking( "..correctword..", {"..incorrectwords.."} )"..string.char( 10 ) --add to outputfiledata

	local currentpercent = math.ceil( ( z /string.len( dicfiledata ) ) *100 )

if oldpercent == nil then oldpercent = 0 end
if currentpercent ~= oldpercent then --compleation level
print( tostring( currentpercent ).."% complete" ); oldpercent = currentpercent
if currentpercent %savepercentage == 0 then
SaveProgesss( z ) --backing up data
print( "data backuped!!!" )
            end
         end
      end
   end
end

SaveProgesss()
print( "all data save" )
os.execute( "pause" )