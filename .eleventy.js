const pluginRss = require("@11ty/eleventy-plugin-rss");

module.exports = function(eleventyConfig) {
  // RSS Feed Plugin
  eleventyConfig.addPlugin(pluginRss, {
    posthtmlRenderOptions: {
      closingSingleTag: "default"
    }
  });

  // Copy static assets
  eleventyConfig.addPassthroughCopy("src/css");
  eleventyConfig.addPassthroughCopy("src/js");
  eleventyConfig.addPassthroughCopy("src/images");
  eleventyConfig.addPassthroughCopy({"node_modules/bulma/css/bulma.min.css": "css/bulma.min.css"});
  eleventyConfig.addPassthroughCopy({ "src/public": "/" });
  
  // Collections for blog posts
  // Blog posts use markdown files with YAML front matter (src/blog/*.md) and are organized via Eleventy collections.
  // This approach is ideal for content-rich articles that benefit from:
  // - Coexistence of content and metadata in one file
  // - Built-in support for grouping by tags, categories, and dates
  // - Powerful filtering/archive capabilities
  // See project_documentation/CONTENT_ORGANIZATION.md for architecture details.
  eleventyConfig.addCollection("posts", function(collectionApi) {
    return collectionApi.getFilteredByGlob("src/blog/*.md").reverse();
  });
  
  // Collection for all posts sorted chronologically (for archive)
  eleventyConfig.addCollection("postsByYear", function(collectionApi) {
    const posts = collectionApi.getFilteredByGlob("src/blog/*.md");
    const postsByYear = {};
    
    posts.forEach(post => {
      const year = post.date.getFullYear();
      if (!postsByYear[year]) {
        postsByYear[year] = [];
      }
      postsByYear[year].push(post);
    });
    
    // Sort years descending, posts within year descending
    return Object.keys(postsByYear)
      .sort((a, b) => b - a)
      .map(year => ({
        year: year,
        posts: postsByYear[year].sort((a, b) => b.date - a.date)
      }));
  });
  
  // Collection for posts by category
  eleventyConfig.addCollection("postsByCategory", function(collectionApi) {
    const posts = collectionApi.getFilteredByGlob("src/blog/*.md");
    const postsByCategory = {};
    
    posts.forEach(post => {
      const category = post.data.category || 'Uncategorized';
      if (!postsByCategory[category]) {
        postsByCategory[category] = [];
      }
      postsByCategory[category].push(post);
    });
    
    // Sort categories alphabetically
    return Object.keys(postsByCategory)
      .sort()
      .map(category => ({
        category: category,
        posts: postsByCategory[category].sort((a, b) => b.date - a.date)
      }));
  });
  
  // Collection for all tags
  eleventyConfig.addCollection("tagList", function(collectionApi) {
    const tagSet = new Set();
    collectionApi.getAll().forEach(item => {
      if ("tags" in item.data) {
        let tags = item.data.tags;
        for (let tag of tags) {
          tagSet.add(tag);
        }
      }
    });
    return [...tagSet].sort();
  });

  // Collections for bits (short-form content)
  // Bits are short how-to posts similar to blog posts but more concise
  eleventyConfig.addCollection("bits", function(collectionApi) {
    return collectionApi.getFilteredByGlob("src/bits/*.md").reverse();
  });

  // Collection for bits by year
  eleventyConfig.addCollection("bitsByYear", function(collectionApi) {
    const bits = collectionApi.getFilteredByGlob("src/bits/*.md");
    const bitsByYear = {};

    bits.forEach(bit => {
      const year = bit.date.getFullYear();
      if (!bitsByYear[year]) {
        bitsByYear[year] = [];
      }
      bitsByYear[year].push(bit);
    });

    return Object.keys(bitsByYear)
      .sort((a, b) => b - a)
      .map(year => ({
        year: year,
        bits: bitsByYear[year].sort((a, b) => b.date - a.date)
      }));
  });

  // Collection for bits tags only
  eleventyConfig.addCollection("bitsTagList", function(collectionApi) {
    const tagSet = new Set();
    collectionApi.getFilteredByGlob("src/bits/*.md").forEach(item => {
      if ("tags" in item.data) {
        let tags = item.data.tags;
        for (let tag of tags) {
          if (tag !== "bit") { // Exclude the 'bit' tag used for collection
            tagSet.add(tag);
          }
        }
      }
    });
    return [...tagSet].sort();
  });

  // Collection for all content types
  eleventyConfig.addCollection("allContent", function (collectionApi) {
    const posts = collectionApi.getFilteredByGlob("src/blog/*.md");
    const bits  = collectionApi.getFilteredByGlob("src/bits/*.md");

    return [...posts, ...bits].sort((a, b) => b.date - a.date);
  });
  
  // Custom filters
  eleventyConfig.addFilter("limit", (array, limit) => {
    return array.slice(0, limit);
  });

  eleventyConfig.addFilter("readableDate", dateObj => {
    return new Date(dateObj).toLocaleDateString('en-US', {
      year: 'numeric',
      month: 'long',
      day: 'numeric'
    });
  });
  
  eleventyConfig.addFilter("htmlDateString", dateObj => {
    return new Date(dateObj).toISOString().split('T')[0];
  });
  
  eleventyConfig.addFilter("yearOnly", dateObj => {
    return new Date(dateObj).getFullYear();
  });
  
  eleventyConfig.addFilter("monthYear", dateObj => {
    return new Date(dateObj).toLocaleDateString('en-US', {
      year: 'numeric',
      month: 'short'
    });
  });

  // Filter posts by tag
  eleventyConfig.addFilter("filterByTag", function(posts, tag) {
    return posts.filter(post => {
      return post.data.tags && post.data.tags.includes(tag);
    });
  });

  // Filter bits by tag
  eleventyConfig.addFilter("filterBitsByTag", function(bits, tag) {
    return bits.filter(bit => {
      return bit.data.tags && bit.data.tags.includes(tag);
    });
  });

  // Deterministic color mapping for US states (chloropleth)
  eleventyConfig.addFilter("stateColor", function(stateCode) {
    const colorPalette = [
      "#f0f723",  // bright yellow
      "#fbbf2b",  // orange-yellow
      "#f38a47",  // orange
      "#d8586a",  // coral/salmon
      "#ac2790",  // magenta
      "#6703a5",  // purple
      "#0d0787"   // dark purple
    ];

    if (!stateCode) return colorPalette[0];

    // djb2 hash algorithm for deterministic color mapping
    let hash = 5381;
    const str = stateCode.toUpperCase();
    for (let i = 0; i < str.length; i++) {
      hash = ((hash << 5) + hash) + str.charCodeAt(i);
    }

    return colorPalette[Math.abs(hash) % colorPalette.length];
  });

  // Add current year shortcode
  eleventyConfig.addShortcode("year", () => `${new Date().getFullYear()}`);

  // Skill filters for accessing centralized skill data
  const skills = require('./src/_data/skills.js');

  eleventyConfig.addFilter("getSkill", function(skillName) {
    return skills.getSkill(skillName);
  });

  eleventyConfig.addFilter("getSkillsByCategory", function(categoryId) {
    return skills.getByCategory(categoryId);
  });

  eleventyConfig.addFilter("getCategory", function(categoryId) {
    return skills.getCategoryById(categoryId);
  });

  eleventyConfig.addFilter("allSkillsByCategory", function() {
    return skills.getAllByCategory();
  });

  // Unified thumbnail path generation
  // Automatically generates paths from slugs: /images/[type]/[slug]/thumbnail.[ext]
  const thumbnails = require('./src/_data/thumbnails.js');

  eleventyConfig.addFilter("thumbnailPath", function(slug, type = 'posts') {
    const meta = thumbnails[type] && thumbnails[type][slug];
    const ext = meta && meta.ext ? meta.ext : 'jpg';
    return `/images/${type}/${slug}/thumbnail.${ext}`;
  });

  eleventyConfig.addFilter("thumbnailAlt", function(slug, type = 'posts') {
    const meta = thumbnails[type] && thumbnails[type][slug];
    return meta && meta.alt ? meta.alt : slug;
  });

  // Legacy filter names for backward compatibility
  eleventyConfig.addFilter("postThumbnail", function(slug) {
    return eleventyConfig.getFilter("thumbnailPath")(slug, 'posts');
  });

  return {
    dir: {
      input: "src",
      output: "_site",
      includes: "_includes",
      data: "_data"
    },
    markdownTemplateEngine: "njk",
    htmlTemplateEngine: "njk"
  };
};
