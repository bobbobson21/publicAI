
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

	local sentanceappending = { --how to end a sentance when feeling this emotion
	"Now please leave me alone.",
	"Now goodbye.",
	"Now pleae stop bothering me.",
	"Now please give me some space.",
	"Stop talking to me now ok.",
	"Now get lost.",
	"Now please get lost.",
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
