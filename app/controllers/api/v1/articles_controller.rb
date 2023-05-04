module Api
  module V1
    class ArticlesController < ApplicationController
      rescue_from WikipediaClient::PageViews::WikipediaAPIError, with: :render_failed_external_request

      before_action :validate_year_param, only: [:most_viewed_in_a_month, :month_views, :top_viewed_day_in_a_month]
      before_action :validate_month_param, only: [:most_viewed_in_a_month, :month_views, :top_viewed_day_in_a_month]
      before_action :validate_start_date_param, only: [:most_viewed_in_a_week, :week_views]

      # Gets the most viewed article in a month
      #
      # GET /v1/articles/most_viewed_in_a_month
      # 
      # Accepted Params: :year, :month
      #
      def most_viewed_in_a_month
        most_viewed_article = GetMostViewedArticleInMonth.execute(year: params[:year], month: sanitized_month_param)

        render json: most_viewed_article
      end

      # Gets the most viewed article in a week
      #
      # GET /v1/articles/most_viewed_in_a_week
      # 
      # Accepted Params: :start_date
      #
      def most_viewed_in_a_week
        most_viewed_article = GetMostViewedArticleInWeek.execute(start_date: parsed_start_date)

        render json: most_viewed_article
      end

      # Gets the total views for an article in a week
      #
      # GET /v1/articles/:title/week_views
      # 
      # Accepted Params: :title, :start_date
      #
      def week_views
        views = GetArticleWeekViews.execute(article: params[:title], start_date: parsed_start_date)

        render json: views
      end

      # Gets the total views for an article in a month
      #
      # GET /v1/articles/:title/month_views
      # 
      # Accepted Params: :title, :year, :month
      #
      def month_views
        views = GetArticleMonthViews.execute(article: params[:title], year: params[:year], month: sanitized_month_param)

        render json: views
      end

      # Gets the day with the most views for a certain article
      #
      # GET /v1/articles/:title/top_viewed_day_in_a_month
      # 
      # Accepted Params: :title, :year, :month
      #
      def top_viewed_day_in_a_month
        day = GetArticleTopViewedDayInMonth.execute(article: params[:title], year: params[:year], month: sanitized_month_param)

        render json: day
      end

      private

      def parsed_start_date
        Date.parse(params[:start_date])
      end

      # Reformats a month param to a 2 digit format
      # to satisfy the wikipedia API
      #
      def sanitized_month_param
        format('%02d', params[:month])
      end

      # Validates that a year param exists and that it's a valid date
      #
      def validate_year_param
        render_invalid_param_error('Invalid year') unless params[:year]&.match?(/\A\d{4}\z/)
      end

      # Validates that a month param exists and that it's a valid date
      #
      def validate_month_param
        month_int = params[:month].to_i

        if month_int < 1 || month_int > 12 || !sanitized_month_param&.match?(/\A\d{2}\z/)
          render_invalid_param_error('Invalid month') 
        end
      end

      # Validates that a date param exists and that it's a valid date
      #
      def validate_start_date_param
        if params[:start_date].nil?
          render_invalid_param_error('Invalid date') 
        else
          Date.parse(params[:start_date])
        end
      rescue Date::Error
        render_invalid_param_error('Invalid date')
      end
    end
  end
end
