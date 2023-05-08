# **WikiStats**

This apps acts as a simple wrapper to the Wikipedia Metrics API.

## **Features:**

1. Get the most viewed article in a certain month.
2. Get the most viewed article in a ceratin week.
3. Get the view count for a certain article in a certain month.
4. Get the view count for a certain article in a certain week.
5. Get the day of the month where an article was viewed the most.

## **Setup**

* Note: Feel free to skip all that and jump straight to https://young-smoke-8670.fly.dev/

1. First you'll need to make sure that you have `rbenv` and `yarn` installed.


    You can install them by running

    ```bash
      brew install rbenv
    ```
    &
    ```bash
      brew install yarn
    ```

2. Run this to install all gems and Javascript packages

    ```bash
      bin/setup
    ```

3. To start the app

    ```bash
      bin/dev
    ```

## **Ways to test**

### 1. Through the user interface: 
  * Check it out at https://young-smoke-8670.fly.dev/
  * You can also do this by going to localhost:3000 after booting up the server locally.
### 2. Through the API:
  * If you don't want to load the UI at all and would rather just send requests to the API endpoints using something like curl or Postman.

## **API Doc**

<details>
<summary><code>1. Most viewed article in a month</code></summary>

* Path: `/api/v1/articles/most_viewed_in_a_month`
* Method: `GET`
* Headers: `Content-Type: application/json`
* Query Parameters: 
  * `start_date` => 'YYYY-MM'
* Success Response:
  * Status: 200
  * Schema:
    ```
      {
        article: string,
        views: integer,
      }
    ```
* Error Response:
  * Missing `start_date`
    * Status: 400
    * Schema:
      ```
        {
          code: 3000,
          message: 'Missing date',
        }
      ```
  * Invalid `start_date`
    * Status: 400
    * Schema:
      ```
        {
          code: 3000,
          message: 'Invalid date',
        }
      ```
* Example cURL
  ```bash
    curl -X GET -H "Content-Type: application/json" 'http://localhost:3000/api/v1/articles/most_viewed_in_a_month?start_date=2023-02'
  ```
</details>

<details>
<summary><code>2. Most viewed article in a week</code></summary>

* Path: `/api/v1/articles/most_viewed_in_a_week`
* Method: `GET`
* Headers: `Content-Type: application/json`
* Query Parameters: 
  * `start_date` => 'YYYY-MM-DD'
* Success Response:
  * Status: 200
  * Schema:
    ```
      {
        article: string,
        views: integer,
      }
    ```
* Error Response:
  * Missing `start_date`
    * Status: 400
    * Schema:
      ```
        {
          code: 3000,
          message: 'Missing date',
        }
      ```
  * Invalid `start_date`
    * Status: 400
    * Schema:
      ```
        {
          code: 3000,
          message: 'Invalid date',
        }
      ```
* Example cURL
  ```bash
    curl -X GET -H "Content-Type: application/json" 'http://localhost:3000/api/v1/articles/most_viewed_in_a_week?start_date=2023-02-12'
  ```
</details>

<details>
<summary><code>3. Article view count for a month</code></summary>

* Path: `/api/v1/articles/:title/month_views`
* Method: `GET`
* Headers: `Content-Type: application/json`
* URL Parameters:
  * `title`
* Query Parameters: 
  * `start_date` => 'YYYY-MM'
* Success Response:
  * Status: 200
  * Response: 25000
* Error Response:
  * Missing `start_date`
    * Status: 400
    * Schema:
      ```
        {
          code: 3000,
          message: 'Missing date',
        }
      ```
  * Invalid `start_date`
    * Status: 400
    * Schema:
      ```
        {
          code: 3000,
          message: 'Invalid date',
        }
      ```
  * Missing `title`
    * Status: 404

* Example cURL
  ```bash
    curl -X GET -H "Content-Type: application/json" 'http://localhost:3000/api/v1/articles/Dave%20Matthews%20Band/month_views?start_date=2022/1'
  ```
</details>


<details>
<summary><code>4. Article view count for a week</code></summary>

* Path: `/api/v1/articles/:title/week_views`
* Method: `GET`
* Headers: `Content-Type: application/json`
* URL Parameters:
  * `title`
* Query Parameters: 
  * `start_date` => 'YYYY-MM-DD'
* Success Response:
  * Status: 200
  * Response: 25000
* Error Response:
  * Missing `start_date`
    * Status: 400
    * Schema:
      ```
        {
          code: 3000,
          message: 'Missing date',
        }
      ```
  * Invalid `start_date`
    * Status: 400
    * Schema:
      ```
        {
          code: 3000,
          message: 'Invalid date',
        }
      ```
  * Missing `title`
    * Status: 404

* Example cURL
  ```bash
    curl -X GET -H "Content-Type: application/json" 'http://localhost:3000/api/v1/articles/Dave%20Matthews%20Band/week_views?start_date=2022-01-16'
  ```
</details>

<details>
<summary><code>5. Day of the month on which an article was viewed the most</code></summary>

* Path: `/api/v1/articles/:title/top_viewed_day_in_a_month`
* Method: `GET`
* Headers: `Content-Type: application/json`
* URL Parameters:
  * `title`
* Query Parameters: 
  * `start_date` => 'YYYY-MM'
* Success Response:
  * Status: 200
  * Response: 14
* Error Response:
  * Missing `start_date`
    * Status: 400
    * Schema:
      ```
        {
          code: 3000,
          message: 'Missing date',
        }
      ```
  * Invalid `start_date`
    * Status: 400
    * Schema:
      ```
        {
          code: 3000,
          message: 'Invalid date',
        }
      ```
  * Missing `title`
    * Status: 404

* Example cURL
  ```bash
    curl -X GET -H "Content-Type: application/json" 'http://localhost:3000/api/v1/articles/Dave%20Matthews%20Band/top_viewed_day_in_a_mont?start_date=2022-01-16'
  ```
</details>

<details>
<summary><code>Wikiepedia API Failure</code></summary>

  * Status: 502 (Bad Gateway)
  * Schema:
    ```
      {
        code: 4000,
        message: string,
      }
    ```
</details>


## **Running Rspec tests**
```bash
  rspec
```

## **Running Jest tests**
```bash
  yarn test
```