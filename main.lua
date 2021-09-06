function love.load()
  WIDTH = 800
  HEIGHT = 600
  VEL = 250

  -- pad constants
  pad_h = 50
  pad_w = 10

  -- setup p1
  x = pad_w
  y = HEIGHT / 2 - (pad_h / 2)
  vel = 0
  p1_up = "w"
  p1_down = "s"

  -- setup p2
  p2x = WIDTH - pad_w*2
  p2y = HEIGHT / 2 - (pad_h / 2)
  p2vel = 0
  p2_up = "up"
  p2_down = "down"
  
  -- setup ball
  bx = WIDTH/2-5
  by = HEIGHT/2-5
  b_rad = 7
  bvelx = VEL
  bvely = 0

  -- setup wind
  love.window.setTitle("Pong")
  love.window.setMode(WIDTH, HEIGHT)

  -- setup scores
  p1_score = 0
  p2_score = 0
end

function love.draw()
  love.graphics.print(p1_score, 2, 2)
  love.graphics.print(p2_score, WIDTH-10, 2)
  love.graphics.rectangle("fill", x, y, pad_w, pad_h)
  love.graphics.rectangle("fill", p2x, p2y, pad_w, pad_h)
  love.graphics.circle("fill", bx, by, b_rad)
end

function love.update(dt)

  move_p1(dt)
  move_p2_human(dt)
  update_ball(dt)

  check_scored()

  if (love.keyboard.isDown("escape")) then
    love.window.close()
    love.event.quit(0)
  end
end

function move_p1(dt)

  if (love.keyboard.isDown(p1_up)) then
    vel = VEL * -1
  elseif (love.keyboard.isDown(p1_down)) then
    vel = VEL
  else
    vel = 0
  end

  y = y + vel * dt
  if (y < 0) then y = 0 end
  if (y+pad_h > HEIGHT) then y = HEIGHT - pad_h end
end

function move_p2_human(dt)
  if (love.keyboard.isDown(p2_up)) then
    p2vel = VEL * -1
  elseif (love.keyboard.isDown(p2_down)) then
    p2vel = VEL
  else
    p2vel = 0
  end
  p2y = p2y + p2vel * dt
  if (p2y < 0) then p2y = 0 end
  if (p2y+pad_h > HEIGHT) then p2y = HEIGHT - pad_h end
end

function update_ball(dt)
  if (by-b_rad <= 0 or by+b_rad >= HEIGHT) then
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
    print("p1 collision")
  end

  if (p2_collided(p2x, p2y, pad_w, pad_h, bx, by, b_rad)) then
    bvelx = bvelx * -1
    if (p2vel > 0) then
      bvely = math.abs(bvely)
      bvely = bvely + p2vel
    elseif (p2vel < 0) then
      bvely = math.abs(bvely) * - 1
      bvely = bvely + p2vel
    end
    print("p2 collision")
  end


  bx = bx + bvelx * dt
  by = by + bvely * dt
end

function check_scored()
  if (bx-b_rad < x ) then
    score_p2()
  elseif (bx+b_rad > p2x+pad_w) then
    score_p1()
  end
end

function score_p1()
  bx = WIDTH/2
  by = HEIGHT/2
  bvely = 0
  bvelx = VEL
  p1_score = p1_score + 1
  print(string.format("p1 scored: %d", p1_score))
end

function score_p2()
  bx = WIDTH/2
  by = HEIGHT/2
  bvely = 0
  bvelx = -1 * VEL
  p2_score = p2_score + 1
  print(string.format("p2 scored: %d", p2_score))
end

-- helper
function p1_collided(px, py, pw, ph, bx, by, br)
  return bx-br <= px+pw and by+br >= py and by-br <= py+ph
end

function p2_collided(px, py, pw, ph, bx, by, br)
  return bx+br >= px and by+br >= py and by-br <= py+ph
end

