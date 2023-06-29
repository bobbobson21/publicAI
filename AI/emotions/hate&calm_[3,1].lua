
	local emotionalwords = { --words the ai uses to describe the player
	"annoying",
	"problmatic",
	"horrible",
	"mean",
	"pesting",
	"bad",
	}

	local wordstomaketheaifeelthis = { --words to use that make the AI feel like this note all content from the emotionalwords tbl will also be added to this one and you should only use this for sware words and stuff like that
	"fucker",
	"cunt",
	"dick",
	"bitch",
	"ass",
	"douch",
	}

	local emotionclass = { --how the ai feels
	"angry",
	"inranged",
	"annoyed",
	"pissed off",
	"upset",
	"displeased",
	"sad",
	"ticked off",
	}

	local sentanceappending = nil

pal:AddNewEmotion( {1,1}, emotionalwords, wordstomaketheaifeelthis, emotionclass, sentanceappending )
