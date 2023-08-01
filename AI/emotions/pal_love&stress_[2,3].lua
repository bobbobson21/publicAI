
	local emotionalwords = { --words the ai uses to describe the player
	"lovely",
	"kind",
	"helpful",
	"lovely",
	"good",
	"caring",
	"stressing",
	"problmatic",
	"stress induceing",
	"mean",
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
	"stressed",
	"unsure",
	"uneasy",
	"worried",
	"concerned",
	}

	local sentanceappending = { --how to end a sentance when feeling this emotion
	"can you try and be a bit calmer",
	"See you later loud mouth", --
	"Bye.",
	"Oh and calm down ok.",
	"Please be nicer from now on.",
	"Dont disappoint me with your words again.",
	"",
	"",
	"",
	"",
	"",
	}

pal:AddNewEmotion( {2,3}, emotionalwords, wordstomaketheaifeelthis, emotionclass, sentanceappending )