-- Gestion des entrées clavier
function love.keypressed(key)
   if key == "p" then
        GameState.isPaused = not GameState.isPaused  -- Inverser l'état de pause
        print("Pause toggle: ", GameState.isPaused)  -- Vérifier avec un print
    end

    if not GameState.isPaused then 
      if key == "space" then
        jump()
      end
    end
end

function love.keyreleased(key)
    -- Cette fonction est appelée quand une touche est relâchée
end

-- Gestion des événements de la souris
function love.mousepressed(x, y, button, istouch, presses)
    -- Cette fonction est appelée quand un bouton de la souris est pressé
end

function love.mousereleased(x, y, button, istouch, presses)
    -- Cette fonction est appelée quand un bouton de la souris est relâché
end