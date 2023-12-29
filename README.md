# contents
 o [how to add infomation to pal](#how-to-add-infomation-to-pal)  
 ^ [infomation](#infomation)  
 ^ [functions in infomation](#functions-in-infomation)  
 ^ [IDK responces](#IDK-responces)
 
 o [how to deal with emotion and annoyance](#how-to-deal-with-emotion-and-annoyance)  
 ^ [emotions basics](#emotions-basics)  
 ^ [annoyance](#annoyance)   

 o [how to make good AIs](#how-to-make-good-ais)  
 ^ [what makes a good AI](#what-makes-a-good-ai)  
 ^ [why you should use the tool and how to use the tools](#why-you-should-use-the-tool-and-how-to-use-the-tools)  
 ^ [why you should use fuctions in tags and responce](#why-you-should-use-fuctions-in-tags-and-responce)  
 ^ [how to structer huge AIs](#how-to-structer-huge-ais) 

 o [using](#using) 

# how to add infomation to pal

## infomation
Infomation is the backbone of what makes pal/public AIs AIs work and if a pal ai has no infomation it is nothing but junk so this is one of the most important things for pal. To add infmation you use one of the following functions:

```
pal:SetNewInfo( SearchFor, SearchForPrior, EmotionChange, EmotionAppend, Annoyable, Inportance, Responces, SubInfo, Append, ID )
data = pal:ReturnInfo( SearchFor, SearchForPrior, EmotionChange, EmotionAppend, Annoyable, Inportance, Responces, SubInfo, Append, ID )
pal:SetNewInfoTbl( data )
```

The input vars also stand for the following things:

Oh and the word after the slash is the name the value is stored by in the info.

 - SearchFor = table of string or nil --table will be compared to current user input and if all compares are true a responce will most likely be chosen from this  
 - PriorSearchFor = table of string or nil --table will be compared to the user input before the current user input  
 - EmotionChange = table of two numbers or nil --table values will be added to current emotion level  
 - emotionappend/AppendEmotionStatment = bool or nil --false will result in it never being able to express emotion with how it ends a output if its responce comes from here  
 - Annoyable = bool or nil --false will make so you cant annoy it if its respone is coming from this infos responces  
 - Importance = number or nil --the higher this number is the more of a chance you have of this responce being selected over other responces
 - Responces = table of string or nil --one of the string will be retuned to the player as a responce it may also be modifyied on the return trip
 - SubInfo = table of infomation nil --run pal:ReturnInfo() in here to put info into the sub info table and the sub info will be added to the Info_Database if a respoce is selected from the info it's contained in  
 - Append/AppendAllResponcesWith = string or nil --if string string will be added to the end of all responce useful for running functions
 - ID anything or nil --if it is someting it can be search out of the Info_Database using the functions below

You can also seach for infomation in the Info_Database using the id tag at the end and one the functions below:
```
pal:GetInfoById( ID ) --will return table of all info with that id
pal:GetInfoIndexById( ID ) --will return table of all index belonging to all the info with that id
pal:GetInfoByIndex( Index ) --will return the info with that index in the Info_Database
```
However using these functions will only return copyies of the infomation so to modify the origional info you should use:
```
pal["Info_Database"][pal:GetInfoIndexById( ID )[1]].WhatUWantToChage = value
pal["Info_Database"][pal:GetInfoIndexById( ID )[1]].SearchFor[#pal["Info_Database"][pal:GetInfoIndexById( ID )[1]]["SearchFor"]] = nil --deleats the last search for requirment
```
examples of info:

```
-- normal info -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
pal:SetNewInfo( {"|pal:NRT( 'hi' )|","|pal:NRT( 'hello' )|"}, nil, nil, nil, nil, nil, {"Hi.","Hi user.","Hello","Hello user."}, nil, nil, nil )
pal:SetNewInfo( {"you","|pal:NRT( 'alive' )|","|pal:NRT( 'living' )|","|pal:NRT( 'real' )|"}, nil, {-0.70,0}, nil, nil, 0, {"No I am not really alive |pal:GetEmotiveWord()| user.","Sadly I do not live |pal:GetEmotiveWord()| user.","I am not alive.","I am not living."}, nil, nil, nil )

-- nested info -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
pal:SetNewInfo( {"i","|pal:NRT( 'alive' )|","|pal:NRT( 'living' )|","|pal:NRT( 'real' )|"}, {}, {-0.70,0}, nil, nil, 0, {"Most likely user.","Yes you are alive user.","I do belive you are alive","yes althogth you could be in a simulation which would in my mind make you less alive",}, {
pal:ReturnInfo( {"what","|pal:NRT( 'likely' )|"}, {"i","|pal:NRT( 'alive' )|","|pal:NRT( 'living' )|","|pal:NRT( 'real' )|"}, nil, nil, nil, nil, {"You may be in a simulaition.","Your world may be in a simulation.","This world may be in a simulator.",}, {}, nil, nil ),
pal:ReturnInfo( {"what","|pal:NRT( 'simulation' )|"}, nil, nil, nil, nil, nil, {"This wrold could be as real as a video game and you would never know.","What if everything you know is in a video game using a lot of next next gen tech like unreal 5 but better and you wouldnt know if it was fake.","you might be in a video game and if so you would never know as the memories could be programmed out of you."}, nil, nil, nil ),
}, nil, nil ) --the return info is for info that should only be visible after the question at the top is asked
```

## functions in infomation
To put a function into infomation it is very simple all you have to do is type the function as if your were exacuteing it into a string in the responces table or in one of the searchfor tables you then need to wrap it in the function key(|) like so "|CunkOnEarthPumpUpTheJam( 'this is cunk on earth' )|" and it will run however in the searchfor tables the function keys have to be at both ends of any given string and a bool must be returned and if this bool is false then all responce from this infomation will not be allowed to be returned to the user.

Also in the responce table if a string is returned from a function then that string will be made to repace the area the funtion took up otherwise the area will be replace with an empty string. 

functions you can use in the search for tables:  
 - pal:NRT( Tag ) --it will always return true but if the string in the function can not be found (or if its a bool it dosent equal true) the odds that a responce is selected from the info this is in are lowered  
 - pal:MWTG( ID ) --compares the player input aginst all info in a tag group(pal:AddNewTagGroup( "taggroupexample", {"wow"} )) and will retun false if a match can not be found  
 - pal:EmotionLevelEquals( EmotionTbl ) --dose the emotion level x and y = the tbls x and y  
 - pal:EmotionLevelNotEquals( EmotionTbl ) --the reverse of the above  
 - pal:EmotionLevelEqualsOr( endless input range of tables ) --dose the emotion level x and y = any of the tables x and y  
 - EmotionLevelNotEqualsOr( endless input range of tables ) --dose the emotion level x and y not equal all of the tables x and y

functions you can use in responces/append:
 - pal:MemGen( name, PronownTable ) --assoaties a name the ai said to pronowns wich is then save into a shortterm memory and then you can use the prownowns to refence that person for a short time 
 - DegradeInfoOverXCycles( ID, CyclesInfoStayesInMemory ) --deletes all info with an id after the seconds in cyclesinfostayesinmemory has elapsed  
 - pal:GetEmotiveWord() --gets a word the ai thinks of when it thinks of the user  
 - pal:GetEmotiveClass() --how it is feeling in genral
 - pal:SetPriorInput( Text ) --you can chage the prior input to whatever you want which is what the searchfor_prior gose through

## IDK responces

If pal is for whatever reason is not able to tie what you are saying to some info or if the probablity of a responce being selected is the same for all responces in all infomation then it retuns IDK responce.

IDK responces stand for I dont know (what this use is say i absolutely can not make any sence of this) responces anyhow you can create idk respnces like so:

```
pal:SetNewIDKresponces( "I dont know text here" )
```

# how to deal with emotion and annoyance

## emotions basics
To first create an emotion you need to set up the emotion grid and you can do this by running the function build emotion grid winth a size in your loads file but by default the emotion grid size is 3 which results in nine tiles but if you wish pal could do a better job at expressing emotion you should make this bigger.  

once you have yor emotion grid you can map emotions onto it using:
```
pal:AddNewEmotion( gridlocation, emotivewords, wordsthatmaketheaifeelmorelikethis, emotionclass, sentanceappending )
```
as for what the values mean they mean:
 - gridlocation = table of two numbers (NO DECIMALS) -- the emotions grid location and every spot of the grid must have an emotion  
 - emotivewords = table of strings --words it uses to describe the user and these strings are also added to wordsthatmaketheaifeelmorelikethis
 - wordsthatmaketheaifeelmorelikethis = table of strings --useful for sware words  
 - sentanceappending = table of strings --how it will end a sentance if it is feeling like this

 Also set emotive gravity is used to set the AIs main emotion and its attractive power to that emotion/how fast it gose back to it's main emotion and pal:SetEmotiveWordPower() is for how strongly it responds to be swared at.

## annoyance
For the annoyance section there are two annoyance levels.
Level one is for text that can be attatched to and end of a responce to repasent it is getting annoyed about you asking the same question over and over again.
Level two is for text that can replace the responce once the same question has been asked to many times.

```
pal:SetNewAnnoyanceRespoces( level, responceasstring )
```
Is also what you use to add annoyance responces.

The max annoyance amount can also be changed with:
```
pal:SetMaxAnnoyanceAmount( number )
```

# how to make good AIs

## what makes a good AI
A good publicAI ai has has lots of responces and uses add new synonyms group also good AIs also have a lot of spellchecking data as well as usage of all the functions made for the searchfor and responces tables. Good AIs in genral are also capable of being good emotional support and of being cold when you are mean to them and good AIs should also claim to have there own wants or needs if used for a video game or so other purpose that gose beyond the realm of a text input.

## why you should use the tool and how to use the tools
This AI system come with a set of tools that allows you to make AIs really fast and it also makes your AI much smarter which makes the tools very important and useful to AI development with public AI. A list of these tools (in the order they should most likely be used) is bellow:

 - InfoAdded --give it two files one a list of questions and two a place to put the result and it will use the first file to scrape awnser off the internet and once it is done it will all be formatted to infomation pal can understand and then put into the results file also this is the only thing to use c#  
 - WordExtractor --extracts words from pal info files (this is useful for the spellchecker)
 - SpellingEnhancement --generates most of the possible missspellings for a list of words and then outputs the results to a file as pal spellchecking data which makes AIs better at understanding english 
 - SynonymsGrouping --give it a list of synonyms and it will output a synonyms file in pal data and it can also modify infomodel file data to use those synonyms which makes AIs seem more dynamic in there responces 
 - SynonymsListCreator --converts a list of words to a list of Synonyms (SYNONYM LISTS MADE WITH THIS SHOULD BE CHECKED OVER BY A HUMAN FOR SYNONYMS THAT DONBT WORK IN EVERY SECNARIO AS THE GROUPING TOOL WORKS REGUARDLESS OF CONTEXT)

Also you should open the source code of the tools to get a better uderstanding of what its for and what files it should be used with and changeing thoese file should you need to.

## why you should use fuctions in tags and responce
Using functions allows for you to make some really cool additions to you AI for example you can do something like:

```
pal:SetNewInfo( {"you","|pal:NRT( 'feel' )|","|pal:NRT( 'feeling' )|","|pal:NRT( 'doing' )|","|pal:NRT( 'holding' )|"}, nil, nil, nil, nil, nil, {"I am feeling |pal:GetEmotiveClass()|.","I feel like I am |pal:GetEmotiveClass()|.","I am feeling |pal:GetEmotiveClass()| user.","I feel like I am |pal:GetEmotiveClass()| user."}, nil, nil, nil )
pal:SetNewInfo( {"|pal:EmotionLevelEqualsOr( {3,3}, {2,3}, {3,2} )|","you","|pal:NRT( 'like' )|","|pal:NRT( 'enjoy' )|","me",}, nil, nil, false, nil, nil, {"Yer I like talking to you user.","It is nice to have you around.","It is nice to have you around user.","i do enjoy our talking."}, nil, nil, nil )
pal:SetNewInfo( {"|pal:EmotionLevelNotEqualsOr( {3,3}, {2,3}, {3,2} )|","you","|pal:NRT( 'like' )|","|pal:NRT( 'enjoy' )|","me",}, nil, {-0.70,-0.20}, nil, nil, nil, {"I do not like you at the moment.","No","No user.","I don't like you.","I don't like you user.","What do you think.","What do you think user."}, nil, nil, nil )
pal:SetNewInfo( {"|pal:EmotionLevelEqualsOr( {3,3}, {2,3}, {3,2} )|","you","|pal:NRT( 'hate' )|","|pal:NRT( 'dislike' )|","|pal:NRT( 'loth' )|","me",}, nil, nil, false, nil, nil, {"No no no not at all","Hevens no.","I do not dislike you user.","No I do like you.","No I do like you user."}, nil, nil, nil )
pal:SetNewInfo( {"|pal:EmotionLevelNotEqualsOr( {3,3}, {2,3}, {3,2} )|","you","|pal:NRT( 'hate' )|","|pal:NRT( 'dislike' )|","|pal:NRT( 'loth' )|","me",}, nil, {-0.70,-0.20}, nil, nil, nil, {"Yep","Yes","Correct mr annoying","spot on"}, nil, nil, nil )
pal:SetNewInfo( {"|pal:EmotionLevelEqualsOr( {3,3}, {2,3}, {3,2} )|","why"}, {"you","me",}, nil, false, nil, nil, {"Because you have not upset me.","Your ok to talk to.","Your not being mean to me.","your kind."}, nil, nil, nil )
pal:SetNewInfo( {"|pal:EmotionLevelNotEqualsOr( {3,3}, {2,3}, {3,2} )|","why"}, {"you","me",}, nil, {-0.70,-0.20}, nil, nil, {"Because you said something to upset me.","Because you reminded me of something bad.","Because yor are a |pal:GetEmotiveWord()| user."}, nil, nil, nil )
```

To get the AI to respond to how it's feeling in a way that is much more realistic and much more like a human you should also use fulctions like:
```
pal:GetEmotiveWord()
pal:GetEmotiveClass()
```

You can better simulate branching covos path by using set prior input which becomes really good when your ai gets massive and you should also use mem gen for anything related to people as it can make your ai seam really good if it can assocaite prownouns to people.

## how to structer huge AIs
Structure infomation files like how it is done below if you want the AI to be fast or contain a huge volume of information:
huge volume > 2000

```
SetNewSelfHook( "PALOnRunSpellCheck", "RANDOMNAME", function( input )
pal:LoadRestorePoint() --RESTORE THE AI TO BEFORE ANYTHING WAS ADDED EFFECTIVLY REMOVEING ALL THE INFORMATION BELOW SO THAT IT OR SOMETHING ELSE CAN BE ADDED AGAIN
pal:LoadInfo() --loads all save data
if string.find( input, "who", 1, true ) ~= nil then
--QUESTION INFO
end
if string.find( input, "what", 1, true ) ~= nil then
--QUESTION INFO
end
if string.find( input, "you", 1, true ) ~= nil then
--OPIOION INFO
   end
end)
```

 Also some genral advice for huge or small AIs is to nest info where possible and use DegradeInfoOverXCycles to remove it as it can really help to optamize an AI with this.
# using

you can feel free to use any of the code in this project as long as you credit the account BobBobson21
