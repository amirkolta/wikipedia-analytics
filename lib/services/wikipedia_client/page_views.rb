module WikipediaClient
  # A Wikipedia client for the pageviews API.
  #
  class PageViews
    BASE_URL = 'https://wikimedia.org/api/rest_v1/metrics/pageviews'.freeze
    DEFAULT_ACCESS = 'all-access'.freeze

    WikipediaAPIError = Class.new(StandardError)

    class << self
      # Calls the /top endpoint
      #
      # @param access [String] options -> 'all-access', 'mobile-app', 'mobile-web', 'desktop'
      # @params year [String]
      # @params month [String]
      # @params month [String]
      #
      # @return [Hash]
      #
      # @raise [WikipediaAPIError]
      #
      def top(access: DEFAULT_ACCESS, year:, month:, day: 'all-days')
        path = "#{year}/#{month}/#{day}"

        response = HTTParty.get(build_url(endpoint: 'top', project: 'en.wikipedia', access: access, path: path), headers: headers)

        return build_success_response(response) if response.success?

        raise WikipediaAPIError, build_error_response(response)
      end

      # Calls the /per_article endpoint
      #
      # @param access [String] options -> 'all-access', 'mobile-app', 'mobile-web', 'desktop'
      # @params article [String]
      # @params granularity [String] options -> 'daily', 'monthly'
      # @params start_date [String]
      # @params end_date [String]
      #
      # @return [Hash]
      #
      # @raise [WikipediaAPIError]
      #
      def per_article(access: DEFAULT_ACCESS, article:, granularity: 'daily', start_date:, end_date:)
        sanitized_article = sanitize_article(article)

        path = "all-agents/#{sanitized_article}/#{granularity}/#{start_date}/#{end_date}"

        response = HTTParty.get(build_url(endpoint: 'per-article', project: 'en.wikipedia', access: access, path: path), headers: headers)

        return build_success_response(response) if response.success?

        raise WikipediaAPIError, build_error_response(response)
      end

      private

      def headers
        {
          accept: 'application/json'
        }
      end

      # @param response [HTTParty::Response]
      #
      def build_success_response(response)
        {
          status: response.code,
          body: JSON.parse(response.body),
        }
      end

      # @param response [HTTParty::Response]
      #
      def build_error_response(response)
        error_messages = JSON.parse(response.body)['detail']

        if error_messages.is_a?(Array)
          error_messages.join('\n')
        else
          error_messages
        end
      end

      # @param article [String]
      #
      # Replaces spaces with underscores and URI Encodes the article title
      #
      def sanitize_article(article)
        CGI.escape article.gsub(' ', '_')
      end

      def build_url(endpoint:, access:, project:, path:)
        "#{BASE_URL}/#{endpoint}/#{project}/#{access}/#{path}"
      end
    end
  end
end