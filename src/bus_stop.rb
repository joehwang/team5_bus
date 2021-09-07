require 'httparty'
require 'json'
# stops data
class BusStop
  attr_accessor :route_name

  def initialize(_route_name)
    @route_name = _route_name
  end

  def monitor(arg)
    target = fetch_name.select { |_k, v| v == arg[:target] }

    raise "distance error !" if  arg[:distance][:min].to_i > target.keys.first.to_i
    raise "distance error !" if  arg[:distance][:max].to_i > target.keys.first.to_i
    monitor_end = target.keys.first.to_i - arg[:distance][:min].to_i
    monitor_start = target.keys.first.to_i - arg[:distance][:max].to_i
    monitor_stops = []
    monitor_start.upto(monitor_end) { |i| monitor_stops << i }
    return monitor_stops
  end
  def fetch_name
    response = HTTParty.get("https://ptx.transportdata.tw/MOTC/v2/Bus/DisplayStopOfRoute/City/Taipei/#{@route_name}?$select=stops&$filter=Direction%20eq%201&$top=30&$format=JSON", 
    headers: { 
        "Accept"=> "application/json",
        "User-Agent" => 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_1) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/93.0.4577.63 Safari/537.36'
    })
    stops = JSON.parse(response.body).first
    get_all_name = stops["Stops"].map{| item |  [item["StopSequence"], item["StopName"]["Zh_tw"]] }.to_h
    return get_all_name
  end
end