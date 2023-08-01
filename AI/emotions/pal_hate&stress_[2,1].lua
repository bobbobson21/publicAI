
	local emotionalwords = { --words the ai uses to describe the player
	"annoying",
	"problmatic",
	"horrible",
	"mean",
	"pesting",
	"bad",
	"streser",
	"annoyer",
	"annoying",
	"tenseing",
	"demanding",
	}

	local wordstomaketheaifeelthis = { --words to use that make the AI feel like this note all content from the emotionalwords tbl will also be added to this one and you should only use this for sware words and stuff like that
	"fucker",
	"cunt",
	"dick",
	"bitch",
	"ass",
	"douch",
	"hurry up",
	"be faster",
	"slow",
	"dumb",
	"try again",
	}

	local emotionclass = { --how the ai feels
	"angry",
	"stressed",
	"inranged",
	"bothered",
	"annoyed",
	"worried",
	"pissed off",
	"tense",
	"upset",
	"nervous",
	"displeased",
	"troubled",
	"sad",
	"strained",
	"ticked off",
	"hassled",
	}

	local sentanceappending = { --how to end a sentance when feeling this emotion
	"Now leave me alone please.",
	"Now stop bothering me.",
	"Now can you just leave",
	"Stop talking to me now if you can mnage it you fool.",
	"Now get lost.",
	"Now get lost please.",
	"Now leave me alone please,",
	"Now leave me alone I just want some peace.",
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

pal:AddNewEmotion( {2,1}, emotionalwords, wordstomaketheaifeelthis, emotionclass, sentanceappending )
