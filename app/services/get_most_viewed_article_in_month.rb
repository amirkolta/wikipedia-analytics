# Gets the most viewed article in a given month
#
class GetMostViewedArticleInMonth
  class << self
    # @param year [String]
    # @param month [String]
    #
    # @return [Hash]
    #
    def execute(year:, month:)
      top_articles = WikipediaClient::PageViews.top(year: year, month: month)[:body]['items'].first['articles']
      
      top_articles.first
    end
  end
end