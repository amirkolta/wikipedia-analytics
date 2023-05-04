# Gets the most viewed article in a given week
#
class GetMostViewedArticleInWeek
  class << self
    # @param year [String]
    # @param month [String]
    #
    # @return [Hash]
    #
    def execute(start_date: 1.week.ago)
      article_counts = {}

      7.times do
        split_date = start_date.to_date.to_s.split('-')

        top_articles = WikipediaClient::PageViews.top(year: split_date[0], month: split_date[1], day: split_date[2])[:body]['items'].first['articles']

        article_counts = merge_new_article_counts(article_counts, top_articles)

        start_date = start_date + 1.day
      end
      
      most_viewed = article_counts.sort_by { |_, views| views }.last

      {
        article: most_viewed[0],
        views: most_viewed[1],
      }
    end

    private

    # This method merges 2 hashes by adding a new if the key does not
    # exist or adding the new value to the existing key's value
    #
    # @param article_counts [Hash]
    # @param new_articles [Hash]
    #
    # @return [Hash]
    #
    def merge_new_article_counts(article_counts, new_articles)
      new_articles.each do |article|
        article_key = article['article']

        if article_counts.key?(article_key)
          article_counts[article_key] += article['views']
        else
          article_counts[article_key] = article['views']
        end
      end

      article_counts
    end
  end
end