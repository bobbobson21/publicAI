--[[-- notice -----------------------------------------------------------------
This file contains everything the AI know about or has an opioion of.

The file dose NOT evey inch of available resources to make responces as unique
as possible as this is for testing and demostration.

It Is recommended you make your own info model from the ground up.
---------------------------------------------------------------------------]]--

--[[-- test code DON'T put into circulation -----------------------------------
--test tag groups
--test SetNewSynonymsGroup
--test emotion class
---------------------------------------------------------------------------]]--


pal:SetNewInfo( {"what","is","|pal:NRT( '+' )|","|pal:NRT( '-' )|","|pal:NRT( '>' )|","|pal:NRT( '<' )|","|pal:NRT( '/' )|","|pal:NRT( '*' )|",}, {}, {0,0}, false, 0, {"that is |pal:Sandbox():DoMaths()|"}, {}, nil, nil ) --UNSCURE MUST DESTROY IF USING FOR CONSUMSION OR CUSTOMERS
pal:SetNewInfo( {"dose","|pal:NRT( '+' )|","|pal:NRT( '-' )|","|pal:NRT( '>' )|","|pal:NRT( '<' )|","|pal:NRT( '/' )|","|pal:NRT( '*' )|",}, {}, {0,0}, false, 0, {"|pal:Sandbox():CheckMaths()|"}, {}, nil, nil ) --UNSCURE MUST DESTROY IF USING FOR CONSUMSION OR CUSTOMERS

pal:SetNewInfo( {"|pal:NRT( 'hi' )|","|pal:NRT( 'hello' )|"}, {}, {0,0}, true, 0, {"Hi.","Hi user.","Hello","Hello user."}, {}, nil, nil )
pal:SetNewInfo( {"you","|pal:NRT( 'alive' )|","|pal:NRT( 'living' )|","|pal:NRT( 'real' )|"}, {}, {-0.70,0}, true, 0, {"No I am not really alive |pal:GetEmotiveWord()| user.","Sadly I do not live |pal:GetEmotiveWord()| user.","I am not alive.","I am not living."}, {}, nil, nil )

pal:SetNewInfo( {"i","|pal:NRT( 'alive' )|","|pal:NRT( 'living' )|","|pal:NRT( 'real' )|"}, {}, {-0.70,0}, true, 0, {"Most likely user.","Yes you are alive user.","I do belive you are alive","yes althogth you could be in a simulation which would in my mind make you less alive",}, {
pal:ReturnInfo( {"what","|pal:NRT( 'likely' )|",}, {}, {0,0}, true, 0, {"You may be in a simulaition.","Your world may be in a simulation.","This world may be in a simulator.",}, {}, nil, nil ),
pal:ReturnInfo( {"what","|pal:NRT( 'simulation' )|",}, {}, {0,0}, true, 0, {"This wrold could be as real as a video game and you would never know.","What if everything you know is in a video game using a lot of next next gen tech like unreal 5 but better and you wouldnt know if it was fake.","you might be in a video game and if so you would never know as the memories could be programmed out of you."}, {}, nil, nil ),
}, nil, nil ) --the return info is for info that should only be visible after the question at the top is asked

pal:SetNewInfo( {"wrold","|pal:NRT( 'was' )|","|pal:NRT( 'is' )|","game","what",}, {}, {0,0}, true, 0, {"A game is a wrold that exsists in a computer.","A game is a wrold that exsists in a computer |pal:GetEmotiveWord()| user.","A game is a wrold of entertaiment made for people to have fun."}, {}, nil, nil )


