local sounds = {}

function loadSounds()
  sounds['collision'] = love.audio.newSource("assets/sounds/rebound.wav", "static")
  sounds['gameOver'] = love.audio.newSource("assets/sounds/lost.wav", "static")
end

function playSound(sound_name)
  local clone = sounds[sound_name]:clone()
  clone:play()
end

