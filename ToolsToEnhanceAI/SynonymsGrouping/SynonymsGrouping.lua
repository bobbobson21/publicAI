
 	local SynFile =  "synonyms.txt" --file to extract words from
	local OutputFileSyn = "pal_synonyms.lua" --results
	local OutputFileDataSyn = ""
	local OutputFileInfoModel = "pal_quorainfomodel.lua" --results
	local OutputFileDataInfoModel = ""
	
-- end of setting start of main code -------------------------------------------------------------------------------------------------------------------------
	
	local File = io.open( SynFile ,"r") --loads the file wi are extracting words from
	local SynFiledata = File:read( "*all" )..string.char( 10 )..""
File:close()

	local File = io.open( OutputFileSyn ,"r") --load the output file so we can append it
if File ~= nil then
	OutputFileDataSyn = File:read( "*all" )
File:close()
end
	local File = io.open( OutputFileInfoModel ,"r") --load the output file so we can append it
if File ~= nil then
	OutputFileDataInfoModel = File:read( "*all" )
File:close()
end

	local SynToFindInInfoFile = {}
	local SynGroupIDForSynInInfoFile = {}
	local SynEndOfLastLine = 1
	local InfoEndOfLastLine = 1
	local InfoReplaceAreaStartKey = "{"
	local InfoReplaceAreaEndKey = "}, nil, nil, nil )"

for Z = 1, string.len( SynFiledata ) do
	local Letter = string.sub( SynFiledata, Z, Z )
if string.sub( SynFiledata, Z, Z ) == string.char( 10 ) then
	local CurrentLine = string.sub( SynFiledata, SynEndOfLastLine, Z )
	local SynEndOfLastSyn = 1
	local SynGroupData = ""
	local SynGroupID = "SynGroup_"..tostring( Z )
	
for X = 1, string.len( CurrentLine ) do
	local Letter = string.sub( CurrentLine, X, X )
if Letter == "," or X == string.len( CurrentLine ) then
	local CurrentSysonym = string.sub( CurrentLine, SynEndOfLastSyn, X -1 )
if SynGroupData == "" then SynGroupData = "'"..CurrentSysonym.."'" else SynGroupData = SynGroupData..",'"..CurrentSysonym.."'" end
	SynToFindInInfoFile[#SynToFindInInfoFile +1] = CurrentSysonym -- to be used for OutputFileInfoModel
	SynGroupIDForSynInInfoFile[#SynGroupIDForSynInInfoFile +1] = SynGroupID --to be used for OutputFileInfoModel 
	SynEndOfLastSyn = X +1
   end
end

	OutputFileDataSyn = OutputFileDataSyn.."pal:AddNewSynonymsGroup( '"..SynGroupID.."', {"..SynGroupData.."} )"..string.char( 10 )
	SynEndOfLastLine = Z +1	
   end
end

io.output( OutputFileSyn )
io.write( OutputFileDataSyn ) --puts all the data in or back into the output file
io.close()

io.output( io.stdout )

print( "grouped synonyms!!!" )

if OutputFileDataInfoModel ~= "" then
	local OldPercent = 0
	local Z = 0
while Z <= string.len( OutputFileDataInfoModel ) do
	Z = Z +1

	local Letter = string.sub( OutputFileDataInfoModel, Z, Z )
if string.sub( OutputFileDataInfoModel, Z, Z ) == string.char( 10 ) then
	local CurrentLine = string.sub( OutputFileDataInfoModel, InfoEndOfLastLine, Z -1 )
	local ReplaceAreaStart = 0
for X = 1, string.len( CurrentLine ) do if string.sub( CurrentLine, X, X ) == "{" then ReplaceAreaStart = X +1 end end
	local ReplaceAreaEnd = string.len( CurrentLine ) +1 -string.len( InfoReplaceAreaEndKey )
if ReplaceAreaStart ~= 0 and string.sub( CurrentLine, ReplaceAreaEnd, string.len( CurrentLine ) ) == InfoReplaceAreaEndKey then
	ReplaceAreaStart = ReplaceAreaStart +InfoEndOfLastLine -1
	ReplaceAreaEnd = ReplaceAreaEnd +InfoEndOfLastLine -1
	local NewPercent = math.floor( ( ( Z/ string.len( OutputFileDataInfoModel ) ) *100 ) +0.50 )

if OldPercent ~= NewPercent then
	OldPercent = NewPercent
print( "info file rewrite compleation is at %"..tostring( NewPercent ) )
end


	local ReplaceArea = string.sub( OutputFileDataInfoModel,  ReplaceAreaStart, ReplaceAreaEnd )
for X = 1, #SynToFindInInfoFile do
	ReplaceArea = string.gsub( ReplaceArea, " "..SynToFindInInfoFile[X].." ", " |pal:GetSynonymsWord( '"..SynGroupIDForSynInInfoFile[X].."' )| " )
end
	OutputFileDataInfoModel = string.sub( OutputFileDataInfoModel, 1, ReplaceAreaStart -1 )..ReplaceArea..string.sub( OutputFileDataInfoModel, ReplaceAreaEnd +1, string.len( OutputFileDataInfoModel ) )
end

 	InfoEndOfLastLine = Z +1
   end
end

io.output( OutputFileInfoModel )
io.write( OutputFileDataInfoModel ) --puts all the data in or back into the output file
io.close()

io.output( io.stdout )
end

print( "reworked code in inf file!!!" )
os.execute( "pause" )
