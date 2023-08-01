
	local emotionalwords = { --words the ai uses to describe the player
	"lovely",
	"kind",
	"helpful",
	"lovely",
	"good",
	"caring",
	}

	local wordstomaketheaifeelthis = { --words to use that make the AI feel like this note all content from the emotionalwords tbl will also be added to this one and you should only use this for sware words and stuff like that

	}

	local emotionclass = { --how the ai feels
	"happy",
	"good",
	"positive",
	"infaturted",
	"calm",
	"good",
	"contempt",
	}

	local sentanceappending = { --how to end a sentance when feeling this emotion
	"Hope we talk again soon.",
	"See you later.",
	"See you later alagator.",
	"Byyyyeeeeee.",
	"See you later lovely.",
	"See you later cutie.",
	"",
	"",
	"",
	"",
	"",
	}

pal:AddNewEmotion( {3,3}, emotionalwords, wordstomaketheaifeelthis, emotionclass, sentanceappending )