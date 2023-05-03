# Gets the view count for an article in a given month
#
class GetArticleMonthViews
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

      article_count_response = WikipediaClient::PageViews.per_article(
        article: article,
        granularity: 'monthly', 
        start_date: start_date, 
        end_date: end_date,
      )[:body]
      
      article_count_response['items'].first['views']
    end
  end
end