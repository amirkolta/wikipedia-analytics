require 'rails_helper'

describe GetArticleWeekViews do
  subject(:klass) {GetArticleWeekViews}

  describe '.execute' do
    let(:wikipedia_response_body) do
      {
        "items" => [
          {
            "project" => "en.wikipedia",
            "article" => "Dave_Matthews_Band",
            "granularity" => "daily",
            "timestamp" => "2023010100",
            "access" => "all-access",
            "agent" => "all-agents",
            "views" => 500
          },
          {
            "project" => "en.wikipedia",
            "article" => "Dave_Matthews_Band",
            "granularity" => "daily",
            "timestamp" => "2023010200",
            "access" => "all-access",
            "agent" => "all-agents",
            "views" => 1000
          },
          {
            "project" => "en.wikipedia",
            "article" => "Dave_Matthews_Band",
            "granularity" => "daily",
            "timestamp" => "2023010300",
            "access" => "all-access",
            "agent" => "all-agents",
            "views" => 700
          },
          {
            "project" => "en.wikipedia",
            "article" => "Dave_Matthews_Band",
            "granularity" => "daily",
            "timestamp" => "2023010400",
            "access" => "all-access",
            "agent" => "all-agents",
            "views" => 750
          },
          {
            "project" => "en.wikipedia",
            "article" => "Dave_Matthews_Band",
            "granularity" => "daily",
            "timestamp" => "2023010500",
            "access" => "all-access",
            "agent" => "all-agents",
            "views" => 800
          },
          {
            "project" => "en.wikipedia",
            "article" => "Dave_Matthews_Band",
            "granularity" => "daily",
            "timestamp" => "2023010600",
            "access" => "all-access",
            "agent" => "all-agents",
            "views" => 55
          },
          {
            "project" => "en.wikipedia",
            "article" => "Dave_Matthews_Band",
            "granularity" => "daily",
            "timestamp" => "2023010700",
            "access" => "all-access",
            "agent" => "all-agents",
            "views" => 1000
          },
        ]
      }
    end
    let(:success_client_response) do
      {
        status: 200,
        body: wikipedia_response_body,
      }
    end

    before do
      allow(WikipediaClient::PageViews).to receive(:per_article).and_return(success_client_response)
    end

    it 'converts date params provided to wikipedia format' do
      klass.execute(article: 'Dave_Matthews_Band', start_date: Date.new(2023, 1))

      expect(WikipediaClient::PageViews).to have_received(:per_article)
      .with(article: 'Dave_Matthews_Band', granularity: 'daily', start_date: '20230101', end_date: '20230108')
    end

    it 'responds with the expected result' do
      views = klass.execute(article: 'Dave_Matthews_Band', start_date: Date.new(2023, 1))

      expect(views).to eq 4805
    end
  end
end