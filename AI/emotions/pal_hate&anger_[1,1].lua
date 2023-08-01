
	local emotionalwords = { --words the ai uses to describe the player
	"annoying",
	"problmatic",
	"horrible",
	"mean",
	"pest",
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

	local sentanceappending = { --how to end a sentance when feeling this emotion
	"Now leave me alone fool.",
	"Now stop bothering me jackass.",
	"Now wil that be all loser.",
	"Stop talking to me now if you can manage it you fool.",
	"Now get lost.",
	"Now get lost you pain in the butt.",
	"Now leave me alone you little pest.",
	"Now leave me alone you little butt head.",
	"",
	"",
	"",
	"",
	"",
	"",
	"",
	"",
	"",
	"",
	"",
	"",
	"",
	"",
	}

pal:AddNewEmotion( {1,1}, emotionalwords, wordstomaketheaifeelthis, emotionclass, sentanceappending )
