import ReactOnRails from 'react-on-rails';

import WikiStats from '../bundles/WikiStats/WikiStatsServer';

// This is how react_on_rails can see the WikiStats in the browser.
ReactOnRails.register({
  WikiStats,
});
