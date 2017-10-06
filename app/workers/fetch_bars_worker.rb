class FetchBarsWorker
  include Sidekiq::Worker

  def perform
    Rails.logger.debug 'Hello, CreateAndFetchService'
    # ScrapService.fetch
    CreateAndFetchService.fetch
  end
end
