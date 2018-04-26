require "sinatra"
require "sinatra/reloader"
require "sinatra/content_for"
require "sendgrid-ruby"
require_relative "cookie"
require_relative "cake"
require_relative "muffin"

include SendGrid

from = Email.new(email: ENV["PERSONAL_EMAIL"])


def catalog()
    sweets = []
    path = "../images/"

    m_m = Cookie.new("M&M Cookie", "#{path}" + "mm-cookie.jpg", 
    "It's a sweet drenched in sweets! A fan favorite!", "$1.50")
    ginger = Cookie.new("Ginger Cookie", "#{path}" + "ginger-cookie.jpg", 
    "Try our secretly made cookie, using our secret ingredient that you may or may not know.", "$1.50")
    white_nut = Cake.new("White Macadamia Cookie", "#{path}" + "white-nut-cookie.jpg", 
    "A delicious cake garneshed with strawberries and drenched with more strawberry.", "$1.50")

    black_white = Cake.new("Black White Cake", "#{path}" + "black-white-cake.jpg", 
    "Is it chocolate? Is it vanilla? We don't even know.", "$12.50")
    chocolate = Cake.new("Chocolate Cake", "#{path}" + "chocolate-cake.jpg", 
    "This one is definitely chocolate.", "$12.50")
    strawberry = Cake.new("Strawberry Shortcake", "#{path}" + "strawberry-shortcake.jpg", 
    "A delicious cake garneshed with strawberries and drenched with more strawberry.", "$12.50")

    apple = Muffin.new("Apple Muffin", "#{path}" + "apple-muffin.jpg", 
    "Delicious muffins made with apple, just like how grandma used to make them.", "$2.50")
    banana = Muffin.new("Banana Nut Muffin", "#{path}" + "banana-nut-muffin.jpg", 
    "Delicious muffins made with banana and nuts, just like how mom used to make them.", 
    "$2.50")
    egg = Muffin.new("Stuffed Egg Muffin", "#{path}" + "egg-muffin.jpg", 
    "A muffin packed with eggs and other breakfast essentials!", "$2.50")

    sweets.push(m_m, ginger, white_nut, black_white, chocolate, strawberry, apple, banana, egg)
    sweets
end

def grab_catalog()
    catalog = ""
    File.open("public/text/catalog.txt", "r") do |file_handle|
        file_handle.each_line do |line|
            p line
          catalog.concat(line)
        end
    end
    catalog
end

get "/" do
    erb :index
end

get "/cookies" do
    sweets = catalog()
    @cookies = []
    
    for cookie in sweets
        if cookie.name.include? "Cookie"
            @cookies.push(cookie)
        end
    end
    erb :cookies
end

get "/cakes" do
    sweets = catalog()
    @cakes = []
    
    for cake in sweets
        if cake.name.include? "ake"
            @cakes.push(cake)
        end
    end
    erb :cakes
end

get "/muffins" do
    sweets = catalog()
    @muffins = []

    for muffin in sweets
        if muffin.name.include? "Muffin"
            @muffins.push(muffin)
        end
    end
    erb :muffins
end

post "/" do
    sweets = catalog()
    catalog_list = grab_catalog()
    subject = "Confetti Betty - Product Catalog"
    to = Email.new(email: params[:email])
    content = Content.new(
        type: 'text/plain', 
        value: "Hey, #{params[:name]}! Here is our catalog: #{catalog_list}"
    )  
    mail = Mail.new(from, subject, to, content)
    sg = SendGrid::API.new(
        api_key: ENV["SENDGRID_API_KEY"]
    )
    response = sg.client.mail._('send').post(request_body: mail.to_json)

    redirect "/"
end