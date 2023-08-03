# how to use pal
look at the comments in the pal_ai_main.lua to understand how most of the systems work.

look at the loads file to add your own files to the AI.

the modual folder should contain things like learning code and running maths code and infomation should contain all of the data/memoryies it has and emotion should contain the emotions it simulates.

structure infomation files like how it is done below if you want the AI to be fast or contain a huge volume of information:
huge volume > 5000


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
 
# using

you can feel free to use any of the code in this project as long as you credit the account BobBobson21
