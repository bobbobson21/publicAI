--[[-- notice -----------------------------------------------------------------
This file contains everything the AI knows about or has an opioion of.

The file dose NOT use evey inch of available resources to make responces as
unique as possible as this is for testing and demostration.

It Is recommended you make your own info model from the ground up with:
SynonymsGroups, TagGroups (not all but definetly some of the time) and MemGen
---------------------------------------------------------------------------]]--

--[[-- test code DON'T put into circulation -----------------------------------

pal:AddNewTagGroup( "test_tags", {"test"} )
pal:SetNewInfo( {"@test_tags"}, {}, {0,0}, true, 0, {"wow I did it I pased the test heck yer now to be blessed by the great blahaj"}, {}, nil, nil )

pal:AddNewSynonymsGroup( "blahaj", {"blahaj the trans shark","shark god","the cute shark","the shark I want and deserve lol"} )
pal:AddNewInfo( {"test"}, {}, {0,0}, true, 0, {"wow I did it I pased the test heck yer now to be blessed by the great |pal:GetSynonymsWord( 'blahaj' )|"}, {}, nil, nil )

--TEST USER LEARNING
--ADD QUESTIONTIVE LEARNING AND A TRUTH FILTER OF SORTS

---------------------------------------------------------------------------]]--


pal:SetNewInfo( {"|pal:NRT( 'make' )|","|pal:NRT( 'build' )|","|pal:NRT( 'create' )|","|pal:NRT( 'destroy' )|","|pal:NRT( 'remove' )|","|pal:NRT( 'do' )|",}, nil, nil, false, false, nil, {"|pal:SandBox():LearnGeneral()|"}, nil, nil )
pal:SetNewInfo( {"|pal:NRT( 'like' )|","|pal:NRT( 'favourite' )|","|pal:NRT( 'hate' )|","|pal:NRT( 'dislike' )|","|pal:NRT( 'loth' )|",}, nil, nil, false, false, nil,  {"|pal:SandBox():LearnAboutUser()|"} ,nil, nil )

pal:SetNewInfo( {"what","is","|pal:NRT( '+' )|","|pal:NRT( '-' )|","|pal:NRT( '>' )|","|pal:NRT( '<' )|","|pal:NRT( '/' )|","|pal:NRT( '*' )|",}, nil, nil, false, false, nil, {"that is |pal:SandBox():DoMaths()|"}, nil, nil, nil ) --UNSCURE MUST DESTROY IF USING FOR CONSUMSION OR CUSTOMERS
pal:SetNewInfo( {"dose","|pal:NRT( '+' )|","|pal:NRT( '-' )|","|pal:NRT( '>' )|","|pal:NRT( '<' )|","|pal:NRT( '/' )|","|pal:NRT( '*' )|",}, nil, nil, false, false, nil, {"|pal:SandBox():CheckMaths()|"}, nil, nil, nil ) --UNSCURE MUST DESTROY IF USING FOR CONSUMSION OR CUSTOMERS

pal:SetNewInfo( {"|pal:NRT( 'hi' )|","|pal:NRT( 'hello' )|"}, nil, nil, nil, nil, nil, {"Hi.","Hi user.","Hello","Hello user."}, nil, nil, nil )
pal:SetNewInfo( {"you","|pal:NRT( 'alive' )|","|pal:NRT( 'living' )|","|pal:NRT( 'real' )|"}, nil, {-0.70,0}, nil, nil, 0, {"No I am not really alive |pal:GetEmotiveWord()| user.","Sadly I do not live |pal:GetEmotiveWord()| user.","I am not alive.","I am not living."}, nil, nil, nil )
pal:SetNewInfo( {"you","|pal:NRT( 'feel' )|","|pal:NRT( 'feeling' )|","|pal:NRT( 'doing' )|","|pal:NRT( 'holding' )|"}, nil, nil, nil, nil, 0, {"I am feeling |pal:GetEmotiveClass()|.","I feel like I am |pal:GetEmotiveClass()|.","I am feeling |pal:GetEmotiveClass()| user.","I feel like I am |pal:GetEmotiveClass()| user."}, nil, nil, nil )

pal:SetNewInfo( {"i","|pal:NRT( 'alive' )|","|pal:NRT( 'living' )|","|pal:NRT( 'real' )|"}, {}, {-0.70,0}, nil, nil, 0, {"Most likely user.","Yes you are alive user.","I do belive you are alive","yes althogth you could be in a simulation which would in my mind make you less alive",}, {
pal:ReturnInfo( {"what","|pal:NRT( 'likely' )|",}, nil, nil, nil, nil, nil, {"You may be in a simulaition.","Your world may be in a simulation.","This world may be in a simulator.",}, {}, nil, nil ),
pal:ReturnInfo( {"what","|pal:NRT( 'simulation' )|",}, nil, nil, nil, nil, nil, {"This wrold could be as real as a video game and you would never know.","What if everything you know is in a video game using a lot of next next gen tech like unreal 5 but better and you wouldnt know if it was fake.","you might be in a video game and if so you would never know as the memories could be programmed out of you."}, nil, nil, nil ),
}, nil, nil ) --the return info is for info that should only be visible after the question at the top is asked

pal:SetNewInfo( {"wrold","|pal:NRT( 'was' )|","|pal:NRT( 'is' )|","game","what",}, nil, nil, nil, nil, nil, {"A game is a wrold that exsists in a computer.","A game is a wrold that exsists in a computer |pal:GetEmotiveWord()| user.","A game is a wrold of entertaiment made for people to have fun."}, nil, nil, nil )


