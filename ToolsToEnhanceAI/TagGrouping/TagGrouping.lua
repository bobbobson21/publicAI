
 	local tagfile =  "tags.txt" --file to extract words from
	local outputfiletag = "pal_taggroups.lua" --results
	local outputfiledatatag = ""
	local outputfileinf = "pal_quorainfomodel.lua" --results
	local outputfiledatainf = ""
	
-- end of setting start of main code -------------------------------------------------------------------------------------------------------------------------
	
	local file = io.open( tagfile ,"r") --loads the file wi are extracting words from
	local tagfiledata = file:read( "*all" )..string.char( 10 )..""
file:close()

	local file = io.open( outputfiletag ,"r") --load the output file so we can append it
if file ~= nil then
	outputfiledatatag = file:read( "*all" )
file:close()
end
	local file = io.open( outputfileinf ,"r") --load the output file so we can append it
if file ~= nil then
	outputfiledatainf = file:read( "*all" )
file:close()
end

	local tagfind = {}
	local taggroup = {}
	local tag_lastline = 1
	local inf_loastpoint = 1
	local inf_startkey = "pal:SetNewInfo( {"

for z = 1, string.len( tagfiledata ) do
	local letter = string.sub( tagfiledata, z, z )
if string.sub( tagfiledata, z, z ) == string.char( 10 ) then
	local currentline = string.sub( tagfiledata, tag_lastline, z )
	local lastpoint = 1
	local groupdata = ""
	local groupid = "taggroup_"..tostring( z )
	
for x = 1, string.len( currentline ) do
	local letter = string.sub( currentline, x, x )
if letter == "," or x == string.len( currentline ) then
	local currenttags = string.sub( currentline, lastpoint, x -1 )
if groupdata == "" then groupdata = "'"..currenttags.."'" else groupdata = groupdata..",'"..currenttags.."'" end
	tagfind[#tagfind +1] = currenttags -- to be used for outputfileinf
	taggroup[#taggroup +1] = groupid --to be used for outputfileinf 
	lastpoint = x +1
   end
end

	outputfiledatatag = outputfiledatatag.."pal:AddNewTagGroup( '"..groupid.."', {"..groupdata.."} )"..string.char( 10 )
	tag_lastline = z +1	
   end
end

io.output( outputfiletag )
io.write( outputfiledatatag ) --puts all the data in or back into the output file
io.close()

io.output( io.stdout )

print( "grouped tag!!!" )

if outputfiledatainf ~= "" then
	local oldpercent = 0
	local z = 0
while z <= string.len( outputfiledatainf ) do
	z = z +1

	local letter = string.sub( outputfiledatainf, z, z )
if string.sub( outputfiledatainf, z, z ) == string.char( 10 ) then
	local currentline = string.sub( outputfiledatainf, inf_loastpoint, z -1 )
	local rstart = 0
	local rend = 0

for x = 1, string.len( currentline ) do
if string.sub( currentline, x, x ) == "{" and rstart == 0 then rstart = x +1 end
if string.sub( currentline, x, x ) == "}" and rend == 0 then rend = x -1 end
end

if rstart ~= nil and string.sub( currentline, 1, rstart -1 ) == inf_startkey then
	rstart = rstart +inf_loastpoint -1
	rend = rend +inf_loastpoint -1
	local newpercent = math.floor( ( ( z/ string.len( outputfiledatainf ) ) *100 ) +0.50 )

if oldpercent ~= newpercent then
	oldpercent = newpercent
print( "info file rewrite compleation is at %"..tostring( newpercent ) )
end


	local replacearea = string.sub( outputfiledatainf,  rstart, rend )
for x = 1, #tagfind do
replacearea = string.gsub( replacearea, "%|pal:NRT%('"..tagfind[x].."'%)%|", "|pal:NRT(pal:MWTG( '"..taggroup[x].."' ))|" )
replacearea = string.gsub( replacearea, '"'..tagfind[x]..'"', " |pal:MWTG( '"..taggroup[x].."' )| " )
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
