class Tryparse
    def initialize

    end
    def intparse(str)
        begin
            Integer(str)
            return true
        rescue
            return false
        end
    end
end