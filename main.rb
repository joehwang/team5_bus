# encoding: UTF-8
Dir[File.dirname(__FILE__) + '/src/*.rb'].each {|file| require file }

route_name = 672
notify_email = "joehwang1@hotmail.com"
target_stop = "博仁醫院"

bus_stop = BusStop.new(route_name)
bus = Bus.new(route_name)
notification = Notification.new(notify_email)

monitor_stops = bus_stop.monitor({target:target_stop,distance:{min:3,max:5}})


while true
  p "查詢 #{route_name} 公車當前位置 ..."
  buses_location = bus.fetch_current_location
  intersection = monitor_stops & buses_location[:buses_location]
  if intersection.size > 0
    intersection.each do |monitor_stop_id|
      msg = "公車提醒通知,#{buses_location[:bus_info][monitor_stop_id]}"
      puts msg
      notification.invoke(msg)
    end
  else 
    puts "目前沒有靠近 #{target_stop} 的公車"
  end
  
  sleep 30
end

