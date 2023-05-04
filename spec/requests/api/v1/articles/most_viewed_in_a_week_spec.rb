require 'rails_helper'

describe 'Articles', type: :request do
  describe 'GET /v1/articles/most_viewed_in_a_week' do
    let(:endpoint) { '/api/v1/articles/most_viewed_in_a_week' }
    let(:params) { { start_date: "#{year_param}-#{month_param}-#{day_param}" } }

    context 'with valid params' do
      let(:year_param) { '2022' }
      let(:month_param) { '03' }
      let(:day_param) { '01' }
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
      let(:wikipedia_response_1) { instance_double(HTTParty::Response, body: wikipedia_response_body_day_1.to_json, code: 200) }
      let(:wikipedia_response_2) { instance_double(HTTParty::Response, body: wikipedia_response_body_day_2.to_json, code: 200) }
      let(:wikipedia_response_3) { instance_double(HTTParty::Response, body: wikipedia_response_body_day_3.to_json, code: 200) }
      let(:wikipedia_response_4) { instance_double(HTTParty::Response, body: wikipedia_response_body_day_4.to_json, code: 200) }
      let(:wikipedia_response_5) { instance_double(HTTParty::Response, body: wikipedia_response_body_day_5.to_json, code: 200) }
      let(:wikipedia_response_6) { instance_double(HTTParty::Response, body: wikipedia_response_body_day_6.to_json, code: 200) }
      let(:wikipedia_response_7) { instance_double(HTTParty::Response, body: wikipedia_response_body_day_7.to_json, code: 200) }
  
      before do
        allow(HTTParty).to receive(:get).with(build_wiki_url(year: year_param, month: month_param, day: '01'), headers: headers).and_return(wikipedia_response_1)
        allow(HTTParty).to receive(:get).with(build_wiki_url(year: year_param, month: month_param, day: '02'), headers: headers).and_return(wikipedia_response_2)
        allow(HTTParty).to receive(:get).with(build_wiki_url(year: year_param, month: month_param, day: '03'), headers: headers).and_return(wikipedia_response_3)
        allow(HTTParty).to receive(:get).with(build_wiki_url(year: year_param, month: month_param, day: '04'), headers: headers).and_return(wikipedia_response_4)
        allow(HTTParty).to receive(:get).with(build_wiki_url(year: year_param, month: month_param, day: '05'), headers: headers).and_return(wikipedia_response_5)
        allow(HTTParty).to receive(:get).with(build_wiki_url(year: year_param, month: month_param, day: '06'), headers: headers).and_return(wikipedia_response_6)
        allow(HTTParty).to receive(:get).with(build_wiki_url(year: year_param, month: month_param, day: '07'), headers: headers).and_return(wikipedia_response_7)
        allow(wikipedia_response_1).to receive(:success?).and_return(true)
        allow(wikipedia_response_2).to receive(:success?).and_return(true)
        allow(wikipedia_response_3).to receive(:success?).and_return(true)
        allow(wikipedia_response_4).to receive(:success?).and_return(true)
        allow(wikipedia_response_5).to receive(:success?).and_return(true)
        allow(wikipedia_response_6).to receive(:success?).and_return(true)
        allow(wikipedia_response_7).to receive(:success?).and_return(true)
      end

      it 'returns the most viewed article' do
        get endpoint, params: params
        parsed_response = JSON.parse(response.body)
        expect(parsed_response).to eq({ 'article' => 'Super_Popular_Page', 'views' => 100000000 })
      end

      def build_wiki_url(year:, month:, day:)
        "https://wikimedia.org/api/rest_v1/metrics/pageviews/top/en.wikisource/all-access/#{year}/#{month}/#{day}"
      end

      def headers
        {
          accept: 'application/json'
        }
      end
    end

    context 'with an invalid date param' do
      it 'renders an invalid param error' do
        get endpoint, params: {start_date: 'not_a_date'}

        parsed_response = JSON.parse(response.body)

        expect(response).to have_http_status(:bad_request)
        expect(parsed_response['code']).to eq 3000
        expect(parsed_response['message']).to eq 'Invalid date'
      end
    end

    context 'with no date param' do
      it 'renders an invalid param error' do
        get endpoint, params: {}

        parsed_response = JSON.parse(response.body)

        expect(response).to have_http_status(:bad_request)
        expect(parsed_response['code']).to eq 3000
        expect(parsed_response['message']).to eq 'Invalid date'
      end
    end
  end
end