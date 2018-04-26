require "sinatra"
require "sinatra/reloader"
require "sinatra/content_for"
require "sendgrid-ruby"
require_relative "cookie"
require_relative "cake"
require_relative "muffin"

include SendGrid

to = Email.new(email: ENV["PERSONAL_EMAIL"])
from = Email.new(email: ENV["PERSONAL_EMAIL"])
path = "../images/"

get "/" do
    erb :index
end

get "/cookies" do
    @cookies = []
    
    m_m = Cookie.new("M&M Cookie", "#{path}" + "mm-cookie.jpg", 
    "It's a sweet drenched in sweets! A fan favorite!", "$1.50")
    ginger = Cookie.new("Ginger Cookie", "#{path}" + "ginger-cookie.jpg", 
    "Try our secretly made cookie, using our secret ingredient that you may or may not know.", "$1.50")
    white_nut = Cake.new("White Macadamia Cookie", "#{path}" + "white-nut-cookie.jpg", 
    "A delicious cake garneshed with strawberries and drenched with more strawberry", "$1.50")

    @cookies.push(m_m, ginger, white_nut)
    
    erb :cookies
end

get "/cakes" do
    @cakes = []
    
    black_white = Cake.new("Black White Cake", "#{path}" + "black-white-cake.jpg", 
    "Is it chocolate? Is it vanilla? We don't even know.", "$12.50")
    chocolate = Cake.new("Chocolate Cake", "#{path}" + "chocolate-cake.jpg", 
    "This one is definitely chocolate.", "$12.50")
    strawberry = Cake.new("Strawberry Shortcake", "#{path}" + "strawberry-shortcake.jpg", 
    "A delicious cake garneshed with strawberries and drenched with more strawberry", "$12.50")

    @cakes.push(black_white, chocolate, strawberry)

    erb :cakes
end

get "/muffins" do
    @muffins = []
    
    apple = Muffin.new("Apple Muffin", "#{path}" + "apple-muffin.jpg", 
    "Delicious muffins made with apple, just like how grandma used to make them.", "$2.50")
    banana = Muffin.new("Banana Nut Muffin", "#{path}" + "banana-nut-muffin.jpg", 
    "Delicious muffins made with banana and nuts, just like how mom used to make them.", 
    "$2.50")
    egg = Muffin.new("Stuffed Egg Muffin", "#{path}" + "egg-muffin.jpg", 
    "A muffin packed with eggs and other breakfast essentials!", "$2.50")

    @muffins.push(apple, banana, egg)

    erb :muffins
end

post "/catalog" do
    subject = "Confetti Betty - Product Catalog"
    content = Content.new(
        type: 'text/plain', 
        value: "nothin'"
    )  
    mail = Mail.new(from, subject, to, content)
    sg = SendGrid::API.new(
        api_key: ENV["SENDGRID_API_KEY"]
    )
    response = sg.client.mail._('send').post(request_body: mail.to_json)
end