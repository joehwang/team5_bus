# encoding: UTF-8
Dir[File.dirname(__FILE__) + '/src/*.rb'].each {|file| require file }

route_name = 672
notify_email = "joehwang1@hotmail.com"

bus_stop = BusStop.new(route_name)
bus = Bus.new(route_name)
notification = Notification.new(notify_email)

monitor_stops = bus_stop.monitor({target:"博仁醫院",distance:{min:3,max:5}})
buses_location = bus.fetch_current_location

intersection = monitor_stops & buses_location[:buses_location]

while true
  if intersection.size > 0
    intersection.each do |monitor_stop_id|
      msg = "公車提醒通知,#{buses_location[:bus_info][monitor_stop_id]}"
      puts msg
      notification.invoke(msg)
    end
  end
  p "等待中"
  sleep 20
end

