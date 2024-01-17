local startTime = love.timer.getTime()

local notes = {
    {1000, 1}, -- ms time, lane (only 4)
    {2000, 2},
    {3000, 3},
    {4000, 4},
    {5000, 1},
    {6000, 2},
    {7000, 3},
    {8000, 4},
    {9000, 1},
    {10000, 2},
    {11000, 3},
    {12000, 4},
    {13000, 1},
    {14000, 2},
    {15000, 3},
    {16000, 4},
    {17000, 1},
    {18000, 2},
    {19000, 3},
    {20000, 4},
    {21000, 1},
    {22000, 2},
    {23000, 3},
    {24000, 4},
    {25000, 1},
    {26000, 2},
    {27000, 3},
    {28000, 4},
    {29000, 1},
    {30000, 2},
    {31000, 3},
    {32000, 4},
    {33000, 1},
    {34000, 2},
    {35000, 3},
    {36000, 4},
    {37000, 1},
    {38000, 2},
    {39000, 3},
    {40000, 4},
    {41000, 1},
    {42000, 2},
    {43000, 3},
    {44000, 4},
    {45000, 1},
    {46000, 2},
    {47000, 3},
    {48000, 4},
    {49000, 1},
    {50000, 2},
    {51000, 3},
    {52000, 4},
    {53000, 1},
    {54000, 2},
    {55000, 3},
    {56000, 4},
    {57000, 1},
    {58000, 2},
    {59000, 3},
    {60000, 4},
    {61000, 1},
    {62000, 2},
    {63000, 3},
    {64000, 4},
    {65000, 1},
    {66000, 2},
}

musicTime = 0 -- ms

-- End pos is always 50 * lane (x) and 25 (y)

local noteBeziers = {}
local notePoints = {
    { -- lane 1
        50 * 1, 600, -- start
        50 * 1, 25, -- end
    },
    { -- lane 2
        50 * 2, 600, -- start
        50 * 2, 25, -- end
    },
    { -- lane 3
        50 * 3, 600, -- start
        50 * 3, 25, -- end
    },
    { -- lane 4
        50 * 4, 600, -- start
        50 * 4, 25, -- end
    }
}

function createSpline(lane, x, y)
    -- insert into notePoints in the middle of the table for the lane
    -- then recreate the bezier curve

    local x = x or 0
    local y = y or 0

    -- insert it right before the end point
    table.insert(notePoints[lane], #notePoints[lane] - 1, x)
    table.insert(notePoints[lane], #notePoints[lane] - 1, y)
    
    noteBeziers[lane] = love.math.newBezierCurve(notePoints[lane])
end

for i = 1, 4 do
    local points = {}
    -- for now, only 4 points, start, middle, end
    table.insert(points, 50 * i) -- x
    table.insert(points, 600) -- y
    table.insert(points, 50 * i) -- x3
    table.insert(points, 25) -- y3
    local curve = love.math.newBezierCurve(points)
    table.insert(noteBeziers, curve)
end

createSpline(1, 300, 300)
createSpline(2, 400, 500)

local endTime = love.timer.getTime()
print("Took " .. (endTime - startTime) .. " seconds to create splines")

function love.update(dt)
    musicTime = musicTime + dt * 1000
end

function findBezierPosition(lane, position)
    if position > 1 then position = 1 end
    if position < 0 then position = 0 end
    return noteBeziers[lane]:evaluate(position)
end

function love.draw()
    for i = 1, #noteBeziers do
        love.graphics.line(noteBeziers[i]:render())
    end

    for i = 1, #notes do -- find pos from musicTime
        -- follow the bezier curve (bottom to top)
        local x, y = findBezierPosition(notes[i][2], (musicTime - notes[i][1]) / 4000)
        -- center
        love.graphics.push()
        love.graphics.translate(-12.5, 0)
        love.graphics.rectangle("fill", x, y, 25, 25)
        love.graphics.pop()
    end
end