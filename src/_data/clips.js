// src/_data/clips.js
// Centralized clips/published work metadata
// Enables DRY templates by looping through clips data

module.exports = [
  // Verywell Health
  {
    id: 'insulin-price-cuts',
    title: 'Insulin Price Cuts Barely Move the Needle for Americans',
    publication: 'Verywell Health',
    date: new Date('2023-04-01'),
    description: 'A look into how much more expensive insulin will be in the U.S. even after industry price cuts in response to the IRA.',
    tags: ['Data Analysis', 'Health', 'Economics'],
    url: 'https://www.verywellhealth.com/american-cost-of-insulin-after-price-cuts-report-7483240'
  },
  {
    id: 'foodborne-illness-culprits',
    title: 'A Verywell Report: These Foods Are the Biggest Culprits of Foodborne Illness',
    publication: 'Verywell Health',
    date: new Date('2023-10-01'),
    description: 'An analysis of CDC foodborne outbreak data of what foods and etiologies have caused the most foodborne illnesses.',
    tags: ['Data Analysis', 'Health'],
    url: 'https://www.verywellhealth.com/foodborne-illness-data-8285944'
  },
  {
    id: 'covid-variants-timeline',
    title: 'Timeline of COVID-19 Variants',
    publication: 'Verywell Health',
    date: new Date('2022-10-01'),
    description: 'A breakdown into the prevalence and spread of the latest COVID-19 variants.',
    tags: ['Data Viz', 'Health'],
    url: 'https://www.verywellhealth.com/covid-variants-timeline-6741198'
  },

  // Investopedia
  {
    id: 'tech-media-layoffs-2022-2023',
    title: "Tech & Media Were Hit Hardest by Past Year's Layoffs",
    publication: 'Investopedia',
    date: new Date('2023-07-01'),
    description: 'A look into the only sector in the U.S. economy that actually experienced layoffs in late 2022 & early 2023.',
    tags: ['Data Analysis', 'Data Viz', 'Economics'],
    url: 'https://www.investopedia.com/tech-and-media-were-hit-hardest-by-past-year-s-layoffs-7565586'
  },
  {
    id: 'millennial-homeownership',
    title: 'Millennial Homeownership Still Lagging Behind Previous Generations',
    publication: 'Investopedia',
    date: new Date('2023-06-01'),
    description: 'An analysis of how millennial homeownership rates are still lower than previous generations at the same age period.',
    tags: ['Data Analysis', 'Data Viz', 'Economics'],
    url: 'https://www.investopedia.com/millennial-homeownership-still-lagging-behind-previous-generations-7510642'
  },
  {
    id: 'nyc-recovery-index',
    title: 'The New York City Recovery Index',
    publication: 'Investopedia',
    date: new Date('2022-12-01'),
    description: "Tracking NYC's economic recovery from the COVID-19 pandemic with NY1.",
    tags: ['Data Analysis', 'Local', 'Economics'],
    url: 'https://www.investopedia.com/new-york-city-nyc-economic-recovery-index-5072042'
  },
  {
    id: 'us-labor-market-recovery',
    title: 'The U.S. Labor Market Recovery in Charts',
    publication: 'Investopedia',
    date: new Date('2022-09-01'),
    description: 'An analysis of how the U.S. economy recovered all the jobs it lost in the COVID-19 pandemic recession.',
    tags: ['Data Analysis', 'Data Viz', 'Economics'],
    url: 'https://www.investopedia.com/the-u-s-labor-market-recovery-in-charts-6541384'
  },
  {
    id: 'nyc-economic-tracker',
    title: 'The New York City Economic Tracker',
    publication: 'Investopedia',
    date: new Date('2025-03-01'),
    description: 'A biweekly story analyzing an aspect the New York City economy with NY1.',
    tags: ['Data Analysis', 'Data Viz', 'Local', 'Economics'],
    url: 'https://www.investopedia.com/the-new-york-city-economy-tracker-7104393'
  },

  // The Balance
  {
    id: 'gas-prices-minimum-wage',
    title: '21% of Minimum Wage Earnings Guzzled by Gas Prices',
    publication: 'The Balance',
    date: new Date('2022-06-01'),
    description: "A look into how much rising gas prices are eating into minimum wage worker's earnings.",
    tags: ['Data Analysis', 'Data Viz', 'Economics'],
    url: 'https://www.thebalancemoney.com/21-percent-of-minimum-wage-earnings-guzzled-by-gas-prices-5425525'
  },
  {
    id: 'minimum-wage-worth-less',
    title: 'Earning the Federal Minimum Wage Is Worth 17% Less Now',
    publication: 'The Balance',
    date: new Date('2022-05-01'),
    description: 'An analysis of how some states raising their minimum wage has changed the overall minimum wage workforce.',
    tags: ['Data Analysis', 'Data Viz', 'Economics'],
    url: 'https://www.thebalancemoney.com/earning-the-federal-minimum-wage-is-worth-17-percent-less-now-5270858'
  },
  {
    id: 'heating-costs-inflation',
    title: 'Heating Your Home May Cost Over 25% More This Year',
    publication: 'The Balance',
    date: new Date('2021-12-01'),
    description: 'Looking into CPI data on the inflation impacts in home heating and energy costs for the winter of 2021 - 2022.',
    tags: ['Data Analysis', 'Data Viz', 'Economics'],
    url: 'https://www.thebalancemoney.com/heating-your-home-may-cost-over-25-more-this-year-5213351'
  },
  {
    id: 'homebuying-costs',
    title: 'The Average Cost of Buying a Home in the US',
    publication: 'The Balance',
    date: new Date('2023-02-01'),
    description: 'A deep dive into the breakout of the main homebuying costs in the largest US metro areas.',
    tags: ['Data Analysis', 'Economics', 'Housing'],
    url: 'https://www.thebalancemoney.com/the-average-cost-of-buying-a-home-in-the-us-5323803'
  },
  {
    id: 'home-owning-costs',
    title: 'The Average Cost of Owning a Home in the US',
    publication: 'The Balance',
    date: new Date('2023-02-01'),
    description: 'A deep dive into the breakout of the main home owning costs in the largest US metro areas.',
    tags: ['Data Analysis', 'Economics', 'Housing'],
    url: 'https://www.thebalancemoney.com/the-average-cost-of-owning-a-home-in-the-us-5323804'
  },

  // City Limits
  {
    id: 'nyc-homeless-shelter-population',
    title: "Tracking NYC's Record-High Homeless Shelter Population",
    publication: 'City Limits',
    date: new Date('2023-12-01'),
    description: 'An analysis of the growth in the number and the change in the family structure of people staying in NYC homeless shelters from 2022 to 2023.',
    tags: ['Data Analysis', 'Local', 'Housing'],
    url: 'https://citylimits.org/2023/12/07/tracking-nycs-record-high-homeless-shelter-population/'
  },

  // Greater Greater Washington
  {
    id: 'dc-driving-citations-covid',
    title: 'DC driving citations spike during the early stages of COVID-19',
    publication: 'Greater Greater Washington',
    date: new Date('2020-08-01'),
    description: 'A look into rising driving crashes and violations in Washington, DC at the start of the COVID-19 pandemic.',
    tags: ['Data Analysis', 'Mapping', 'Local'],
    url: 'https://ggwash.org/view/78645/dc-driving-violations-spike-and-crashes-descrease-during-the-early-stages-of-covid-19'
  },
  {
    id: 'dc-bike-crashes-pandemic',
    title: 'How bike crashes shifted out of downtown DC during the pandemic',
    publication: 'Greater Greater Washington',
    date: new Date('2020-10-01'),
    description: 'An analysis with maps looking into the geographic shift in bicycle accident location changes in the COVID-19 pandemic.',
    tags: ['Data Analysis', 'Mapping', 'Local'],
    url: 'https://ggwash.org/view/79134/how-the-bike-crashes-shifted-out-of-downtown-dc-during-the-pandemic'
  }
];