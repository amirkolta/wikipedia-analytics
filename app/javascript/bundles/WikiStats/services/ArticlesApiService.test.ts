import fetch from 'jest-fetch-mock';
import { getTopArticleInAMonth } from "./ArticlesApiService";

describe("getTopArticleInAMonth", () => {
  beforeEach(() => {
    jest.clearAllMocks();
    fetch.mockResponseOnce(JSON.stringify({article: 'Main Page', views: 5000}));
  });

  test("it sends the correct fetch request", async () => {
    const articleResponse = await getTopArticleInAMonth('2023-02');
    const jsonResponse = await articleResponse.json();

    expect(fetch).toHaveBeenCalledWith(
      '/api/v1/articles/most_viewed_in_a_month?start_date=2023-02', 
      { "headers": {"Content-Type": "application/json"}, "method": "GET" }
    );
    expect(jsonResponse.article).toBe('Main Page');
    expect(jsonResponse.views).toBe(5000);
  });
});