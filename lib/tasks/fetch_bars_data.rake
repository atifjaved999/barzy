namespace :fetch_bars_data do

  task fetch: :environment do
    # FetchBarsWorker.perform_async()
    ScrapService.fetch
  end

  task fetch_links: :environment do
    BarLinksService.fetch
  end

  task create_and_fetch: :environment do 
    # Using BarLinks
    CreateAndFetchService.fetch
    # FetchBarsWorker.perform_async()
  end

  task remove_cluttered_bars: :environment do
    puts "Starting..."
      Bar.find_each(batch_size: 500) do |bar|
        if bar.address.blank? # and bar.timings.blank?# and bar.bar_photos.blank?
          bar.destroy
          puts "#{bar.name} #{bar.id} removed"
        end
      end
    puts "success..."
  end

  task update_bars_zip: :environment do
    puts "Starting..."
      i = 0
      Bar.find_each(batch_size: 500) do |bar|
        if bar.present? and bar.zip_code.present?
          puts "#{bar.zip_code} -- #{bar.address} --Before"
          real_zip = bar.address.split("WA")[1].split(" ")[0] rescue ""
          if real_zip.present? and real_zip.include? "98" and real_zip != bar.zip_code
            bar.zip_code = real_zip
            if bar.save
              puts "#{bar.zip_code} -- #{bar.address} --After"
            end
            puts i+=1
          end
        end
      end
    puts "Total: #{i}"
    puts "success..."
  end

  task remove_duplicate_bars: :environment do
    puts "Starting..."
      i = 0
      ids = Bar.select("MIN(id) as id").group(:name, :address, :contact_no).collect(&:id)
      removable_bars = Bar.where.not(id: ids)#.destroy_all
      removable_bars.each do |bar|
        bar.status = "deleted"
        bar.save
        puts "#{bar.zip_code} -- #{bar.address} -- #{bar.status}"
        i+=1
      end

    puts "Total: #{i}"
    puts "success..."
  end

end