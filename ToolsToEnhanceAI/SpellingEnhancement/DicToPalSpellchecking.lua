
	local DictonaryFile =  "wordextractorresults.txt" --"jmonty42_dic.txt" --sadly it made a File that was to big to put on git hub
	local OutputFile = "pal_spellchecker_2.lua"
	local OutputFileData = ""
	local SaveIFPercentageIsDivBy = 10
	local SaveProgressKey = "--@@ "
	local KeyboardaragmentLetters = {
	{"q","w","e","r","t","y","u","i","o","p",},
	{"a","s","d","f","g","h","j","k","l",},
	{"Z","x","c","v","b","n",}
	}
	local KeyboardAragmentLocations = {
	{["q"]=1,["w"]=2,["e"]=3,["r"]=4,["t"]=5,["y"]=6,["u"]=7,["i"]=8,["o"]=9,["p"]=10,},
	{["a"]=1,["s"]=2,["d"]=3,["f"]=4,["g"]=5,["h"]=6,["j"]=7,["k"]=8,["l"]=9,},
	{["Z"]=1,["x"]=2,["c"]=3,["v"]=4,["b"]=5,["n"]=6,}
	}
	
-- end of setting start of OutputFile saveing and loading ----------------------------------------------------------------------------------------------------
	
function SaveProgesss( progress ) --this was made so that it could progress an entier diconary bit by bit but it was not needed in the end
	local AppendStartWith = ""
	
if progress ~= nil then AppendStartWith = SaveProgressKey..tostring( progress )..string.char( 10 ) end
io.output( OutputFile ) --we are doing files this way because the other way just kept giving me grife
io.write( AppendStartWith..OutputFileData )
io.close()

io.output( io.stdout )
end

function LoadProgesss()  --this was made so that it could progress an entier diconary bit by bit but it was not needed in the end
	local File = io.open( OutputFile ,"r")
if File == nil then return end
	local FileData = File:read( "*all" )
	local EndOfProgressData = 0
	
if string.sub( FileData, 1, string.len( SaveProgressKey ) ) == SaveProgressKey then
for Z = 1, 500 do --progress can not be save if it gose over 500 char so if the progress number is longer the the distance from the left to right side of this File baseicly
if string.sub( FileData, Z, Z ) == string.char( 10 ) then
if EndOfProgressData == 0 then EndOfProgressData = Z end
   end
end

	OutputFileData = string.sub( FileData, EndOfProgressData +1, string.len( FileData ) ) 
	local Num = tostring( string.sub( FileData, string.len( SaveProgressKey ) +1, EndOfProgressData -1 ) )
   return Num
   end
end

-- end of OutputFile saveing and loading start of OutputFile genaration --------------------------------------------------------------------------------------
	
	local File = io.open( DictonaryFile ,"r")
	local DictonaryFileData = File:read( "*all" )..string.char( 10 )..""
	local DictonaryBlockedWords = {}
	local LastPointOfProgress = LoadProgesss() or 0
	local LastLinePos = LastPointOfProgress
	
File:close()

for S in string.gmatch( DictonaryFileData, "[^%"..string.char( 10 ).."]+") do DictonaryBlockedWords[S] = true end --pervents word repeats in the OutputFile missspellings

for Z = LastPointOfProgress, string.len( DictonaryFileData ) do
if string.sub( DictonaryFileData, Z, Z ) == string.char( 10 ) then
	local CorrectWord = string.sub( DictonaryFileData, LastLinePos, Z -1 )
	local IncorrectWords = ""
	LastLinePos = Z +1

if string.len( CorrectWord ) >= 2 then
for y = 1, string.len( CorrectWord ) do --spellchecking by clicking wrong button
	local Letter = string.sub( CorrectWord, y, y )
	local WordLeft, WordRight = string.sub( CorrectWord, 1, y -1 ), string.sub( CorrectWord, y +1, string.len( CorrectWord ) )
	local letterOnKeybordX, letterOnKeybordY = 0, 0
if KeyboardAragmentLocations[1][Letter] ~= nil then letterOnKeybordX, letterOnKeybordY = KeyboardAragmentLocations[1][Letter], 1 end --finding right button
if KeyboardAragmentLocations[2][Letter] ~= nil then letterOnKeybordX, letterOnKeybordY = KeyboardAragmentLocations[2][Letter], 2 end
if KeyboardAragmentLocations[3][Letter] ~= nil then letterOnKeybordX, letterOnKeybordY = KeyboardAragmentLocations[3][Letter], 3 end

if letterOnKeybordX ~= 0 then
if KeyboardaragmentLetters[letterOnKeybordY][letterOnKeybordX -1] ~= nil then --finding possible wrong buttons from that
	local IncorrectWord = WordLeft..KeyboardaragmentLetters[letterOnKeybordY][letterOnKeybordX -1]..WordRight
if DictonaryBlockedWords[IncorrectWord] == nil then IncorrectWords = IncorrectWords.."'"..IncorrectWord.."',"; DictonaryBlockedWords[IncorrectWord] = true end
end
if KeyboardaragmentLetters[letterOnKeybordY][letterOnKeybordX +1] ~= nil then
	local IncorrectWord = WordLeft..KeyboardaragmentLetters[letterOnKeybordY][letterOnKeybordX +1]..WordRight
if DictonaryBlockedWords[IncorrectWord] == nil then IncorrectWords = IncorrectWords.."'"..IncorrectWord.."',"; DictonaryBlockedWords[IncorrectWord] = true end
end

if KeyboardaragmentLetters[letterOnKeybordY -1] ~= nil then
if KeyboardaragmentLetters[letterOnKeybordY -1][letterOnKeybordX] ~= nil then
	local IncorrectWord = WordLeft..KeyboardaragmentLetters[letterOnKeybordY -1][letterOnKeybordX]..WordRight
if DictonaryBlockedWords[IncorrectWord] == nil then IncorrectWords = IncorrectWords.."'"..IncorrectWord.."',"; DictonaryBlockedWords[IncorrectWord] = true end
end
if KeyboardaragmentLetters[letterOnKeybordY -1][letterOnKeybordX -1] ~= nil then
	local IncorrectWord = WordLeft..KeyboardaragmentLetters[letterOnKeybordY -1][letterOnKeybordX -1]..WordRight
if DictonaryBlockedWords[IncorrectWord] == nil then IncorrectWords = IncorrectWords.."'"..IncorrectWord.."',"; DictonaryBlockedWords[IncorrectWord] = true end
end
if KeyboardaragmentLetters[letterOnKeybordY -1][letterOnKeybordX +1] ~= nil then
	local IncorrectWord = WordLeft..KeyboardaragmentLetters[letterOnKeybordY -1][letterOnKeybordX]..WordRight
if DictonaryBlockedWords[IncorrectWord] == nil then IncorrectWords = IncorrectWords.."'"..IncorrectWord.."',"; DictonaryBlockedWords[IncorrectWord] = true end
         end
      end
   end
end

if IncorrectWords ~= "" and string.len( CorrectWord ) >= 3 then
for y = 1, string.len( CorrectWord ) do --spellchecking by not pressing a button
	local Letter = string.sub( CorrectWord, y, y )
	local PriorLetter = string.sub( CorrectWord, y -1, y -1 )
	local IncorrectWord = string.sub( CorrectWord, 1, y -1 )..string.sub( CorrectWord, y +1, string.len( CorrectWord ) )
if Letter ~= PriorLetter then --anoter pervention of repeats
if DictonaryBlockedWords[IncorrectWord] == nil then IncorrectWords = IncorrectWords.."'"..IncorrectWord.."',"; DictonaryBlockedWords[IncorrectWord] = true end
   end
end

	CorrectWord = "'"..CorrectWord.."'"
	OutputFileData = OutputFileData.."pal:AddNewSpellChecking( "..CorrectWord..", {"..IncorrectWords.."} )"..string.char( 10 ) --add to OutputFileData
end

	local CurrentPercent = math.ceil( ( Z /string.len( DictonaryFileData ) ) *100 )

if OldPercent == nil then OldPercent = 0 end
if CurrentPercent ~= OldPercent then --compleation level
print( tostring( CurrentPercent ).."% complete" ); OldPercent = CurrentPercent
if CurrentPercent %SaveIFPercentageIsDivBy == 0 then
SaveProgesss( Z ) --backing up data
print( "data backuped!!!" )
            end
         end
      end
   end
end

SaveProgesss()
print( "all data save" )
os.execute( "pause" )