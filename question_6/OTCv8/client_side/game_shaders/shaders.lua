// Not implemented by me. Please read `Process.txt` #Question 6

function init()
  -- add manually your shaders from /data/shaders

  -- map shaders
  g_shaders.createShader("map_default", "/shaders/map_default_vertex", "/shaders/map_default_fragment")  

  -- use modules.game_interface.gameMapPanel:setShader("map_rainbow") to set shader

  -- outfit shaders
  g_shaders.createOutfitShader("outfit_default", "/shaders/outfit_default_vertex", "/shaders/outfit_default_fragment")
  g_shaders.createOutfitShader("red_outline", "/shaders/outline_vertex", "/shaders/outline_red_fragment")

  -- you can use creature:setOutfitShader("outfit_rainbow") to set shader

end

function terminate()
end


