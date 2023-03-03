class Stack
    def initialize
        @stack = []
        @count = 0
    end
    def Push(num)
        @stack[@count] = num
        @count = @count + 1
    end
    def Pop
        return @stack[@count-=1]
    end
    def Peek
        return @stack[@count-1]
    end
end