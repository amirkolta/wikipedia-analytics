require 'rails_helper'

describe GetMostViewedArticleInMonth do
  subject(:klass) {GetMostViewedArticleInMonth}

  describe '.execute' do
    let(:wikipedia_response_body) do
      {
        "items" => [
          {
            "project"=>"en.wikisource",
            "access"=>"all-access",
            "year"=>"2022",
            "month"=>"03",
            "day"=>"02",
            "articles" => [
              {"article"=>"Cognitive_Behavioral_Therapy", "views"=>7892, "rank"=>1},
              {"article"=>"Main_Page", "views"=>4989, "rank"=>2},
              {"article"=>"Dave_Matthews_Band", "views"=>3104, "rank"=>3},
            ],
          },
        ],
      }
    end
    let(:success_client_response) do
      {
        status: 200,
        body: wikipedia_response_body,
      }
    end

    before do
      allow(WikipediaClient::PageViews).to receive(:top).and_return(success_client_response)
    end

    it 'responds with the expected result' do
      article = klass.execute(year: '2023', month: '01')

      expect(WikipediaClient::PageViews).to have_received(:top).with(year: '2023', month: '01')
      expect(article['article']).to eq 'Cognitive_Behavioral_Therapy'
      expect(article['views']).to eq 7892
      expect(article['rank']).to eq 1
    end
  end
end