	local CurrentDirCommandData = io.popen( "cd" )
	local CurrentDir = CurrentDirCommandData:read( "*L" )
for Z = 1, string.len( CurrentDir ) do if string.sub( CurrentDir, Z, Z ) == string.char( 92 ) then CurrentDir = string.sub( CurrentDir, 1, Z -1 ).."/"..string.sub( CurrentDir, Z +1, string.len( CurrentDir ) ) end end
if string.sub( CurrentDir, string.len( CurrentDir ), string.len( CurrentDir ) ) == string.char( 10 ) then CurrentDir = string.sub( CurrentDir, 1, string.len( CurrentDir ) -1 ) end
CurrentDirCommandData:close()

	local AI = dofile( CurrentDir.."/AI/pal_ai_main.lua" )

::talk_start::
io.write( "user: " )
	local Input = io.read()
print( "" )
print( "AI: "..tostring( AI:BuildResponceTo( Input ) ) )
print( "" )
goto talk_start