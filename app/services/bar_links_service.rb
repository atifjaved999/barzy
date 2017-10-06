class BarLinksService

  def self.fetch
    url = "https://www.yelp.com"
    search = "Bars"
    zip_codes = ["98125", "9817", "98115", "98103", "98107", "98105", "98199", "98119", "98199", "98109", "98112", "98121", "98101", "98122", "98104", "98144", "98134", "98116", "98126", "98136", "98106", "98108", "98118"]
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
            if total_pages.present? and total_pages >= 1
              1.upto(total_pages) do |page_no|
                Rails.logger.debug "===Zipcode #{zip_code} Page No: #{page_no.to_s} of #{total_pages} ===="
                begin
                  BarLinksService.fetch_bars_on_page(zip_code, browser, messages)
                rescue => ex
                  messages << "(BarLink) Error on ZipCode/PageNo: #{zip_code}/#{page_no} :" + ex.to_s
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
          messages << "(BarLink) Error on Zipcode: #{zip_code} :" + ex.to_s
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
      UserMailer.fetching_status('Bars Links Fetched Successfully.').deliver
    end

  end

  def self.fetch_bars_on_page(zip_code, browser, messages)
    bar_anchors = browser.all('.regular-search-result .indexed-biz-name .biz-name') rescue ''
    if bar_anchors.present?
      bar_anchors.each do |bar_anchor|
        begin
          Rails.logger.debug bar_anchor.first(:xpath,".//..").text
          bar_name = bar_anchor.text rescue ''
          link = bar_anchor['href'] rescue ''
          Rails.logger.debug "Link: #{link}"
          if bar_link = BarLink.find_by(name: bar_name, link: link, zip_code: zip_code)
            Rails.logger.debug "Name: #{bar_name}    --Found"
          else
            bar_link = BarLink.new(name: bar_name, link: link, zip_code: zip_code)

            if bar_link.save!
              Rails.logger.debug "BarLink: #{bar_link.id}    --Saved"
              Rails.logger.debug "   "
            end

          end
        rescue => ex
          Rails.logger.debug ex.to_s
          messages << "(BarLink) Error on Bar #{bar_anchor.text} :" + ex.to_s
        end
      end
    end
  end

end