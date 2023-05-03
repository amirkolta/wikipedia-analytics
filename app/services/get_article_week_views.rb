# Gets the view count for an article in a given week
#
class GetArticleWeekViews
  class << self
    # @param article [String]
    # @param start_date [Date]
    #
    # @return [Integer]
    #
    def execute(article:, start_date: 1.week.ago)
      end_date  = (start_date + 1.week).to_date.to_formatted_s(:number)
      start_date = start_date.to_date.to_formatted_s(:number)

      article_count_response = WikipediaClient::PageViews.per_article(
        article: article,
        granularity: 'daily', 
        start_date: start_date, 
        end_date: end_date,
      )[:body]
      
      article_count_response['items'].pluck('views').sum
    end
  end
end