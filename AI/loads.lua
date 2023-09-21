	local cdc = io.popen( "cd" )
	local current_dir = cdc:read( "*l" )
for z = 1, string.len( current_dir ) do if string.sub( current_dir, z, z ) == string.char( 92 ) then current_dir = string.sub( current_dir, 1, z -1 ).."/"..string.sub( current_dir, z +1, string.len( current_dir ) ) end end
cdc:close()

dofile( current_dir.."/AI/emotions/pal_nutral_[3,2].lua" )
dofile( current_dir.."/AI/emotions/pal_hate&anger_[1,1].lua" )
dofile( current_dir.."/AI/emotions/pal_hate&calm_[3,1].lua" )
dofile( current_dir.."/AI/emotions/pal_hate&stress_[2,1].lua" )
dofile( current_dir.."/AI/emotions/pal_love&calm_[3,3].lua" )
dofile( current_dir.."/AI/emotions/pal_love&anger_[1,3].lua" )
dofile( current_dir.."/AI/emotions/pal_love&stress_[2,3].lua" )
dofile( current_dir.."/AI/emotions/pal_indiffrent&anger_[1,2].lua" )
dofile( current_dir.."/AI/emotions/pal_indiffrent&stress_[2,2].lua" )

dofile( current_dir.."/AI/IDKresponces/pal_idkdata.lua" )

dofile( current_dir.."/AI/annoyance/pal_annoyence_res.lua" )

dofile( current_dir.."/AI/spellchecking/pal_spellchecker.lua" )
dofile( current_dir.."/AI/spellchecking/pal_spellchecker_2.lua" )

dofile( current_dir.."/AI/synonyms/pal_synonyms.lua" )

dofile( current_dir.."/AI/sandbox&learning/pal_sandboxcentral.lua" )

dofile( current_dir.."/AI/infomation/pal_quorainfomodel.lua" ) --new one
dofile( current_dir.."/AI/infomation/pal_infomodel.lua" )

pal:SetRestorePoint()