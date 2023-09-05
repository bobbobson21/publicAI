


	local synfile =  "synonyms.txt" --file to extract words from
	local outputfilesyn = "pal_synonyms.lua" --results
	local outputfiledatasyn = ""
	local outputfileinf = "pal_infomodel.lua" --results
	local outputfiledatainf = ""
	local lastline = 1
	
-- end of setting start of main code -------------------------------------------------------------------------------------------------------------------------
	
	local file = io.open( extfile ,"r") --loads the file wi are extracting words from
	local synfiledata = file:read( "*all" )..string.char( 10 )..""
file:close()

	local file = io.open( outputfilesyn ,"r") --load the output file so we can append it
if file ~= nil then
	local outputfiledatasyn = file:read( "*all" )
file:close()
end
	local file = io.open( outputfileinf ,"r") --load the output file so we can append it
if file ~= nil then
	local outputfiledatainf = file:read( "*all" )
file:close()
end

	local synfind = {}
	local syngroup = {}
	
for z = 1, string.len( synfiledata ) do
	local letter = string.sub( synfiledata, z, z )
if string.sub( synfiledata, z, z ) == string.char( 10 ) then
	local currentline = string.sub( synfiledata, lastline, z -1 )
	local lastpoint = lastline
	local groupdata = ""
	local groupid = "syngroup_"..tostring( z )
	
for x = lastline, z -1 do
	local letter = string.sub( synfiledata, x, x )
if letter == '"' or letter == "'" then
	local currentsysonym = string.sub( synfiledata, lastline, z -1 )
if groupdata == "" then groupdata = currentsysonym else groupdata = groupdata..","..currentsysonym end
	synfind[#synfind +1] = currentsysonym -- to be used for outputfileinf
	syngroup[#syngroup +1] = groupid --to be used for outputfileinf 
	lastpoint = x
   end
end

	outputfiledatasyn = outputfiledatasyn.."pal:AddNewSynonymsGroup( '"..groupid.."', {"..groupdata.."} )"
	lastline = z +1	
   end
end

io.output( outputfile )
io.write( outputfiledata ) --puts all the data in or back into the output file
io.close()

io.output( io.stdout )

print( "grouped synonyms!!!" )
os.execute( "pause" )

 --finish code here and debuging later btd the code you got to finish is the code that inserts the synonyms into infomodel then do tests