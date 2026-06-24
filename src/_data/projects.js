// src/_data/projects.js
// Centralized project metadata
// Enables DRY templates by looping through project data
// Skills are enriched with metadata from the centralized skills.js data file
//
// Thumbnail system: Uses unified slug-based approach
// - Thumbnails auto-discovered from: /images/projects/[id]/thumbnail.jpg
// - Alt text stored in thumbnails.js
// - id field used as slug for thumbnail path generation

const skills = require('./skills.js');

module.exports = [
  {
    id: 'econanalyzr-r-package',
    title: '{econanalzyr}',
    subtitle: 'An R package',
    description: 'The goal of econanalyzr is to provide a collection of functions and helper datasets that help users obtain, analyze, and visualize economic data in a tidyverse adherent way.',
    skillDetails: ['R'].map(skill => skills.getSkill(skill)).filter(Boolean),
    links: {
      demo: 'https://justanesta.github.io/econanalyzr/',
      github: 'https://github.com/justanesta/econanalyzr'
    }
  },
  {
    id: 'consumer-product-recalls',
    title: 'Consumer Product Recalls',
    subtitle: 'Data pipeline, database, API, and website',
    description: 'A data pipeline, database, and API that contain real-time continuously updated data on consumer recalls published by the CPSC, FDA, USDA, NHTSA, and USCG.',
    skillDetails: ['python', 'uv', 'git', 'github-actions', 'postgresql', 'neon', 'alembic', 'dbt'].map(skill => skills.getSkill(skill)).filter(Boolean),
    links: {
      demo: 'https://consumer-product-recalls.info/',
      github: 'https://github.com/justanesta/consumer-product-recalls'
    }
  },
  {
    id: 'middle-class-checker',
    title: 'Middle Class Checker',
    subtitle: 'Data Analysis & Visualization',
    description: 'A site to check how your household compares to the U.S. median and the median of your provided local geography.',
    skillDetails: ['python', 'Django'].map(skill => skills.getSkill(skill)).filter(Boolean),
    links: {
      demo: 'https://www.middleclasscheck.com/',
      github: 'https://github.com/justanesta/middle_class_check'
    }
  }
];
