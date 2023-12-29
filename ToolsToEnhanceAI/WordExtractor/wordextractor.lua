--[[-----------------------------------------------------------------------
if you are woundering why this file exsists baseicly it extracts all the
words (in strings) in pals files or brain i guss you could call it.

Anyhow the results file if used with the dictospellchecking script will
result in it making a spellchecker that makes the AI much more capable of
understanding what you saying as long as it cares about what your saying
and your spelling isn't so bad that I have a chance in beating you in a
spellingbee.
-----------------------------------------------------------------------]]--	

	
	local StringChars = {["'"]=true,['"']=true} --we search the file for string because those usally have words that are not functions
	local ExcludeChars = {"|","@","_","(",")","[","]","“","”","'","’",'"',":",";","1","2","3","4","5","6","7","8","9","0","..","!!","??","/","—","…","-"} --dont add string to OutputFiledata if it has this char in it
	local ExtWordsFromFile =  "pal_infomodel.lua" --file to extract words from
	local OutputFile = "wordextractorresults.txt" --results
	local OutputFileData = ""
	
-- end of setting start of main code -------------------------------------------------------------------------------------------------------------------------
	
	local File = io.open( ExtWordsFromFile ,"r") --loads the file wi are extracting words from
	local ExtWordsFromFileData = File:read( "*all" )..string.char( 10 )..""
	local StringsStartPoss = {}
	local WordsAddedSoFar = {}
	
File:close()
	local File = io.open( OutputFile ,"r") --load the output file so we can append it
if File ~= nil then
	local OutputFileData = File:read( "*all" )
File:close()
end

for z = 1, string.len( ExtWordsFromFileData ) do
	local Letter = string.sub( ExtWordsFromFileData, z, z )
if StringChars[Letter] == true then
if StringsStartPoss[Letter] == nil then
	StringsStartPoss[Letter] = z --found starting poing of string
else
	local Outputdata = string.sub( ExtWordsFromFileData, StringsStartPoss[Letter] +1, z -1 ) --a string and string end point has been found

for z = 1, #ExcludeChars do --is string allowed
if Outputdata ~= nil and string.find( Outputdata, ExcludeChars[z], 1, true ) ~= nil then Outputdata = nil end
end

if Outputdata ~= nil then
for s in string.gmatch( Outputdata, "[^%s]+" ) do --breaks string into words
	local NewWord = string.lower( s )

if string.sub( NewWord, string.len( NewWord ), string.len( NewWord ) ) == "!" then NewWord = string.sub( NewWord, 1, string.len( NewWord ) -1 ) end
if string.sub( NewWord, string.len( NewWord ), string.len( NewWord ) ) == "?" then NewWord = string.sub( NewWord, 1, string.len( NewWord ) -1 ) end
if string.sub( NewWord, string.len( NewWord ), string.len( NewWord ) ) == "," then NewWord = string.sub( NewWord, 1, string.len( NewWord ) -1 ) end
if string.sub( NewWord, string.len( NewWord ), string.len( NewWord ) ) == "." then NewWord = string.sub( NewWord, 1, string.len( NewWord ) -1 ) end
if string.find( NewWord, ".", 1, true ) == nil then
if WordsAddedSoFar[NewWord] ~= true then
	WordsAddedSoFar[NewWord] = true
OutputFileData = OutputFileData..NewWord..string.char( 10 ) --adds words to OutputFileData
         end
      end
   end
end
	StringsStartPoss[Letter] = nil --allows us to read anoter string of the letters type without issus
      end
   end
end

io.output( OutputFile )
io.write( OutputFileData ) --puts all the data in or back into the output file
io.close()

io.output( io.stdout )

print( "words extracted!!!" )
os.execute( "pause" )