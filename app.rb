require "sinatra"
#require "sinatra/reloader"
require "sendgrid-ruby"

include SendGrid

to = Email.new(email: ENV["PERSONAL_EMAIL"])
from = Email.new(email: ENV["PERSONAL_EMAIL"])

get "/" do
    erb :index
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