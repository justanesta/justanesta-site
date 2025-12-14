module.exports = {
  // Basic Info
  moniker: "justanesta",
  name: "Adrian Nesta",
  
  // Site Metadata
  title: "Adrian Nesta - Portfolio & Blog",
  description: "Otherwise known as just A. Nesta. I'm a data professional creating stories & tools through web development, data engineering, data analysis and visualization.",
  tagline: "Data journalist and developer",
  url: process.env.URL || "https://justanesta.com",
  
  // Location & Bio
  location: "Philadelphia, PA",
  locationShort: "Philadelphia",
  bio: "I'm a data journalist and developer based in Philadelphia. I use data analysis, visualization, and code to find and tell stories that matter.",
  
  // Social Media (update with your actual handles)
  social: {
    github: "https://github.com/justanesta",
    githubUsername: "justanesta",
        
    linkedin: "https://linkedin.com/in/justanesta",
    linkedinUsername: "justanesta",

    email: "mailto:adrian@justanesta.com",
    bluesky: "https://bsky.app/profile/justanesta.com",
  },
  
  // Professional Info
  profession: "Data Journalist",

  // Site Navigation (for dynamic menu generation)
  nav: [
    { url: "/blog/", label: "Blog", icon: "fa-pen" },
    { url: "/bits/", label: "Bits", icon: "fa-lightbulb" },
    { url: "/archive/", label: "Archive", icon: "fa-folder-open" },
    { url: "/projects/", label: "Projects", icon: "fa-code" },
    { url: "/clips/", label: "Clips", icon: "fa-newspaper" },
    { url: "/about/", label: "About", icon: "fa-user" },
    { url: "/search/", label: "Search", icon: "fa-search" }
  ],
  
  // Build Info (automatically set)
  buildTime: new Date(),
  
  // SEO & Social Sharing
  seo: {
    image: "/images/social-card.jpg"
  },
  
  // Education (for About page)
  education: [
    {
      degree: "Bachelor of Arts, International Studies",
      school: "American University",
      year: "2016",
      location: "Washington, DC"
    }
    // Add more degrees as needed
  ],
  
  // Positions (for About page)
  positions: [
    {
      title: "Data Journalist",
      organization: "Fingerpaint Marketing",
      description: "Working on Fingerpaint's wetpAInt applied AI team. Creating insightful data stories for healthcare clients with open source and social media data. Spearheading development of AI-enhanced brand sentiment monitoring tool with end-to-end automation.",
      location: "Philadelphia, PA",
      startDate: "2025",
      endDate: "Present"
    },
    {
      title: "Senior Data Reporter",
      organization: "People, Inc",
      description: "Worked on People Inc.'s data journalism team to report on economics, health, and other stories for websites such as Investopedia, Verywell Health, Travel + Leisure, Southern Living, and others. Created timely data stories with novel analyses and compelling visualizations with site editorial teams to inform readers.",
      location: "New York, NY",
      startDate: "2020",
      endDate: "2025"
    }
  ],

  // Site Settings
  settings: {
    postsPerPage: 10,
    recentPostsCount: 5,
    excerptLength: 150,
    dateFormat: "MMMM DD, YYYY",
    
    // Feature flags
    features: {
      search: false,  // Enable site search (requires implementation)
      comments: false,  // Enable comments (requires implementation)
      newsletter: false,  // Enable newsletter signup
      darkMode: false  // Enable dark mode toggle
    }
  },

  // Copyright
  copyrightYear: new Date().getFullYear(),
  copyrightName: "Adrian Nesta",
  license: "CC BY-SA 4.0",  // Or "All rights reserved", etc.
  
  // Repository (if your site is open source)
  repo: {
    url: "https://github.com/justanesta/justanesta-site",
    branch: "main"
  }
};