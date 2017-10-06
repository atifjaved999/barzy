json.id timing.id
json.day timing.day
json.opening_time format_time(timing.opening_time) rescue ''
json.closing_time format_time(timing.closing_time) rescue ''