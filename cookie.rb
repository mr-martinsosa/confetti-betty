class Cookie
    attr_accessor :name, :image, :description, :price
    def initialize(name, image, description, price)
        @name = name
        @image = image
        @description = description
        @price = price
    end
end
