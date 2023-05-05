require 'rails_helper'

describe WikipediaClient::PageViews do
  subject(:client) { WikipediaClient::PageViews }
  let(:headers) {{accept: 'application/json'}}

  describe '.top' do
    let(:year){'2022'}
    let(:month){'02'}
    let(:day){'21'}
    let(:access){'mobile-app'}

    context 'when it is a successful request' do
      let(:wikipedia_response_body) do
        {
          "items" => [
            {
              "project"=>"en.wikipedia",
              "access"=>"all-access",
              "year"=>"2022",
              "month"=>"03",
              "day"=>"02",
              "articles" => [
                {"article"=>"Main_Page", "views"=>4989, "rank"=>1},
                {"article"=>"Special:Search", "views"=>3104, "rank"=>2},
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
      let(:wikipedia_response) { instance_double(HTTParty::Response, body: wikipedia_response_body.to_json, code: 200) }

      before do
        allow(HTTParty).to receive(:get).and_return(wikipedia_response)
        allow(wikipedia_response).to receive(:success?).and_return(true)
      end

      context 'with full params' do
        let(:wikipedia_url) { 'https://wikimedia.org/api/rest_v1/metrics/pageviews/top/en.wikipedia/mobile-app/2022/02/21' }
  
        it 'responds with the expected format' do
          response = client.top(access: access, year: year, month: month, day: day)
  
          expect(HTTParty).to have_received(:get).with(wikipedia_url, headers: headers)
          expect(response).to eq(success_client_response)
        end
      end

      context 'without the day param' do
        let(:wikipedia_url) { 'https://wikimedia.org/api/rest_v1/metrics/pageviews/top/en.wikipedia/mobile-app/2022/02/all-days' }

        it 'sends the day param as "all-days"' do
          response = client.top(access: access, year: year, month: month)
  
          expect(HTTParty).to have_received(:get).with(wikipedia_url, headers: headers)
          expect(response).to eq(success_client_response)
        end
      end

      context 'without the access param' do
        let(:wikipedia_url) { 'https://wikimedia.org/api/rest_v1/metrics/pageviews/top/en.wikipedia/all-access/2022/02/all-days' }

        it 'sends the access param as "all-access"' do
          response = client.top(year: year, month: month)
  
          expect(HTTParty).to have_received(:get).with(wikipedia_url, headers: headers)
          expect(response).to eq(success_client_response)
        end
      end
    end


    context 'failed request' do
      let(:wikipedia_response_body) do
        {         
          "type": "https://mediawiki.org/wiki/HyperSwitch/errors/invalid_request",
          "method": "get",
          "detail": [
              "Given year/month/day is invalid date"
          ],
          "uri": "/analytics.wikimedia.org/v1/pageviews/top/en.wikipedia/all-access/2015/10/all-day"
        }
      end
      let(:failed_client_response) do
        "Given year/month/day is invalid date"
      end
      let(:wikipedia_response) { instance_double(HTTParty::Response, body: wikipedia_response_body.to_json, code: 400) }

      before do
        allow(HTTParty).to receive(:get).and_return(wikipedia_response)
        allow(wikipedia_response).to receive(:success?).and_return(false)
      end

      it 'raises an error with the error message' do
        expect{
          client.top(access: access, year: year, month: month, day: day)
        }.to raise_error(WikipediaClient::PageViews::WikipediaAPIError, failed_client_response)
      end
    end
  end

  describe '.per_article' do
    let(:article){'Dave Matthews Band'}
    let(:start_date){'20230201'}
    let(:end_date){'20230301'}
    let(:access){'mobile-app'}

    context 'when it is a successful request' do
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
      let(:wikipedia_response) { instance_double(HTTParty::Response, body: wikipedia_response_body.to_json, code: 200) }

      before do
        allow(HTTParty).to receive(:get).and_return(wikipedia_response)
        allow(wikipedia_response).to receive(:success?).and_return(true)
      end

      context 'with monthly granularity' do
        let(:granularity){'monthly'}
        let(:wikipedia_url) { 'https://wikimedia.org/api/rest_v1/metrics/pageviews/per-article/en.wikipedia/mobile-app/all-agents/Dave_Matthews_Band/monthly/20230201/20230301' }
  
        it 'responds with the expected format and sends the monthly granularity' do
          response = client.per_article(access: access, article: article, start_date: start_date, end_date: end_date, granularity: granularity)
  
          expect(HTTParty).to have_received(:get).with(wikipedia_url, headers: headers)
          expect(response).to eq(success_client_response)
        end


      end

      context 'with daily granularity' do
        let(:granularity){'daily'}
        let(:wikipedia_url) { 'https://wikimedia.org/api/rest_v1/metrics/pageviews/per-article/en.wikipedia/mobile-app/all-agents/Dave_Matthews_Band/daily/20230201/20230301' }
  
        it 'responds with the expected format and sends the daily granularity' do
          response = client.per_article(access: access, article: article, start_date: start_date, end_date: end_date, granularity: granularity)
  
          expect(HTTParty).to have_received(:get).with(wikipedia_url, headers: headers)
          expect(response).to eq(success_client_response)
        end
      end

      context 'with no granularity' do
        let(:wikipedia_url) { 'https://wikimedia.org/api/rest_v1/metrics/pageviews/per-article/en.wikipedia/mobile-app/all-agents/Dave_Matthews_Band/daily/20230201/20230301' }
  
        it 'defaults to daily' do
          client.per_article(access: access, article: article, start_date: start_date, end_date: end_date)
  
          expect(HTTParty).to have_received(:get).with(wikipedia_url, headers: headers)
        end
      end

      context 'with no access' do
        let(:wikipedia_url) { 'https://wikimedia.org/api/rest_v1/metrics/pageviews/per-article/en.wikipedia/all-access/all-agents/Dave_Matthews_Band/daily/20230201/20230301' }
  
        it 'defaults to all-access' do
          client.per_article(article: article, start_date: start_date, end_date: end_date)
  
          expect(HTTParty).to have_received(:get).with(wikipedia_url, headers: headers)
        end
      end

      context 'with an article that includes special characters' do
        let(:article){'Dave Matthews Band&'}
        let(:wikipedia_url) { 'https://wikimedia.org/api/rest_v1/metrics/pageviews/per-article/en.wikipedia/mobile-app/all-agents/Dave_Matthews_Band%26/daily/20230201/20230301' }

        it 'sanitizes the article title and replaces spaces with underscores' do
          client.per_article(access: access, article: article, start_date: start_date, end_date: end_date)
  
          expect(HTTParty).to have_received(:get).with(wikipedia_url, headers: headers)
        end
      end
    end


    context 'failed request' do
      let(:wikipedia_response_body) do
        {
          "type": "https://mediawiki.org/wiki/HyperSwitch/errors/invalid_request",
          "method": "get",
          "detail": [
              "start timestamp should be before the end timestamp",
              "no full months found in specified date range"
          ],
          "uri": "/analytics.wikimedia.org/v1/pageviews/per-article/en.wikipedia/all-access/all-agents/Dave_Matthews_Band/monthly/2023101/20230201"
        }
      end
      let(:failed_client_response) do
        [
          "start timestamp should be before the end timestamp",
          "no full months found in specified date range"
        ].join('\n')
      end
      let(:wikipedia_response) { instance_double(HTTParty::Response, body: wikipedia_response_body.to_json, code: 400) }

      before do
        allow(HTTParty).to receive(:get).and_return(wikipedia_response)
        allow(wikipedia_response).to receive(:success?).and_return(false)
      end

      it 'raises an error with the error message' do
        expect{
          client.per_article(article: article, start_date: start_date, end_date: end_date)
        }.to raise_error(WikipediaClient::PageViews::WikipediaAPIError, failed_client_response)
      end
    end
  end
end