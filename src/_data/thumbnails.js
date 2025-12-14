// src/_data/thumbnails.js
// Centralized thumbnail metadata for all content types
//
// UNIFIED SLUG-BASED SYSTEM:
// - Posts: /images/posts/[slug]/thumbnail.jpg
// - Projects: /images/projects/[slug]/thumbnail.jpg
// - Bits: /images/bits/[slug]/thumbnail.jpg
//
// Paths are auto-generated from slugs. This file only stores:
// - alt: Descriptive alt text for accessibility
// - ext: Optional file extension override (default: 'jpg')
//
// If no entry exists for a slug, graceful fallback is used.
// Note: Bits typically don't use thumbnails due to their short-form nature.

module.exports = {
  posts: {
    'michael-scott-engagement-ring-cost': {
      alt: 'Michael Scott\'s engagement ring cost analysis'
    },
    'nursing-occupation-analysis': {
      alt: 'Nurses in demand but experiencing burnout'
    },
    'restaurant-industry-analysis': {
      alt: 'Restaurant industry recovery varies by metro area',
      ext: 'jpeg'
    },
    'solar-power-analysis': {
      alt: 'Solar power expansion and correlation vs causation'
    },
    'philly-wfh-analysis': {
      alt: 'Philadelphia work from home attendance patterns'
    },
    '2023-san-diego-padres-broke-my-brain': {
      alt: '2023 San Diego Padres baseball analysis'
    },
    'outlier-nba-scoring': {
      alt: 'Outlier NBA scoring performances analysis'
    },
    'playoff-wins-hall-of-fame-qb-stat': {
      alt: 'Playoff wins and Hall of Fame QB selection'
    },
    'modern-internet-low-interest-rate': {
      alt: 'Modern internet and low interest rate impacts'
    }
  },

  projects: {
    'middle-class-checker': {
      alt: 'Web app to check provided income compared to median household income in specified area'
    },
    'food-safety-recalls': {
      alt: 'Data pipeline to collect, scrape, and present FDA and USDA food safety recalls in real time'
    },
    'econanalyzr-r-package': {
      alt: 'R package with functions to help analyze economic data'
    }
  },

  bits: {
    // Bits typically don't use thumbnails due to their short-form nature
    // Add entries here only if a specific bit needs a thumbnail image
  }
};
