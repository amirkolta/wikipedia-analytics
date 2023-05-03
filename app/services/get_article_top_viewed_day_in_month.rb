# Gets the day an srticle was most viewed in a month
#
class GetArticleTopViewedDayInMonth
  class << self
    # @param article [String]
    # @param year [String]
    # @param month [String]
    #
    # @return [Integer]
    #
    def execute(article:, year:, month:)
      start_date = Date.new(year.to_i, month.to_i)
      end_date  = (start_date + 1.month).to_formatted_s(:number)
      start_date = start_date.to_formatted_s(:number)

      daily_counts = WikipediaClient::PageViews.per_article(
        article: article,
        granularity: 'daily', 
        start_date: start_date, 
        end_date: end_date,
      )[:body]['items']

      max_day_item = daily_counts.sort_by { |day| day['views'] }.last

      Date.parse(max_day_item['timestamp']).day
    end
  end
end