require 'rails_helper'

describe 'Articles', type: :request do
  describe 'GET v1/articles/most_viewed_in_a_month' do
    let(:endpoint) {'/api/v1/articles/most_viewed_in_a_month'}
    let(:params) { { start_date: "#{year}-#{month}" } }

    context 'with valid params' do
      let(:year) {'2022'}
      let(:month) {'02'}
      let(:wikipedia_response_body) do
        {
          "items" => [
            {
              "project"=>"en.wikipedia",
              "access"=>"all-access",
              "year"=>"2022",
              "month"=>"03",
              "articles" => [
                {"article"=>"Main_Page", "views"=>4989, "rank"=>1},
                {"article"=>"Special:Search", "views"=>3104, "rank"=>2},
              ],
            },
          ],
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
        expect(parsed_response).to eq wikipedia_response_body['items'].first['articles'].first
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