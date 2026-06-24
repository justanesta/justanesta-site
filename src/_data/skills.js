// src/_data/skills.js
// Centralized skill definitions with metadata (icons, colors, categories)
// This is the single source of truth for all skills used across the site
// Can be imported by other data files or used in templates via filters

module.exports = {
  categories: [
    {
      id: 'programming',
      name: 'Programming & Development',
      icon: 'fa-code',
      bulmaColor: 'is-link'
    },
    {
      id: 'data-visualization',
      name: 'Data Visualization',
      icon: 'fa-chart-column',
      bulmaColor: 'is-info'
    },
    {
      id: 'mapping-gis',
      name: 'Mapping & GIS',
      icon: 'fa-map',
      bulmaColor: 'is-success'
    },
    {
      id: 'data-analysis',
      name: 'Data Analysis',
      icon: 'fa-magnifying-glass-chart',
      bulmaColor: 'is-warning'
    },
    {
      id: 'data-engineering',
      name: 'Data Engineering & Management',
      icon: 'fa-server',
      bulmaColor: 'is-danger'
    }
  ],

  // Flat lookup by skill name (lowercase for case-insensitive matching)
  byName: {
    // Programming & Development
    python: {
      name: 'python',
      displayName: 'Python',
      icon: 'fab fa-python',
      category: 'programming',
      aliases: ['Python', 'PYTHON', 'py']
    },
    r: {
      name: 'r',
      displayName: 'R',
      icon: 'fab fa-r-project',
      category: 'programming',
      aliases: ['R', 'r-project']
    },
    // javascript: {
    //   name: 'javascript',
    //   displayName: 'JavaScript',
    //   icon: 'fab fa-js',
    //   category: 'programming',
    //   aliases: ['JavaScript', 'JS', 'js']
    // },
    sql: {
      name: 'sql',
      displayName: 'SQL',
      icon: 'fas fa-database',
      category: 'programming',
      aliases: ['SQL', 'sql']
    },
    django: {
      name: 'django',
      displayName: 'Django',
      icon: 'fas fa-laptop-code',
      category: 'programming',
      aliases: ['Django', 'django']
    },
    fastapi: {
      name: 'FastAPI',
      displayName: 'fastAPI',
      icon: 'fas fa-forward-fast',
      category: 'programming',
      aliases: ['FastAPI', 'fastapi']
    },
    uv: {
      name: 'uv',
      displayName: 'uv',
      icon: 'fas fa-sun',
      category: 'programming',
      aliases: ['uv', 'UV']
    },
    // nodejs: {
    //   name: 'nodejs',
    //   displayName: 'Node.js',
    //   icon: 'fab fa-node-js',
    //   category: 'programming',
    //   aliases: ['Node.js', 'nodejs', 'node']
    // },

    // Data Visualization
    datawrapper: {
      name: 'datawrapper',
      displayName: 'Datawrapper',
      icon: 'fas fa-chart-area',
      category: 'data-visualization',
      aliases: ['Datawrapper', 'datawrapper']
    },
    flourish: {
      name: 'flourish',
      displayName: 'Flourish',
      icon: 'fas fa-asterisk',
      category: 'data-visualization',
      aliases: ['Flourish', 'flourish']
    },
    ggplot2: {
      name: 'ggplot2',
      displayName: 'ggplot2',
      icon: 'fas fa-chart-line',
      category: 'data-visualization',
      aliases: ['ggplot2', '{ggplot2}']
    },

    // Mapping & GIS
    mapbox: {
      name: 'mapbox',
      displayName: 'Mapbox',
      icon: 'fas fa-map-pin',
      category: 'mapping-gis',
      aliases: ['Mapbox', 'mapbox']
    },
    leaflet: {
      name: 'leaflet',
      displayName: 'Leaflet',
      icon: 'fas fa-leaf',
      category: 'mapping-gis',
      aliases: ['Leaflet', 'leaflet']
    },
    qgis: {
      name: 'qgis',
      displayName: 'QGIS',
      icon: 'fas fa-q',
      category: 'mapping-gis',
      aliases: ['QGIS', 'qgis']
    },
    geopandas: {
      name: 'geopandas',
      displayName: 'GeoPandas',
      icon: 'fas fa-location-dot',
      category: 'mapping-gis',
      aliases: ['GeoPandas', 'geopandas']
    },
    sf: {
      name: 'sf',
      displayName: '{sf}',
      icon: 'fas fa-map-location-dot',
      category: 'mapping-gis',
      aliases: ['{sf}', 'sf']
    },

    // Data Analysis
    pandas: {
      name: 'pandas',
      displayName: 'pandas',
      icon: 'fas fa-table',
      category: 'data-analysis',
      aliases: ['pandas', 'Pandas']
    },
    numpy: {
      name: 'numpy',
      displayName: 'NumPy',
      icon: 'fas fa-arrow-down-1-9',
      category: 'data-analysis',
      aliases: ['NumPy', 'numpy']
    },
    tidyverse: {
      name: 'tidyverse',
      displayName: 'tidyverse',
      icon: 'fas fa-align-justify',
      category: 'data-analysis',
      aliases: ['tidyverse', 'Tidyverse']
    },
    sqlite: {
      name: 'sqlite',
      displayName: 'SQLite',
      icon: 'fas fa-feather-pointed',
      category: 'data-analysis',
      aliases: ['SQLite', 'sqlite']
    },

    // Data Engineering & Management
    git: {
      name: 'git',
      displayName: 'git',
      icon: 'fab fa-git-alt',
      category: 'data-engineering',
      aliases: ['git', 'Git']
    },
    snowflake: {
      name: 'snowflake',
      displayName: 'Snowflake',
      icon: 'fas fa-snowflake',
      category: 'data-engineering',
      aliases: ['Snowflake', 'snowflake']
    },
    aws: {
      name: 'aws',
      displayName: 'AWS',
      icon: 'fab fa-aws',
      category: 'data-engineering',
      aliases: ['AWS', 'aws']
    },
    'github-actions': {
      name: 'github-actions',
      displayName: 'GitHub Actions',
      icon: 'fab fa-square-github',
      category: 'data-engineering',
      aliases: ['GitHub Actions', 'github-actions']
    },
    postgresql: {
      name: 'postgresql',
      displayName: 'PostgreSQL',
      icon: 'fab fa-postgresql',
      category: 'data-engineering',
      aliases: ['PostgreSQL', 'postgresql', 'postgres']
    },
    neon: {
      name: 'neon',
      displayName: 'Neon',
      icon: 'fas fa-database',
      category: 'data-engineering',
      aliases: ['Neon', 'neon']
    },
    dbt: {
      name: 'dbt',
      displayName: 'dbt',
      icon: 'fas fa-trowel-bricks',
      category: 'data-engineering',
      aliases: ['dbt', 'data built tool', 'dbt-core']
    },
    alembic: {
      name: 'alembic',
      displayName: 'Alembic',
      icon: 'fas fa-people-carry-box',
      category: 'data-engineering',
      aliases: ['alembic', 'Alembic']
    },
    airflow: {
      name: 'airflow',
      displayName: 'Apache Airflow',
      icon: 'fas fa-fan',
      category: 'data-engineering',
      aliases: ['Apache Airflow', 'airflow']
    }
  },

  /**
   * Get a skill by normalized name
   * @param {string} name - The skill name to lookup (case-insensitive)
   * @returns {Object|null} The skill object or null if not found
   */
  getSkill(name) {
    if (!name) return null;
    const normalized = name.toLowerCase().trim();
    return this.byName[normalized] || null;
  },

  /**
   * Get all skills in a category
   * @param {string} categoryId - The category ID
   * @returns {Array} Array of skill objects
   */
  getByCategory(categoryId) {
    return Object.values(this.byName).filter(skill => skill.category === categoryId);
  },

  /**
   * Get category metadata by ID
   * @param {string} categoryId - The category ID
   * @returns {Object|null} The category object or null if not found
   */
  getCategoryById(categoryId) {
    return this.categories.find(cat => cat.id === categoryId) || null;
  },

  /**
   * Get all unique category IDs in use
   * @returns {Array} Array of category IDs that have skills
   */
  getAllCategoryIds() {
    return [...new Set(Object.values(this.byName).map(s => s.category))];
  },

  /**
   * Get all skills with category metadata enriched
   * @returns {Array} Array of skills grouped by category
   */
  getAllByCategory() {
    const result = {};
    this.categories.forEach(cat => {
      result[cat.id] = {
        category: cat,
        skills: this.getByCategory(cat.id)
      };
    });
    return result;
  }
};