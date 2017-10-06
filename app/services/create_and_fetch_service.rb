class CreateAndFetchService

  def self.fetch
    url = "https://www.yelp.com"
    messages = []
    begin
      browser = BrowserSetup::setup_session(url)
      BarLink.find_each(batch_size: 500) do |bar_link|
        begin
          if bar = Bar.find_by(name: bar_link.name, zip_code: bar_link.zip_code)
            Rails.logger.debug "Found Bar - BarLink #{bar.id} - #{bar_link.id} : #{bar.name}"
          else
            bar = Bar.create(name: bar_link.name, zip_code: bar_link.zip_code)
          end

          if bar.address.present?# and bar.bar_photos.present?# and bar.timings.present?
            sleep(0.25)
            next
          else
            Rails.logger.debug 'Missing Address ...'
          end
               
          Rails.logger.debug "****Fetching Bar - BarLink #{bar.id} - #{bar_link.id} : #{bar.name}...****"
          browser = BrowserSetup::setup_session(bar_link.link)
          bar_name = browser.find(".biz-page-header h1.biz-page-title").text rescue ''
          if bar_name.blank?
            Rails.logger.debug 'No Bar Name Found'
            next
          end
          CreateAndFetchService.fetch_bar(bar, browser)
          browser.driver.quit
        rescue => ex
          messages << "Error on BarLink: #{bar_link.id} :" + ex.to_s
        end
        browser.driver.quit rescue ''
        Rails.logger.debug "Success!"
      end
    rescue => ex 
      messages <<  ex.to_s
    end
    Rails.logger.debug "+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
    Rails.logger.debug messages

    if messages.present?
     UserMailer.fetching_status(messages).deliver
    else
      UserMailer.fetching_status('All Bars Created and Fetched Successfully.').deliver
    end
  end


  def self.fetch_bar(bar, browser)
    # Opening Bar Details Page
    header = browser.find(".biz-page-header").text
    # bar_name = header.find('h1.biz-page-title').text
    if  header.present?
        bar.ratings = header.find('.i-stars')['title'] rescue ''
        cat_anchors = header.find('.category-str-list').all('a') rescue ''
        ScrapService.set_category(bar, cat_anchors, browser) if bar.categories.blank? and cat_anchors.present?
        mapbox_container = browser.find('.mapbox-container')
        if mapbox_container.present?
          mapbox_text = mapbox_container.find('.mapbox-text')
          complete_address = ScrapService.set_address(mapbox_text) if bar.address.blank?
          bar.address = complete_address rescue ''
          bar.contact_no = mapbox_text.find('.biz-phone').text rescue ''
          bar.website = mapbox_text.find('.biz-website').text rescue ''
          ScrapService.set_lat_lng(bar, mapbox_container)  if bar.lat.blank? and bar.lng.blank?
        end

        ScrapService.set_timings(bar, browser) if bar.timings.blank?
        ScrapService.set_images(bar, browser) if bar.bar_photos.blank?
        island_summary = browser.find('.column-beta .open-rail .island .iconed-list')
        bar.price_range =  island_summary.find('.price-description').text rescue ''
        ScrapService.set_menu(bar, island_summary, browser)
        bar.save
        Rails.logger.debug "Bar ID: #{bar.id} --  #{ bar.name} -- Fetched and Saved"
    end
  end

end