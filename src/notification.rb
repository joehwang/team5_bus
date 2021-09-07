require 'httparty'
require 'json'

class Notification
  attr_accessor :notify_email

  def initialize(_email)
    @notify_email = _email
  end

  def invoke(_msg)
    HTTParty.post("https://mail.surenotifyapi.com/v1/messages", 
    body: {
      subject: "#{_msg}",
      fromName: "公車通知",
      fromAddress: "joehwang.com@gmail.com",
      content: "<html><body><h3>#{_msg}</h3></body></html>",
      unsubscribedLink: "https://links.to.your.unsubscribe.link",
      recipients: [
        {
          name: "#{@notify_email}",
          address: "#{@notify_email}",
          variables: {
            UUID: "1234-56-78-9012"
          }
        }
      ]
    }.to_json,
      headers: {
        "Content-Type": "application/json",
        "Accept": "application/json",
        "x-api-key": "NDAyODgyMDc3YjlhNjExOTAxN2JiYzAzODk5MzA2NzEtMTYzMDk0ODIwMi0w"
      }
    )
  end
end
