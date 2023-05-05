module Api
  module V1
    class ArticlesController < ApplicationController
      rescue_from WikipediaClient::PageViews::WikipediaAPIError, with: :render_failed_external_request

      before_action :validate_start_date_param

      # Gets the most viewed article in a month
      #
      # GET /v1/articles/most_viewed_in_a_month
      # 
      # Accepted Params: :year, :month
      #
      def most_viewed_in_a_month
        most_viewed_article = GetMostViewedArticleInMonth.execute(
          year: parsed_start_date.year, 
          month: sanitized_month_param(parsed_start_date.month)
        )

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
        views = GetArticleMonthViews.execute(
          article: params[:title], 
          year: parsed_start_date.year, 
          month: sanitized_month_param(parsed_start_date.month)
        )

        render json: views
      end

      # Gets the day with the most views for a certain article
      #
      # GET /v1/articles/:title/top_viewed_day_in_a_month
      # 
      # Accepted Params: :title, :year, :month
      #
      def top_viewed_day_in_a_month
        day = GetArticleTopViewedDayInMonth.execute(
          article: params[:title], 
          year: parsed_start_date.year, 
          month: sanitized_month_param(parsed_start_date.month)
        )

        render json: day
      end

      private

      # Parses the start_date param into a Date Object
      #
      def parsed_start_date
        Date.parse(sanitized_date_param)
      end

      def sanitized_date_param
        params[:start_date].gsub('-', '/')
      end

      # Reformats a month param to a 2 digit format
      # to satisfy the wikipedia API
      #
      def sanitized_month_param(month)
        format('%02d', month)
      end

      # Validates that a date param exists and that it's a valid date
      #
      def validate_start_date_param
        if params[:start_date].nil?
          render_invalid_param_error('Missing date') 
        else
          Date.parse(sanitized_date_param)
        end
      rescue Date::Error
        render_invalid_param_error('Invalid date')
      end
    end
  end
end
