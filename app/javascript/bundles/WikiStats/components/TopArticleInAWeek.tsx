import React, { useState } from 'react';
import { DatePicker, Form, Button, Divider, Statistic, Alert } from 'antd';
import { getTopArticleInAWeek } from '../services/ArticlesApiService';
import { Article } from '../types';


const TopArticleInAWeek = () => {
  const [article, setArticle] = useState<Article>();
  const [errorMessage, setErrorMessage] = useState<string>('');
  const [isLoading, setIsLoading] = useState<boolean>(false);

  const getArticle = async (values: any) => {
    setIsLoading(true);
    
    const response = await getTopArticleInAWeek(values.start_date.format('YYYY-MM-DD'));
    const jsonResponse = await response.json();

    setIsLoading(false);

    if(response.ok){
      setArticle(jsonResponse);
    } else {
      setErrorMessage(jsonResponse.message)
      setArticle(null);
    }
  };

  return (
    <div>
      { errorMessage.length > 0 && (<Alert message={errorMessage} type="error" />) }
      <Divider type="horizontal" />
      <Form
        name="basic"
        style={{ maxWidth: 600 }}
        onFinish={getArticle}
      >
        <Form.Item
          label="Start Date"
          name="start_date"
          rules={[{ required: true, message: 'Please choose a date!' }]}
        >
          <DatePicker picker="date" />
        </Form.Item>

        <Form.Item>
          <Button type="primary" htmlType="submit" loading={isLoading}>
            Submit
          </Button>
        </Form.Item>
      </Form>
      <Divider type="horizontal" />
      <div style={{display: 'flex'}}>
        {article && (<Statistic title="Article Title" value={article.article} />)}
        <Divider type="vertical" />
        {article && (<Statistic title="Views" value={article.views} />)}
      </div>
    </div>

  );
};

export default TopArticleInAWeek;
