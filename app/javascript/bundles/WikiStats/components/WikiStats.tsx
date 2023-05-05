import React from 'react';
import { Tabs, Layout, Menu } from 'antd';
import type { TabsProps, MenuProps } from 'antd';
import TopArticleInAMonth from './TopArticleInAMonth';
import TopArticleInAWeek from './TopArticleInAWeek';
import ArticleViewsInAMonth from './ArticleViewsInAMonth';
import ArticleViewsInAWeek from './ArticleViewsInAWeek';
import ArticleTopViewedDayInAMonth from './ArticleTopViewedDayInAMonth';

const { Header, Content } = Layout;

const WikiStats = () => {
  const items: TabsProps['items'] = [
    {
      key: '1',
      label: `Top Article in a Month`,
      children: <TopArticleInAMonth/>,
    },
    {
      key: '2',
      label: `Top Article in a Week`,
      children: <TopArticleInAWeek/>,
    },
    {
      key: '3',
      label: `Article Views for a Month`,
      children: <ArticleViewsInAMonth/>,
    },
    {
      key: '4',
      label: `Article Views for a Week`,
      children: <ArticleViewsInAWeek/>,
    },
    {
      key: '5',
      label: `Article most viewed day in a month`,
      children: <ArticleTopViewedDayInAMonth/>,
    },
  ];

  const headerMenuItem: MenuProps['items'] = [
    {
      key: '1',
      label: 'Wikipedia Stats',
    }
  ];

  return (
    <Layout className="layout">
      <Header>
        <Menu 
          theme="dark" 
          mode="horizontal" 
          defaultSelectedKeys={["1"]}
          href="/wiki_stats"
          items={headerMenuItem}
        />
      </Header>
      <Content style={{ paddingTop: "20px"}}>
        <div className="site-layout-content">
          <Tabs
              tabPosition='left'
              items={items}
            />
        </div>
      </Content>
    </Layout>
  );
};

export default WikiStats;
