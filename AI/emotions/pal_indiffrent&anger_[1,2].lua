
	local emotionalwords = { --words the ai uses to describe the player
	"annoying",
	"problmatic",
	"cold",
	"calous",
	"stormy",
	"apathetic",
	"insensible",
	"insensitive",
	"phlegmatic",
	"mindless",
	"lethargic",
	}

	local wordstomaketheaifeelthis = { --words to use that make the AI feel like this note all content from the emotionalwords tbl will also be added to this one and you should only use this for sware words and stuff like that
	"fucker",
	"cunt",
	"dick",
	"bitch",
	"ass",
	"douch",
	"know it all",
	"wrong",
	"incorrect",
	"I dont agree",
	}

	local emotionclass = { --how the ai feels
	"lukewarm",
	"distant",
	"annoyed",
	"uninterested",
	"displeased",
	}

	local sentanceappending = { --how to end a sentance when feeling this emotion
	"Now leave me alone fool.",
	"Now stop bothering me you cold user.",
	"Now wil that be all calious user.",
	"Stop talking to me now if you can manage it you fool.",
	"Now get lost.",
	"Now get lost fool.",
	"Now leave me alone detached user.",
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

pal:AddNewEmotion( {1,2}, emotionalwords, wordstomaketheaifeelthis, emotionclass, sentanceappending )
