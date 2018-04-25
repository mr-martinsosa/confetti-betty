require "sinatra"
require "sinatra/reloader"
require "sendgrid-ruby"
require_relative "cookie"
require_relative "cake"
require_relative "muffin"

include SendGrid

to = Email.new(email: ENV["PERSONAL_EMAIL"])
from = Email.new(email: ENV["PERSONAL_EMAIL"])

get "/" do
    erb :index
end

get "/cookies" do
    erb :cookies
end

get "/cake" do
    erb :cakes
end

get "/muffin" do
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