Maze = {
    width,
    height,
    array,
}

function Maze:new(_width,_height)
    object = {}
    setmetatable(object, self)
    Maze.__index = self
    object.width = _width
    object.height = _height
    object.array = {}

    for i=1,object.height do
        object.array[i]={}
        for j=1,object.width do
            object.array[i][j] = 1
        end
    end

    return object
end

function Maze:get(x,y)
    if(x<=self.height and x>=1 and y<=self.width and y>=1) then
        return self.array[x][y]
    end
    return -1
end

function Maze:build(x,y,f,s)
    if(self:get(x,y) == -1 or self:get(x,y) == 0) then
        return
    end
    if(s == true) then
        if(x%2==0 and y%2 ==0) then
            return
        end
    end

    self.array[x][y] = 0

    ra={1,2,3,4}
    for i=1,4 do
        j= math.random(4)
        k=ra[i]
        ra[i] = ra[j]
        ra[j] = k
    end

    for i=1,4 do
    if(ra[i] == 1 and x+1<=self.height) then
            if(self:get(x+2,y)~=0 and self:get(x+1,y+1)~=0 and self:get(x+1,y-1)~=0) then
                self:build(x+1,y,f,s)
            elseif(math.random(f) < 1) then
                self:build(x+1,y,f,s)
            end
    end
    if(ra[i] == 2 and x-1>=1) then
            if(self:get(x-2,y)~=0 and self:get(x-1,y+1)~=0 and self:get(x-1,y-1)~=0) then
                self:build(x-1,y,f,s)
            elseif(math.random(f) < 1) then
                self:build(x-1,y,f,s)
            end
    end
    if(ra[i] == 3 and y+1<=self.width) then
            if(self:get(x,y+2)~=0 and self:get(x+1,y+1)~=0 and self:get(x-1,y+1)~=0) then
                self:build(x,y+1,f,s)
            elseif(math.random(f) < 1) then
                self:build(x,y+1,f,s)
            end
    end
    if(ra[i] == 4 and y-1>=1) then
            if(self:get(x,y-2)~=0 and self:get(x+1,y-1)~=0 and self:get(x-1,y-1)~=0) then
                self:build(x,y-1,f,s)
            elseif(math.random(f) < 1) then
                self:build(x,y-1,f,s)
            end
    end
end
end


EntityBlocks = {}

function build(x1,y1,z1,x2,y2,z2,f,s)

width = math.abs(x2 - x1) + 1
height = math.abs(y2 - y1) + 1

maze = Maze:new(height,width)

maze:build(1,1,f,s)

for i=1,width do
    EntityBlocks[i] = {}
    for j=1,height do
        print(x1 + i - 1)
        print(y1 + j - 1)

        if(x2-x1>0 and y2-y1 >0) then
            EntityBlocks[i][j] = Game.EntityBlock:Create({x = x1 + i - 1, y = y1 + j - 1, z = z1})
        end
        if(x2-x1 < 0 and y2-y1 < 0) then
            EntityBlocks[i][j] = Game.EntityBlock:Create({x = x1 - i + 1, y = y1 - j + 1, z = z1})
        end
        if(x2-x1 < 0 and y2-y1 > 0) then
            EntityBlocks[i][j] = Game.EntityBlock:Create({x = x1 - i + 1, y = y1 + j - 1, z = z1})
        end
        if(x2-x1 > 0 and y2-y1 < 0) then
            EntityBlocks[i][j] = Game.EntityBlock:Create({x = x1 + i - 1, y = y1 - j + 1, z = z1})
        end
        EntityBlocks[i][j]:Event({action = 'reset'}, 0)
        if(maze.array[i][j] ~= 0) then
            EntityBlocks[i][j]:Event({action = 'use'}, 1)
        end
    end
end

end

function Game.Rule:OnRoundStart()
    build(25,-141,6,10,-175,6,100,true)
end