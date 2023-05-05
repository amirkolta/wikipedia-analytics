require 'rails_helper'

describe 'Articles', type: :request do
  describe 'GET /v1/articles/:title/week_views' do
    let(:endpoint) { "/api/v1/articles/#{article_title}/week_views" }
    let(:article_title) { 'Dave_Matthews_Band' }
    let(:params) { { start_date: "#{year}-#{month}-#{day}" } }

    context 'with valid params' do
      let(:year) {'2022'}
      let(:month) {'02'}
      let(:day) {'01'}
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
      let(:wikipedia_response) { instance_double(HTTParty::Response, body: wikipedia_response_body.to_json, code: 200) }

      before do
        allow(HTTParty).to receive(:get).and_return(wikipedia_response)
        allow(wikipedia_response).to receive(:success?).and_return(true)
      end

      it 'returns the most viewed article' do
        get endpoint, params: params
        parsed_response = JSON.parse(response.body)
        expect(parsed_response).to eq 4805
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
        expect(parsed_response['message']).to eq 'Missing date'
      end
    end
  end
end