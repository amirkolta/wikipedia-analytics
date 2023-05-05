import React, { useState } from 'react';
import { DatePicker, Form, Button, Divider, Statistic, Alert, Input } from 'antd';
import { getArticleViewsInAWeek } from '../services/ArticlesApiService';


const ArticleViewsInAWeek = () => {
  const [articleViews, setArticleViews] = useState<number>();
  const [errorMessage, setErrorMessage] = useState<string>('');
  const [isLoading, setIsLoading] = useState<boolean>(false);

  const getArticleViews = async (values: any) => {
    setIsLoading(true);
    
    const response = await getArticleViewsInAWeek(values.title, values.start_date.format('YYYY-MM-DD'));
    const jsonResponse = await response.json();

    setIsLoading(false);
    
    if(response.ok){
      setArticleViews(jsonResponse);
    } else {
      setErrorMessage(jsonResponse.message)
      setArticleViews(null);
    }
  };

  return (
    <div>
      { errorMessage.length > 0 && (<Alert message={errorMessage} type="error" />) }
      <Divider type="horizontal" />
      <Form
        name="basic"
        style={{ maxWidth: 600 }}
        onFinish={getArticleViews}
      >
        <Form.Item
          label="Article Title"
          name="title"
          rules={[{ required: true, message: 'Please provide a title!' }]}
        >
          <Input />
        </Form.Item>
        <Form.Item
          label="Start Date"
          name="start_date"
          rules={[{ required: true, message: 'Please choose a date!' }]}
        >
          <DatePicker picker="day" />
        </Form.Item>
        <Form.Item>
          <Button type="primary" htmlType="submit" loading={isLoading}>
            Submit
          </Button>
        </Form.Item>
      </Form>
      <Divider type="horizontal" />
      <div style={{display: 'flex'}}>
        <Divider type="vertical" />
        {articleViews && (<Statistic title="Views" value={articleViews} />)}
      </div>
    </div>

  );
};

export default ArticleViewsInAWeek;
