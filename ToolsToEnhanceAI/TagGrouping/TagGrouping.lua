
 	local TagsFile =  "tags.txt" --file to extract words from
	local TagsOutputFile = "pal_InfoTagGroups.lua" --results
	local TagsOutputFileData = ""
	local InfoOutputFile = "pal_quorainfomodel.lua" --results
	local InfoOutputFileData = ""
	
-- end of setting start of main code -------------------------------------------------------------------------------------------------------------------------
	
	local File = io.open( TagsFile ,"r") --loads the file we are extracting tags from
	local TagsFiledata = File:read( "*all" )..string.char( 10 )..""
File:close()

	local File = io.open( TagsOutputFile ,"r") --load the output file so we can append it
if File ~= nil then
	TagsOutputFileData = File:read( "*all" )
File:close()
end
	local File = io.open( InfoOutputFile ,"r") --load the output file so we can append it
if File ~= nil then
	InfoOutputFileData = File:read( "*all" )
File:close()
end

	local TagLastLine = 1
	local InfoTagsToFind = {}
	local InfoTagGroups = {}
	local InfoLastLine = 1
	local InfoStartKey = "pal:SetNewInfo( {"

for Z = 1, string.len( TagsFiledata ) do
	local Letter = string.sub( TagsFiledata, Z, Z )
if string.sub( TagsFiledata, Z, Z ) == string.char( 10 ) then
	local CurrentLine = string.sub( TagsFiledata, TagLastLine, Z )
	local LastLinePos = 1
	local GroupData = ""
	local GroupID = "TagGroups_"..tostring( Z )
	
for X = 1, string.len( CurrentLine ) do
	local Letter = string.sub( CurrentLine, X, X )
if Letter == "," or X == string.len( CurrentLine ) then
	local CurrentTags = string.sub( CurrentLine, LastLinePos, X -1 )
if GroupData == "" then GroupData = "'"..CurrentTags.."'" else GroupData = GroupData..",'"..CurrentTags.."'" end
	InfoTagsToFind[#InfoTagsToFind +1] = CurrentTags -- to be used for InfoOutputFile
	InfoTagGroups[#InfoTagGroups +1] = GroupID --to be used for InfoOutputFile 
	LastLinePos = X +1
   end
end

	TagsOutputFileData = TagsOutputFileData.."pal:AddNewInfoTagGroups( '"..GroupID.."', {"..GroupData.."} )"..string.char( 10 )
	TagLastLine = Z +1	
   end
end

io.output( TagsOutputFile )
io.write( TagsOutputFileData ) --puts all the data in or back into the output file
io.close()

io.output( io.stdout )

print( "grouped tag!!!" )

if InfoOutputFileData ~= "" then
	local OldPercent = 0
	local Z = 0
while Z <= string.len( InfoOutputFileData ) do
	Z = Z +1

	local Letter = string.sub( InfoOutputFileData, Z, Z )
if string.sub( InfoOutputFileData, Z, Z ) == string.char( 10 ) then
	local CurrentLine = string.sub( InfoOutputFileData, InfoLastLine, Z -1 )
	local ReplaceAreaStart = 0
	local ReplaceAreaEnd = 0

for X = 1, string.len( CurrentLine ) do
if string.sub( CurrentLine, X, X ) == "{" and ReplaceAreaStart == 0 then ReplaceAreaStart = X +1 end
if string.sub( CurrentLine, X, X ) == "}" and ReplaceAreaEnd == 0 then ReplaceAreaEnd = X -1 end
end

if ReplaceAreaStart ~= nil and string.sub( CurrentLine, 1, ReplaceAreaStart -1 ) == InfoStartKey then
	ReplaceAreaStart = ReplaceAreaStart +InfoLastLine -1
	ReplaceAreaEnd = ReplaceAreaEnd +InfoLastLine -1
	local NewPercent = math.floor( ( ( Z/ string.len( InfoOutputFileData ) ) *100 ) +0.50 )

if OldPercent ~= NewPercent then
	OldPercent = NewPercent
print( "info file rewrite compleation is at %"..tostring( NewPercent ) )
end


	local ReplaceArea = string.sub( InfoOutputFileData,  ReplaceAreaStart, ReplaceAreaEnd )
for X = 1, #InfoTagsToFind do
ReplaceArea = string.gsub( ReplaceArea, "%|pal:NRT%( '"..InfoTagsToFind[X].."' %)%|", "|pal:NRT( pal:MWTG( '"..InfoTagGroups[X].."' ) )|" )
ReplaceArea = string.gsub( ReplaceArea, "%|pal:NRT%('"..InfoTagsToFind[X].."'%)%|", "|pal:NRT(pal:MWTG( '"..InfoTagGroups[X].."' ))|" )
ReplaceArea = string.gsub( ReplaceArea, '"'..InfoTagsToFind[X]..'"', '"'.."|pal:MWTG( '"..InfoTagGroups[X].."' )|"..'"' )
end
	InfoOutputFileData = string.sub( InfoOutputFileData, 1, ReplaceAreaStart -1 )..ReplaceArea..string.sub( InfoOutputFileData, ReplaceAreaEnd +1, string.len( InfoOutputFileData ) )
end

 	InfoLastLine = Z +1
   end
end

io.output( InfoOutputFile )
io.write( InfoOutputFileData ) --puts all the data in or back into the output file
io.close()

io.output( io.stdout )
end

print( "reworked code in inf file!!!" )
os.execute( "pause" )
