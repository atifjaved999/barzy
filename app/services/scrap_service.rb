class ScrapService

  def self.fetch
    url = "https://www.yelp.com"
    search = "Bars"
    zip_codes = ["98125", "9817", "98115", "98103", "98107", "98105", "98199", "98119", "98199", "98109", "98112", "98121", "98101", "98122", "98104", "98144", "98134", "98116", "98126", "98136", "98106", "98108", "98118"]
    # zip_codes = ["98125"]
    messages = []
    begin
      zip_codes.each do |zip_code|
        begin
          Rails.logger.debug "**************Fetching #{search} in #{zip_code}...*******************"
            browser = BrowserSetup::setup_session(url)
            browser.fill_in "find_desc", with: "#{search}"
            browser.fill_in "dropperText_Mast", with: "#{zip_code}"
            browser.find("#header-search-submit").click
            # For Page 2 to onwards ...
            total_pages = browser.find('.pagination-block .page-of-pages').text.split('of')[1].to_i rescue ''
            # total_pages = 1 if total_pages > 1  # Test limit # Comment this for live
            if total_pages.present? and total_pages >= 1
              1.upto(total_pages) do |page_no|
                Rails.logger.debug "================Scraping Page No: #{page_no.to_s} of #{total_pages} =================="
                begin
                  ScrapService.fetch_bars_on_page(zip_code, browser, messages)
                rescue => ex
                  messages << "Error on ZipCode/PageNo: #{zip_code}/#{page_no} :" + ex.to_s
                end
                next_page_link = browser.find('.pagination-block .pagination-links a.next')['href'] rescue ''
                if next_page_link.present?
                  browser.execute_script("window.open('#{next_page_link}')")
                  # Switch and close Tab
                  browser.switch_to_window(browser.windows.first).close
                  browser.switch_to_window(browser.windows.last)
                end
              end
            end
            browser.driver.quit
          Rails.logger.debug "Success!"
        rescue => ex
          messages << "Error on Zipcode #{zip_code} :" + ex.to_s
        end
      end
    rescue => ex 
      messages <<  ex.to_s
    end
    Rails.logger.debug "+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
    Rails.logger.debug messages

    if messages.present?
     UserMailer.fetching_status(messages).deliver
    else
      UserMailer.fetching_status('All Bars Fetched Successfully.').deliver
    end
  end

  def self.fetch_bars_on_page(zip_code, browser, messages)
    bar_anchors = browser.all('.regular-search-result .indexed-biz-name .biz-name') rescue ''
    # bar_anchors = bar_anchors.first(1) if bar_anchors.length > 1 # Test limit # Comment this for live
    if bar_anchors.present?
      bar_anchors.each do |bar_anchor|
        Rails.logger.debug bar_anchor.first(:xpath,".//..").text rescue ''
        begin
          ScrapService.fetch_bar(zip_code, bar_anchor, browser)
          # Switch and close Tab
          browser.windows.last.close
          browser.switch_to_window(browser.windows.last)
        rescue => ex
          messages << "Error on Bar #{bar_anchor.text} :" + ex.to_s
        end
      end
    end
  end

  def self.fetch_bar(zip_code, anchor, browser)
    # Opening Bar Details Page
    url2 = anchor['href']
    browser.execute_script("window.open('#{url2}')")
    browser.switch_to_window(browser.windows.last)

    header = browser.find(".biz-page-header")
    bar_name = header.find('h1.biz-page-title').text
    # Rails.logger.debug "Bar Name: #{bar_name}"
    if  header.present? and  bar_name.present?
        bar = Bar.find_or_create_by(name: bar_name)
        bar.name = bar_name
        bar.zip_code = zip_code
        bar.ratings = header.find('.i-stars')['title'] rescue ''
        mapbox_container = browser.find('.mapbox-container')
        if mapbox_container.present?
          # Rails.logger.debug 'In mapbox_container'
          mapbox_text = mapbox_container.find('.mapbox-text')
          complete_address = ScrapService.set_address(mapbox_text)
          bar.address = complete_address rescue ''
          bar.contact_no = mapbox_text.find('.biz-phone').text rescue ''
          bar.website = mapbox_text.find('.biz-website').text rescue ''
          ScrapService.set_lat_lng(bar, mapbox_container)
        end

        ScrapService.set_timings(bar, browser)
        ScrapService.set_images(bar, browser)
        island_summary = browser.find('.column-beta .open-rail .island .iconed-list')
        bar.price_range =  island_summary.find('.price-description').text rescue ''
        ScrapService.set_menu(bar, island_summary, browser)
        bar.save
        Rails.logger.debug "Bar ID: #{bar.id} --  #{ bar.name} -- saved"
    end
  end

  def self.set_address(mapbox_text)
    street_address = mapbox_text.find('.street-address').text rescue ""
    cross_streets = mapbox_text.find('.cross-streets').text  rescue ""
    neighborhood_str_list = mapbox_text.find('.neighborhood-str-list').text  rescue ""
    return street_address + " " + cross_streets + " " + neighborhood_str_list
  end

  def self.set_images(bar, browser)
    showcase_photo = browser.find('.showcase-container')
    if showcase_photo.present?
      photos = showcase_photo.all('.js-photo .showcase-photo-box img') rescue ''
      if photos.present? and photos.length > 5 # Limiting the Photos
        Rails.logger.debug 'Adding Bar photos...'
        photos = photos.first(5)
        photos.each do |photo|
          photo_src = photo['src']
          if photo_src.present?
            photo_src = photo_src.split('/')
            file_name = photo_src[photo_src.length-2]
            photo_src[photo_src.length-1] = "o.jpg"
            photo_src = photo_src.join("/")
            unless attachment = bar.attachments.find_by(file_name: file_name)
            # Create Attachment
              bar.attachments.create(remote_file_url: photo_src, role: 'bar_photos', file_name: file_name)
            end
          end
        end
      end
    end
  end

  def self.set_menu(bar, summary, browser)
    # External Menu
    menu_ext = summary.find('.js-add-url-tagging .external-menu') rescue ''
    bar.menu.external_menu_url = menu_ext['href'] if menu_ext['href'].present?
    # Menu Explore
    menu_exp = summary.find('.js-add-url-tagging .menu-explore') rescue ''
    if menu_exp['href'].present?
      Rails.logger.debug 'Adding Menu...'
      bar.menu.yelp_reference_id = menu_exp['href'].split('menu/')[1] rescue ''
      menu = bar.menu ? bar.menu : bar.menu.new
      if menu.product_categories.present?
        Rails.logger.debug 'Product Categories of Menu already present.'
        return 
      end
      menu_exp.click # Go to Categories Page
      text_categories = browser.all('.menu-sections .section-header')
      menu_items_blocks = browser.all('.menu-sections .u-space-b3')
        menu_text = menu_items_blocks[0].find('.menu-text') rescue ''
      if menu_text.present?
        menu_items_blocks = menu_items_blocks.drop(1)
      end

      if text_categories.present?
        text_categories.each_with_index do |text_category, index|
          
          if category_name = text_category.find('.alternate').text
            category_desc = text_category.find('.alternate .menu-section-description').text rescue ''
          else
            category_name = text_category.text
            category_desc = ''
          end

          Rails.logger.debug category_name
          unless product_category = menu.product_categories.find_by(name: category_name)
          # Create Product Category
            product_category = menu.product_categories.create(name: category_name)
          end

          # Create Products
          menu_items = menu_items_blocks[index].all('.menu-item')
          if menu_items.present?
            menu_items.each do |item|
              item_name = item.find('.menu-item-details h4').text rescue ''
              Rails.logger.debug "      "+item_name
              item_description = item.find('.menu-item-details .menu-item-details-description').text rescue ''
              item_price = item.all('.menu-item-prices .menu-item-price-amount')[0].text.split('$')[1].to_f rescue ''
              unless product = product_category.products.find_by(name: item_name)
                product = product_category.products.create(name: item_name, description: item_description, price: item_price)
              end
            end
          end

        end
      end

    end
  end

  def self.set_timings(bar, browser)
    day_timings = browser.all('.biz-hours table tbody tr') rescue ''
    if day_timings.present?
      Rails.logger.debug 'Adding Bar Timings...'
      day_timings.each do |day_timing|
        day = day_timing.find('th').text
        opening = day_timing.all('td span').first.text rescue ''
        closing = day_timing.all('td span').last.text rescue ''
          if timing = bar.timings.find_by(day: day)
            timing.opening_time = opening
            timing.closing_time = closing
          else
            timing = bar.timings.create(day: day, opening_time: opening, closing_time: closing)
          end
      end
    end
  end

  def self.set_lat_lng(bar, mapbox_container)
    map_src = mapbox_container.find('.mapbox img')['src'] rescue ''
    if map_src.present?
      map_src = URI.decode(map_src)
      center =  map_src.split('&')[1]
      center = center.split(',')
      bar.lat = center[0].split('=')[1]
      bar.lng = center[1]
    end
  end

  def self.set_category(bar, cat_anchors, browser)
    if cat_anchors.present?
      cat_anchors.each do |cat_anchor|
        name = cat_anchor.text
        if category = Category.find_by(name: name)
          Rails.logger.debug "----Category: #{name}---- Found"
        else
          category = Category.create(name: name)
          Rails.logger.debug "----Category: #{name}---- Created"
          # Switch and close Tab
          # For Category Image
          # browser.execute_script("window.open('#{cat_anchor['href']}')")
          # browser.switch_to_window(browser.windows.last)
          # style = browser.all('.mosaic-container .mosaic-image-background')[0]['style'] rescue ''
          # if style.present?
          #   src = style.split("https:").last.split(".jpg").first
          #   src = ["https:", src, ".jpg"].join
          #   att= category.build_attachment(remote_file_url: src, role: 'photo', file_name: category.name)
          #   att.save
          # end
          # browser.switch_to_window(browser.windows.last).close
        end
        # Adding Category to bar
        unless bar_cat = bar.bar_categories.find_by(category_id: category.id)
          bar.bar_categories.create(category_id: category.id)
          Rails.logger.debug "----Category---- Added to Bar"
        end
      end
    end
  end

end
