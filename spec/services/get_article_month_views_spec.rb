require 'rails_helper'

describe GetArticleMonthViews do
  subject(:klass) {GetArticleMonthViews}

  describe '.execute' do
    let(:wikipedia_response_body) do
      {
        "items" => [
          {
            "project" => "en.wikipedia",
            "article" => "Dave_Matthews_Band",
            "granularity" => "monthly",
            "timestamp" => "2023010100",
            "access" => "all-access",
            "agent" => "all-agents",
            "views" => 74906
          }
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
      klass.execute(article: 'Dave Matthews Band', year: '2023', month: '01')

      expect(WikipediaClient::PageViews).to have_received(:per_article)
      .with(article: 'Dave Matthews Band', granularity: 'monthly', start_date: '20230101', end_date: '20230201')
    end

    it 'responds with the expected result' do
      views = klass.execute(article: 'Dave Matthews Band', year: '2023', month: '01')

      expect(views).to eq 74906
    end
  end
end