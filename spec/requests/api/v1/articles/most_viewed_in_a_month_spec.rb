require 'rails_helper'

describe 'Articles', type: :request do
  describe 'GET v1/articles/most_viewed_in_a_month' do
    let(:endpoint) {'/api/v1/articles/most_viewed_in_a_month'}
    let(:params) { { year: year, month: month } }

    context 'with valid params' do
      let(:year) {'2022'}
      let(:month) {'02'}
      let(:wikipedia_response_body) do
        {
          "items" => [
            {
              "project"=>"en.wikisource",
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

    context 'with an invalid year param' do
      let(:year) {'20225'}
      let(:month) {'02'}

      it 'renders an invalid param error' do
        get endpoint, params: params

        parsed_response = JSON.parse(response.body)

        expect(response).to have_http_status(:bad_request)
        expect(parsed_response['code']).to eq 3000
        expect(parsed_response['message']).to eq 'Invalid year'
      end
    end

    context 'with an invalid month param' do
      let(:year) {'2022'}
      let(:month) {'14'}

      it 'renders an invalid param error' do
        get endpoint, params: params

        parsed_response = JSON.parse(response.body)

        expect(response).to have_http_status(:bad_request)
        expect(parsed_response['code']).to eq 3000
        expect(parsed_response['message']).to eq 'Invalid month'
      end
    end

    context 'with no year param' do
      it 'renders an invalid param error' do
        get endpoint, params: { month: '3' }

        parsed_response = JSON.parse(response.body)

        expect(response).to have_http_status(:bad_request)
        expect(parsed_response['code']).to eq 3000
        expect(parsed_response['message']).to eq 'Invalid year'
      end
    end

    context 'with no month param' do
      it 'renders an invalid param error' do
        get endpoint, params: { year: '2022' }

        parsed_response = JSON.parse(response.body)

        expect(response).to have_http_status(:bad_request)
        expect(parsed_response['code']).to eq 3000
        expect(parsed_response['message']).to eq 'Invalid month'
      end
    end

    context 'with a single char month param' do
      let(:year) {'2022'}
      let(:month) {'3'}
      
      before do
        allow(GetMostViewedArticleInMonth).to receive(:execute).and_call_original
      end

      it 'formats the month for the wikipedia client' do
        get endpoint, params: params

        expect(GetMostViewedArticleInMonth).to have_received(:execute).with(year: '2022', month: '03')
      end
    end
  end
end