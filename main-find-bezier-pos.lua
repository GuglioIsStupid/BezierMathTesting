-- Finding the x position from the y on a bezier curve

-- bezier going top to bottom curve
local pointsX = {100, 200, 300, 400, 500, 600, 700, 800}
local pointsY = {100, 200, 300, 400, 500, 400, 300, 200}
local points = {}
for i = 1, #pointsX do
    table.insert(points, pointsX[i])
    table.insert(points, pointsY[i])
end
local curve = love.math.newBezierCurve(points)

function findXFromY(curve, y)
    local x = 0
    local y1 = 0
    local y2 = 0
    local x1 = 0
    local x2 = 0
    local t = 0
    local maxT = 1
    local step = 0.01
    local precision = 0.001
    local maxIterations = 1000
    local iterations = 0
    local found = false
    while not found and iterations < maxIterations do
        iterations = iterations + 1
        t = t + step
        if t > maxT then
            t = maxT
        end
        x1, y1 = curve:evaluate(t - step)
        x2, y2 = curve:evaluate(t)
        if not x1 or not x2 or not y1 or not y2 then
            return curve:evaluate(maxT)
        end
        if y1 <= y and y2 >= y or y1 >= y and y2 <= y then
            found = true
        end
    end
    if iterations == maxIterations then
        return curve:evaluate(maxT)
    end
    return x1 + (x2 - x1) * (y - y1) / (y2 - y1)
end

function findYFromX(curve, x)
    local y = 0
    local y1 = 0
    local y2 = 0
    local x1 = 0
    local x2 = 0
    local t = 0
    local maxT = 1
    local step = 0.01
    local precision = 0.001
    local maxIterations = 1000
    local iterations = 0
    local found = false
    while not found and iterations < maxIterations do
        iterations = iterations + 1
        t = t + step
        if t > maxT then
            t = maxT
        end
        x1, y1 = curve:evaluate(t - step)
        x2, y2 = curve:evaluate(t)
        if not x1 or not x2 or not y1 or not y2 then
            return curve:evaluate(maxT)
        end
        if x1 <= x and x2 >= x or x1 >= x and x2 <= x then
            found = true
        end
    end
    if iterations == maxIterations then
        return curve:evaluate(maxT)
    end
    return y1 + (y2 - y1) * (x - x1) / (x2 - x1)
end

function findXOnCubicBezier(curve, x)
    local y = 0
    local y1 = 0
    local y2 = 0
    local x1 = 0
    local x2 = 0
    local t = 0
    local maxT = 1
    local step = 0.01
    local precision = 0.001
    local maxIterations = 1000
    local iterations = 0
    local found = false
    while not found and iterations < maxIterations do
        iterations = iterations + 1
        t = t + step
        if t > maxT then
            t = maxT
        end
        x1, y1 = curve:evaluate(t - step)
        x2, y2 = curve:evaluate(t)
        if not x1 or not x2 or not y1 or not y2 then
            return curve:evaluate(maxT)
        end
        if x1 <= x and x2 >= x or x1 >= x and x2 <= x then
            found = true
        end
    end
    if iterations == maxIterations then
        return curve:evaluate(maxT)
    end
    return x1 + (x2 - x1) * (x - x1) / (x2 - x1)
end

function findYOnCubicBezier(curve, x)
    local y = 0
    local y1 = 0
    local y2 = 0
    local x1 = 0
    local x2 = 0
    local t = 0
    local maxT = 1
    local step = 0.01
    local precision = 0.001
    local maxIterations = 1000
    local iterations = 0
    local found = false
    while not found and iterations < maxIterations do
        iterations = iterations + 1
        t = t + step
        if t > maxT then
            t = maxT
        end
        x1, y1 = curve:evaluate(t - step)
        x2, y2 = curve:evaluate(t)
        -- if any are nil, then we're out of the curve
        if not x1 or not x2 or not y1 or not y2 then
            return curve:evaluate(maxT)
        end
        if x1 <= x and x2 >= x or x1 >= x and x2 <= x then
            found = true
        end
    end
    if iterations == maxIterations then
        return curve:evaluate(maxT)
    end
    return y1 + (y2 - y1) * (x - x1) / (x2 - x1)
end

function love.load()
    love.window.setMode(800, 600)
end

function love.draw()
    love.graphics.setColor(1, 1, 1)
    love.graphics.line(curve:render(6))
    for i = 1, #pointsX do
        love.graphics.circle("fill", pointsX[i], pointsY[i], 5)
    end

    -- dark red circle with text on it
    love.graphics.setColor(0.5, 0, 0)
    local x = findXFromY(curve, love.mouse.getY())
    local y = findYFromX(curve, x)

    love.graphics.circle("fill", x or 0, y or 0, 10)
    love.graphics.setColor(1, 1, 1)
    love.graphics.print("x: " .. (x or "nil") .. "\ny: " .. (y or "nil"), (x or 0) + 10, (y or 0) + 10)
end