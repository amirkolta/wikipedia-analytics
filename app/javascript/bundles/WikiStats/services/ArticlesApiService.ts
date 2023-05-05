import { Article } from "../types";

const API_V1_HEADERS = { 'Content-Type': 'application/json' }
const API_V1_BASE_URL = '/api/v1/articles'

export const getTopArticleInAMonth = (
  startDate: string,
): Promise<any> => {
  const params = new URLSearchParams();
  params.set('start_date', startDate);

  const url = `${API_V1_BASE_URL}/most_viewed_in_a_month?${params.toString()}`;

  return fetch(url, {
    method: 'GET',
    headers: API_V1_HEADERS
  })
}

export const getTopArticleInAWeek = async (
  startDate: string,
) => {
  const params = new URLSearchParams();
  params.set('start_date', startDate);

  const url = `${API_V1_BASE_URL}/most_viewed_in_a_week?${params.toString()}`;

  return fetch(url, {
    method: 'GET',
    headers: API_V1_HEADERS
  })
}

export const getArticleViewsInAMonth = async (
  title: string,
  startDate: string,
) => {
  const params = new URLSearchParams();
  params.set('start_date', startDate);

  const url = `${API_V1_BASE_URL}/${title}/month_views?${params.toString()}`;

  return fetch(url, {
    method: 'GET',
    headers: API_V1_HEADERS
  })
}

export const getArticleViewsInAWeek = async (
  title: string,
  startDate: string,
) => {
  const params = new URLSearchParams();
  params.set('start_date', startDate);

  const url = `${API_V1_BASE_URL}/${title}/week_views?${params.toString()}`;

  return fetch(url, {
    method: 'GET',
    headers: API_V1_HEADERS
  })
}

export const getAticleTopViewedDayInAMonth = async (
  title: string,
  startDate: string,
) => {
  const params = new URLSearchParams();
  params.set('start_date', startDate);

  const url = `${API_V1_BASE_URL}/${title}/top_viewed_day_in_a_month?${params.toString()}`;

  return fetch(url, {
    method: 'GET',
    headers: API_V1_HEADERS
  })
}