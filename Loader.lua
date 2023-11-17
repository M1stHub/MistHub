if game.PlaceId == 10595058975 then
    if getgenv().Test == true then
        loadstring(game:HttpGet("https://raw.githubusercontent.com/xAentix/MistHub/main/ArcaneLineageTest.lua", true))()
    else
        loadstring(game:HttpGet("https://raw.githubusercontent.com/xAentix/MistHub/main/ArcaneLineage.lua", true))()
    end
else
    game.Players.LocalPlayer:Kick("Game not supported")
end
