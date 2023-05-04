require 'rails_helper'

describe GetMostViewedArticleInWeek do
  subject(:klass) {GetMostViewedArticleInWeek}

  describe '.execute' do
    let(:wikipedia_response_body_day_1) do
      {
        "items" => [
          {
            "project"=>"en.wikisource",
            "access"=>"all-access",
            "year"=>"2022",
            "month"=>"03",
            "day"=>"01",
            "articles" => [
              {"article"=>"Cognitive_Behavioral_Therapy", "views"=>7000, "rank"=>1},
              {"article"=>"Main_Page", "views"=>5000, "rank"=>2},
              {"article"=>"Dave_Matthews_Band", "views"=>3000, "rank"=>3},
            ],
          },
        ],
      }
    end
    let(:wikipedia_response_body_day_2) do
      {
        "items" => [
          {
            "project"=>"en.wikisource",
            "access"=>"all-access",
            "year"=>"2022",
            "month"=>"03",
            "day"=>"02",
            "articles" => [
              {"article"=>"Main_Page", "views"=>9000, "rank"=>1},
              {"article"=>"Cognitive_Behavioral_Therapy", "views"=>8000, "rank"=>2},
              {"article"=>"Dave_Matthews_Band", "views"=>6000, "rank"=>3},
            ],
          },
        ],
      }
    end
    let(:wikipedia_response_body_day_3) do
      {
        "items" => [
          {
            "project"=>"en.wikisource",
            "access"=>"all-access",
            "year"=>"2022",
            "month"=>"03",
            "day"=>"03",
            "articles" => [
              {"article"=>"Dave_Matthews_Band", "views"=>1000, "rank"=>1},
              {"article"=>"Main_Page", "views"=>900, "rank"=>2},
              {"article"=>"Cognitive_Behavioral_Therapy", "views"=>700, "rank"=>3},
            ],
          },
        ],
      }
    end
    let(:wikipedia_response_body_day_4) do
      {
        "items" => [
          {
            "project"=>"en.wikisource",
            "access"=>"all-access",
            "year"=>"2022",
            "month"=>"03",
            "day"=>"04",
            "articles" => [
              {"article"=>"Cognitive_Behavioral_Therapy", "views"=>10000, "rank"=>1},
              {"article"=>"Main_Page", "views"=>5000, "rank"=>2},
              {"article"=>"Dave_Matthews_Band", "views"=>2500, "rank"=>3},
            ],
          },
        ],
      }
    end
    let(:wikipedia_response_body_day_5) do
      {
        "items" => [
          {
            "project"=>"en.wikisource",
            "access"=>"all-access",
            "year"=>"2022",
            "month"=>"03",
            "day"=>"05",
            "articles" => [
              {"article"=>"Super_Popular_Page", "views"=>100000000, "rank"=>1},
              {"article"=>"Main_Page", "views"=>4989, "rank"=>2},
              {"article"=>"Dave_Matthews_Band", "views"=>3104, "rank"=>3},
              {"article"=>"Cognitive_Behavioral_Therapy", "views"=>1203, "rank"=>4},
            ],
          },
        ],
      }
    end
    let(:wikipedia_response_body_day_6) do
      {
        "items" => [
          {
            "project"=>"en.wikisource",
            "access"=>"all-access",
            "year"=>"2022",
            "month"=>"03",
            "day"=>"06",
            "articles" => [
              {"article"=>"Cognitive_Behavioral_Therapy", "views"=>7892, "rank"=>1},
              {"article"=>"Main_Page", "views"=>4989, "rank"=>2},
              {"article"=>"Dave_Matthews_Band", "views"=>3104, "rank"=>3},
            ],
          },
        ],
      }
    end
    let(:wikipedia_response_body_day_7) do
      {
        "items" => [
          {
            "project"=>"en.wikisource",
            "access"=>"all-access",
            "year"=>"2022",
            "month"=>"03",
            "day"=>"07",
            "articles" => [
              {"article"=>"Random_Article", "views"=>500, "rank"=>1},
            ],
          },
        ],
      }
    end

    before do
      allow(WikipediaClient::PageViews).to receive(:top).with(year: '2023', month: '01', day: '01').and_return(build_success_client_response(wikipedia_response_body_day_1))
      allow(WikipediaClient::PageViews).to receive(:top).with(year: '2023', month: '01', day: '02').and_return(build_success_client_response(wikipedia_response_body_day_2))
      allow(WikipediaClient::PageViews).to receive(:top).with(year: '2023', month: '01', day: '03').and_return(build_success_client_response(wikipedia_response_body_day_3))
      allow(WikipediaClient::PageViews).to receive(:top).with(year: '2023', month: '01', day: '04').and_return(build_success_client_response(wikipedia_response_body_day_4))
      allow(WikipediaClient::PageViews).to receive(:top).with(year: '2023', month: '01', day: '05').and_return(build_success_client_response(wikipedia_response_body_day_5))
      allow(WikipediaClient::PageViews).to receive(:top).with(year: '2023', month: '01', day: '06').and_return(build_success_client_response(wikipedia_response_body_day_6))
      allow(WikipediaClient::PageViews).to receive(:top).with(year: '2023', month: '01', day: '07').and_return(build_success_client_response(wikipedia_response_body_day_7))
    end

    it 'responds with the expected result' do
      article = klass.execute(start_date: Date.new(2023, 1))

      expect(WikipediaClient::PageViews).to have_received(:top).with(year: '2023', month: '01', day: '01')
      expect(WikipediaClient::PageViews).to have_received(:top).with(year: '2023', month: '01', day: '02')
      expect(WikipediaClient::PageViews).to have_received(:top).with(year: '2023', month: '01', day: '03')
      expect(WikipediaClient::PageViews).to have_received(:top).with(year: '2023', month: '01', day: '04')
      expect(WikipediaClient::PageViews).to have_received(:top).with(year: '2023', month: '01', day: '05')
      expect(WikipediaClient::PageViews).to have_received(:top).with(year: '2023', month: '01', day: '06')
      expect(WikipediaClient::PageViews).to have_received(:top).with(year: '2023', month: '01', day: '07')
      
      expect(article[:article]).to eq 'Super_Popular_Page'
      expect(article[:views]).to eq 100000000
    end

    def build_success_client_response(wiki_response)
      {
        status: 200,
        body: wiki_response,
      }
    end
  end
end