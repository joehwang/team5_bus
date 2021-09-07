require 'httparty'
require 'json'

class Bus
	attr_accessor :route_name

	def initialize(_route_name)
		@route_name = _route_name
	end

	def fetch_current_location
		response = HTTParty.get("https://ptx.transportdata.tw/MOTC/v2/Bus/RealTimeNearStop/City/Taipei/672?$filter=Direction%20eq%201&$top=30&$format=JSON", 
		headers: { 
				"Accept"=> "application/json",
				"User-Agent" => 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_1) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/93.0.4577.63 Safari/537.36'
		})
		
		return {
				buses_location: response.map{|bus_location| bus_location["StopSequence"]},
				bus_info: response.map{|bus_location| [bus_location["StopSequence"],"#{bus_location["PlateNumb"]} 即將抵達 #{bus_location["StopName"]["Zh_tw"]}"]}.to_h
		}
	end
end

 if __FILE__ == $0
   bus=Bus.new
   puts bus.fetch_location 
 end