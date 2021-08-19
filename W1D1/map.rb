class Map
    def initialize 
        @map = []
    end

    def set(key, value)
        updated_a_value = false
        @map.each.with_index do |kv, i| 
            if @map[i][0] == key
                @map[i][1] = value
                updated_a_value = true
            end
        end
        unless updated_a_value
            @map << [key, value]
        end
    end

    def get(key)
        @map.select{ |kv| kv[0] == key }
    end

    def delete(key)
        @map.each.with_index do |kv, i|
            @map[i] == nil if kv[0] == key
        end
        @map.delete_if{ |kv| kv[0] == key }
    end

    def show
        str = ''
        @map.each do |kv|
            str += kv.join(' => ') + ', '
        end
        str[0..-3]
    end
end

map = Map.new()
map.set('Gary Oldman', 'Actor')
map.set('Jennifer Lopez', 'Actor/Singer')
map.set('Beyonce', 'Singer')
map.set('Bob Ross', 'Painter')
p map.get('Jennifer Lopez') #Expect Actor/Singer
p map.get('Bob Ross') #Expect Painter
puts map.show #Expect list of all names
map.set('Bob Ross', 'Painter/Legend') 
p map.get('Bob Ross') #Expect Painter/Legend
puts map.show #Expect list of all names with there being only one Bob Ross, 
# that is a legend.
map.delete('Beyonce')
puts map.show #Expect list without beyonce
