pause = false
--window heigth
wh = 0
--window width
ww = 0
--backgroundcolor
bgc = {
  r = 0,
  g = 0,
  b = 0
  }
player = {
  x = 0,
  y = 0,
  h = 0,
  w = 0,
  points = 0,
  color = {
    r = 0,
    g = 0,
    b = 0
    }
}
--player horizontal velocity
phv = 400
boxes = {}
--box down velocity
bdv = 200
--pointsmultiplier
pointsmult = 0
--tempo entre caixas
boxcooldown = 0
boxcooldowmin = 0
boxcdreduce = 0
spawnbox = 0
function love.load()
  wh = love.graphics.getHeight()
  ww = love.graphics.getWidth()
  --backgroundcolor
  bgc = {
  r = 0,
  g = 0,
  b = 0
  }
  --segundos
  boxcooldown = 3
  boxcooldowmin = 1.5
  boxcdreduce = 0.02
--points multiplier
  pointsmult = 100
  
  player.h = 20
  player.w = 100
  player.points = 0
  player.x = ww/2
  player.y = wh - 100
  player.color = {
    r = 255,
    g = 255,
    b = 255
    }
end

function removebox(oldboxes, boxtodelete)
 newboxes = {}
 i = 1
 for b = 1 + boxtodelete, #oldboxes do
      newboxes[i] = oldboxes[b]
      i = i + 1
  end
  return newboxes 
end

function boxcolision(x1,y1,w1,h1,x2,y2,w2,h2) 
  return x1 < x2+w2 and x2 < x1+w1 and y1 < y2+h2 and y2 < y1+h1
end

function love.update(dt)
  if love.keyboard.isDown("return") then
    pause = false
  end
  if love.keyboard.isDown("escape") then
    pause = true
  end
  if pause then return end
  
  if boxcooldown > boxcooldowmin then
    boxcooldown = boxcooldown - boxcdreduce * dt
  end
  --desce todas caixas
  --box to delete
  bd = 0
  for i = 1, #boxes do
      boxes[i].y = boxes[i].y + bdv * dt
      --verifica se alguma bateu no player
    if boxcolision(boxes[i].x,boxes[i].y,boxes[i].w,boxes[i].h,player.x,player.y,player.w,player.h) then
      bd = bd + 1
      player.points = player.points + 1 * pointsmult
      
      colorchangeR = love.math.random(0,150)
      colorchangeG = love.math.random(0,150)
      colorchangeB = love.math.random(0,150)
      bgc = {
          r = 255 - colorchangeR,
          g = 255 - colorchangeG,
          b = 255 - colorchangeB
        }      
      
      colorchangeR = love.math.random(0,150)
      colorchangeG = love.math.random(0,150)
      colorchangeB = love.math.random(0,150)
      player.color = {
          r = 255 - colorchangeR,
          g = 255 - colorchangeG,
          b = 255 - colorchangeB
        }
      
    end
  end
  boxes = removebox(boxes,bd)
  
  --verifica se a primeira saiu da tela
  if(#boxes > 0 and boxes[1].y > wh) then 
    player.points = player.points - 2 * pointsmult
    boxes = removebox(boxes,1)
    player.color = {
    r = 255,
    g = 255,
    b = 255
  }
    bgc = {
  r = 0,
  g = 0,
  b = 0
  }
  end
  
  --movimentacao personagem
  --mover esquerda
  if((love.keyboard.isDown("a") or love.keyboard.isDown("left")) and player.x > 0) then
    player.x = player.x - phv * dt
    if player.x < 0 then
      player.x = 0
    end
  end
  --mover direita
  if((love.keyboard.isDown("d") or love.keyboard.isDown("right")) and player.x < ww-player.w) then
    player.x = player.x + phv * dt
    if player.x > ww - player.w then
      player.x =  ww - player.w
    end
  end
  
  --Criar caixas
  spawnbox = spawnbox - 1 * dt
  if spawnbox < 0 then
    width = love.math.random(20,60)
    height = love.math.random(20,60)
    colorchangeR = love.math.random(0,150)
    colorchangeG = love.math.random(0,150)
    colorchangeB = love.math.random(0,150)
    box = {
      x = love.math.random(0,ww - width),
      y = 0 - height,
      w = width,
      h = height,
      color = {
        r = 255 - colorchangeR,
        g = 255 - colorchangeG,
        b = 255 - colorchangeB
      }      
    }
    table.insert(boxes, box)
    spawnbox = love.math.random(boxcooldown - 0.5,boxcooldown + 0.5) 
  end
end
function love.draw()
  if #boxes > 0 then
    for i = 1, #boxes do
      love.graphics.setColor(boxes[i].color.r,boxes[i].color.g,boxes[i].color.b)
      love.graphics.rectangle("fill",boxes[i].x,boxes[i].y,boxes[i].w,boxes[i].h)
    end
  end
  love.graphics.setColor(player.color.r,player.color.g,player.color.b)
  love.graphics.rectangle("fill",player.x,player.y,player.w,player.h)
  
  love.graphics.setBackgroundColor(bgc.r,bgc.g,bgc.b)
  
  love.graphics.print(player.points,0,0,0,3,3)
  if pause then
  love.graphics.print("Pausado, pressione enter para retornar!",0,40)
  end
end
