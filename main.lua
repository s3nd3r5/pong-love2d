function love.load()
  WIDTH = 800
  HEIGHT = 600
  VEL = 250


  pad_h = 50
  pad_w = 10
  x = 10
  y = HEIGHT / 2 - (pad_h / 2)
  vel = 0
  
  bx = WIDTH/2-5
  by = HEIGHT/2-5
  b_rad = 7
  bvelx = VEL
  bvely = 0
  love.window.setTitle("Pong")
  love.window.setMode(WIDTH, HEIGHT)
end

function love.draw()
  love.graphics.rectangle("fill", x, y, pad_w, pad_h)
  love.graphics.circle("fill", bx, by, b_rad)
end

function love.update(dt)

  move_p1(dt)
  update_ball(dt)

  if (love.keyboard.isDown("escape")) then
    love.window.close()
    love.event.quit(0)
  end
end

function move_p1(dt)

  if (love.keyboard.isDown("up")) then
    vel = VEL * -1
  elseif (love.keyboard.isDown("down")) then
    vel = VEL
  else
    vel = 0
  end
  
  y = y + vel * dt
  if (y < 0) then y = 0 end
  if (y+pad_h > HEIGHT) then y = HEIGHT - pad_h end

end

function update_ball(dt)
  if (bx <= 0 or bx >= WIDTH) then
    bvelx = bvelx * -1
  end

  if (by <= 0 or by >= HEIGHT) then
    bvely = bvely * -1
  end

  if (p1_collided(x, y, pad_w, pad_h, bx, by, b_rad)) then
    bvelx = bvelx * -1
    if (vel > 0) then
      bvely = math.abs(bvely)
      bvely = bvely + vel
    elseif (vel < 0) then
      bvely = math.abs(bvely) * - 1
      bvely = bvely + vel
    end
    print("collision")
  end

  bx = bx + bvelx * dt
  by = by + bvely * dt
end

function p1_collided(px, py, pw, ph, bx, by, br)
  return bx-br <= px+pw and by+br >= py and by-br <= py+ph
end

function p2_collided(px, py, pw, ph, bx, by, br)
  return false
end
