	local cdc = io.popen( "cd" )
	local current_dir = cdc:read( "*l" )
for z = 1, string.len( current_dir ) do if string.sub( current_dir, z, z ) == string.char( 92 ) then current_dir = string.sub( current_dir, 1, z -1 ).."/"..string.sub( current_dir, z +1, string.len( current_dir ) ) end end
cdc:close()

dofile( current_dir.."/AI/IDKresponces/idkdata.lua" )
dofile( current_dir.."/AI/emotions/nutral_[3,2].lua" )
dofile( current_dir.."/AI/emotions/love&calm_[3,3].lua" )
