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
    erb :cookies
end

get "/cakes" do
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