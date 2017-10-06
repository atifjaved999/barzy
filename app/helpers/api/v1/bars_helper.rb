module Api::V1::BarsHelper

  def is_favourite(bar_id, user)
    if user.bars.find_by_id(bar_id)
      return true
    else
      return false
    end
  end

  def current_day_name
    Time.now.in_time_zone("America/Los_Angeles").strftime("%A")
  end

end
