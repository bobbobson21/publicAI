
	local emotionalwords = { --words the ai uses to describe the player
	"lovely",
	"kind",
	"helpful",
	"lovely",
	"good",
	"caring",
	"annoying",
	"problmatic",
	"horrible",
	"mean",
	"pesting",
	"bad",
	"disappointment",
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
	"disappointed",
	"unsure",
	"uneasy",
	"worried",
	"concerned",
	}

	local sentanceappending = { --how to end a sentance when feeling this emotion
	"Can you also please speak a bit nicely from now one.",
	"See you later lord user.", --
	"Bye.",
	"Oh and whatch your tong.",
	"Please be nicer from now on.",
	"Dont disappoint me with your words again.",
	"",
	"",
	"",
	"",
	"",
	}

pal:AddNewEmotion( {1,3}, emotionalwords, wordstomaketheaifeelthis, emotionclass, sentanceappending )