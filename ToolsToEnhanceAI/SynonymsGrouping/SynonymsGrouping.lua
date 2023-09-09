
 	local synfile =  "synonyms.txt" --file to extract words from
	local outputfilesyn = "pal_synonyms.lua" --results
	local outputfiledatasyn = ""
	local outputfileinf = "pal_infomodel.lua" --results
	local outputfiledatainf = ""
	
-- end of setting start of main code -------------------------------------------------------------------------------------------------------------------------
	
	local file = io.open( synfile ,"r") --loads the file wi are extracting words from
	local synfiledata = file:read( "*all" )..string.char( 10 )..""
file:close()

	local file = io.open( outputfilesyn ,"r") --load the output file so we can append it
if file ~= nil then
	outputfiledatasyn = file:read( "*all" )
file:close()
end
	local file = io.open( outputfileinf ,"r") --load the output file so we can append it
if file ~= nil then
	outputfiledatainf = file:read( "*all" )
file:close()
end

	local synfind = {}
	local syngroup = {}
	local syn_lastline = 1
	local inf_loastpoint = 1
	local inf_startkey = "{"
	local inf_endkey = "}, nil, nil, nil )"

for z = 1, string.len( synfiledata ) do
	local letter = string.sub( synfiledata, z, z )
if string.sub( synfiledata, z, z ) == string.char( 10 ) then
	local currentline = string.sub( synfiledata, syn_lastline, z )
	local lastpoint = 1
	local groupdata = ""
	local groupid = "syngroup_"..tostring( z )
	
for x = 1, string.len( currentline ) do
	local letter = string.sub( currentline, x, x )
if letter == "," or x == string.len( currentline ) then
	local currentsysonym = string.sub( currentline, lastpoint, x -1 )
if groupdata == "" then groupdata = "'"..currentsysonym.."'" else groupdata = groupdata..",'"..currentsysonym.."'" end
	synfind[#synfind +1] = currentsysonym -- to be used for outputfileinf
	syngroup[#syngroup +1] = groupid --to be used for outputfileinf 
	lastpoint = x +1
   end
end

	outputfiledatasyn = outputfiledatasyn.."pal:AddNewSynonymsGroup( '"..groupid.."', {"..groupdata.."} )"..string.char( 10 )
	syn_lastline = z +1	
   end
end

io.output( outputfilesyn )
io.write( outputfiledatasyn ) --puts all the data in or back into the output file
io.close()

io.output( io.stdout )

print( "grouped synonyms!!!" )

if outputfiledatainf ~= "" then

for z = 1, string.len( outputfiledatainf ) *1000 do
	local letter = string.sub( outputfiledatainf, z, z )
if string.sub( outputfiledatainf, z, z ) == string.char( 10 ) then
	local currentline = string.sub( outputfiledatainf, inf_loastpoint, z -1 )
	local rstart, null = string.find( currentline, "{[^{]*$" )
	local rend = string.len( currentline ) +1 -string.len( inf_endkey )

if rstart ~= nil and string.sub( currentline, rend, string.len( currentline ) ) == inf_endkey then
	rstart = rstart +inf_loastpoint -1
	rend = rend +inf_loastpoint -1

	local replacearea = string.sub( outputfiledatainf,  rstart, rend )
for x = 1, #synfind do
	replacearea = string.gsub( replacearea, synfind[x], "|pal:GetSynonymsWord( '"..syngroup[x].."' )|" )
end
	outputfiledatainf = string.sub( outputfiledatainf, 1, rstart -1 )..replacearea..string.sub( outputfiledatainf, rend +1, string.len( outputfiledatainf ) )
end

 	inf_loastpoint = z +1
   end
end

io.output( outputfileinf )
io.write( outputfiledatainf ) --puts all the data in or back into the output file
io.close()

io.output( io.stdout )
end

print( "reworked code in inf file!!!" )
os.execute( "pause" )
