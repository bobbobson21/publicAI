	local cdc = io.popen( "cd" )
	local current_dir = cdc:read( "*l" )
for z = 1, string.len( current_dir ) do if string.sub( current_dir, z, z ) == string.char( 92 ) then current_dir = string.sub( current_dir, 1, z -1 ).."/"..string.sub( current_dir, z +1, string.len( current_dir ) ) end end
cdc:close()

	local AI = dofile( current_dir.."/AI/pal_ai_main.lua" )

::talk_start::
print( AI:BuildResponceTo( io.read() ) )
goto talk_start