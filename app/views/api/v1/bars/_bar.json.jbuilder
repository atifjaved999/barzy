json.id bar.id
json.name bar.name
json.description bar.description
json.address bar.address
json.contact_no bar.contact_no
json.website bar.website
json.ratings bar.ratings
json.price_range bar.price_range
json.is_favourite is_favourite(bar.id, @user)
json.lat bar.lat
json.lng bar.lng

json.attachments bar.attachments do |attachment|
  json.partial! 'api/v1/attachments/attachment', attachment: attachment
end

json.menu do
  if bar.menu.present?
    json.id bar.menu.id
    json.description bar.menu.description
      if bar.menu.extra.present?
        json.product_categories []
        json.partial! 'api/v1/attachments/attachment', attachment: bar.menu.extra
      else
        if bar.menu.product_categories.present?
          json.product_categories bar.menu.product_categories do |product_category|
              json.partial! 'api/v1/product_categories/product_category', product_category: product_category
            end
        end
      end
  end
end

  if bar.timings.present?
    json.today do
      json.day current_day_name rescue ''
      json.open_now bar.is_open_now rescue ''
      json.opening_time format_time(bar.today_opening_time) rescue ''
      json.closing_time format_time(bar.today_closing_time) rescue ''
    end
    json.timings bar.timings do |timing|
        json.partial! 'api/v1/timings/timing', timing: timing
    end
  end
