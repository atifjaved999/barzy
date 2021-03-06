module ApplicationHelper

  def format_date(date)
    date.strftime("%b %d, %Y")
  end

  # def format_time(time)
  #   time.strftime("%I:%M:%S %p")
  # end

  def format_time(time)
    time.strftime("%I:%M %p")
  end

  def format_datetime(date)
    date.strftime("%b %d, %Y at %I:%M:%S %p")
  end
  
end
