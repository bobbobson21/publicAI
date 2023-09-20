--[[-----------------------------------------------------------------------
if you are woundering why this file exsists baseicly it extracts all the
words (in strings) in pals files or brain i guss you could call it.

Anyhow the results file if used with the dictospellchecking script will
result in it making a spellchecker that makes the AI much more capable of
understanding what you saying as long as it cares about what your saying
and your spelling isn't so bad that I have a chance in beating you in a
spellingbee.
-----------------------------------------------------------------------]]--	

	
	local stringchars = {["'"]=true,['"']=true} --we search the file for string because those usally have words that are not functions
	local excludecharters = {"|","@","_","(",")","[","]","“","”","'","’",'"',":",";","1","2","3","4","5","6","7","8","9","0","..","!!","??","/","—","…"} --dont add string to outputfiledata if it has this char in it
	local extfile =  "pal_infomodel.lua" --file to extract words from
	local outputfile = "wordextractorresults.txt" --results
	local outputfiledata = ""
	
-- end of setting start of main code -------------------------------------------------------------------------------------------------------------------------
	
	local file = io.open( extfile ,"r") --loads the file wi are extracting words from
	local excfiledata = file:read( "*all" )..string.char( 10 )..""
	local inlevelposs = {}
file:close()
	local file = io.open( outputfile ,"r") --load the output file so we can append it
if file ~= nil then
	local outputfiledata = file:read( "*all" )
file:close()
end

for z = 1, string.len( excfiledata ) do
	local letter = string.sub( excfiledata, z, z )
if stringchars[letter] == true then
if inlevelposs[letter] == nil then
	inlevelposs[letter] = z --found starting poing of string
else
	local outputdata = string.sub( excfiledata, inlevelposs[letter] +1, z -1 ) --a string and string end point has been found

for z = 1, #excludecharters do --is string allowed
if outputdata ~= nil and string.find( outputdata, excludecharters[z], 1, true ) ~= nil then outputdata = nil end
end

if outputdata ~= nil then
for s in string.gmatch( outputdata, "[^%s]+" ) do --breaks string into words
	local newword = string.lower( s )

if string.sub( newword, string.len( newword ), string.len( newword ) ) == "!" then newword = string.sub( newword, 1, string.len( newword ) -1 ) end
if string.sub( newword, string.len( newword ), string.len( newword ) ) == "?" then newword = string.sub( newword, 1, string.len( newword ) -1 ) end
if string.sub( newword, string.len( newword ), string.len( newword ) ) == "," then newword = string.sub( newword, 1, string.len( newword ) -1 ) end
if string.sub( newword, string.len( newword ), string.len( newword ) ) == "." then newword = string.sub( newword, 1, string.len( newword ) -1 ) end
if string.find( outputfiledata, newword, 1, true ) == nil then --blocks repeats
if string.find( outputdata, ".", 1, true ) == nil then
outputfiledata = outputfiledata..newword..string.char( 10 ) --adds words to outputfiledata
         end
      end
   end
end
	inlevelposs[letter] = nil --allows us to read anoter string of this type without issus
      end
   end
end

io.output( outputfile )
io.write( outputfiledata ) --puts all the data in or back into the output file
io.close()

io.output( io.stdout )

print( "words extracted!!!" )
os.execute( "pause" )