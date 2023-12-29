	local CurrentDirCommandData = io.popen( "cd" )
	local CurrentDir = CurrentDirCommandData:read( "*L" )
for Z = 1, string.len( CurrentDir ) do if string.sub( CurrentDir, Z, Z ) == string.char( 92 ) then CurrentDir = string.sub( CurrentDir, 1, Z -1 ).."/"..string.sub( CurrentDir, Z +1, string.len( CurrentDir ) ) end end
if string.sub( CurrentDir, string.len( CurrentDir ), string.len( CurrentDir ) ) == string.char( 10 ) then CurrentDir = string.sub( CurrentDir, 1, string.len( CurrentDir ) -1 ) end
CurrentDirCommandData:close()

dofile( CurrentDir.."/AI/emotions/pal_nutral_[3,2].lua" )
dofile( CurrentDir.."/AI/emotions/pal_hate&anger_[1,1].lua" )
dofile( CurrentDir.."/AI/emotions/pal_hate&calm_[3,1].lua" )
dofile( CurrentDir.."/AI/emotions/pal_hate&stress_[2,1].lua" )
dofile( CurrentDir.."/AI/emotions/pal_love&calm_[3,3].lua" )
dofile( CurrentDir.."/AI/emotions/pal_love&anger_[1,3].lua" )
dofile( CurrentDir.."/AI/emotions/pal_love&stress_[2,3].lua" )
dofile( CurrentDir.."/AI/emotions/pal_indiffrent&anger_[1,2].lua" )
dofile( CurrentDir.."/AI/emotions/pal_indiffrent&stress_[2,2].lua" )

dofile( CurrentDir.."/AI/IDKresponces/pal_idkdata.lua" )

dofile( CurrentDir.."/AI/annoyance/pal_annoyence_res.lua" )

dofile( CurrentDir.."/AI/spellchecking/pal_spellchecker_2.lua" )
dofile( CurrentDir.."/AI/spellchecking/pal_spellchecker.lua" )

dofile( CurrentDir.."/AI/synonyms/pal_synonyms.lua" )

dofile( CurrentDir.."/AI/sandbox&learning/pal_sandboxcentral.lua" )

dofile( CurrentDir.."/AI/infomation/pal_quorainfomodel.lua" ) --new one
dofile( CurrentDir.."/AI/infomation/pal_infomodel.lua" )

pal:SetRestorePoint()