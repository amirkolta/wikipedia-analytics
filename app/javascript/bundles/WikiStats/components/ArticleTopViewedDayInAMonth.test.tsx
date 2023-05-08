import React from "react";
import { act, fireEvent, render, screen, waitFor } from "@testing-library/react";
import fetch from 'jest-fetch-mock';

import ArticleTopeViewedDayInAMonth from "./ArticleTopViewedDayInAMonth";

describe("ArticleTopeViewedDayInAMonth", () => {
  beforeEach(() => {
    jest.clearAllMocks();
    fetch.mockResponseOnce('4');
  });

  test("it sends the correct fetch request", async () => {
    render(<ArticleTopeViewedDayInAMonth/>);
     
    const startDate = screen.getByTestId("start_date");
    fireEvent.mouseDown(startDate);
    fireEvent.change(startDate, { target: { value: "2023-02" } });
    fireEvent.click(document.querySelectorAll(".ant-picker-cell-selected")[0]);
    
    const articleTitle = screen.getByTestId("article_title");
    fireEvent.change(articleTitle, { target: { value: "Test Article" } });
    
    act(() => {
      fireEvent.click(screen.getByText('Submit'));
    });


    await waitFor(() => {
      expect(fetch.mock.calls.length).toEqual(1)
      expect(fetch.mock.calls[0][0]).toEqual('/api/v1/articles/Test Article/top_viewed_day_in_a_month?start_date=2023-02')
    });
  });

  test("it renders the result", async () => {
    render(<ArticleTopeViewedDayInAMonth/>);
     
    const startDate = screen.getByTestId("start_date");
    fireEvent.mouseDown(startDate);
    fireEvent.change(startDate, { target: { value: "2023-02" } });
    fireEvent.click(document.querySelectorAll(".ant-picker-cell-selected")[0]);
    
    const articleTitle = screen.getByTestId("article_title");
    fireEvent.change(articleTitle, { target: { value: "Test Article" } });
    
    act(() => {
      fireEvent.click(screen.getByText('Submit'));
    });


    await waitFor(() => {
      expect(screen.getByText('Top Day')).toBeInTheDocument();
      expect(document.querySelectorAll(".ant-statistic-content-value-int")[0]).toBeInTheDocument();
      expect(document.querySelectorAll(".ant-statistic-content-value-int")[0]).toHaveTextContent('4');
    });
  });
});