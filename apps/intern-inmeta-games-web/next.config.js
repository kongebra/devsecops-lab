/** @type {import('next').NextConfig} */
const nextConfig = {
  reactStrictMode: true,
  swcMinify: true,
  output: "standalone",

  env: {
    DATABASE_URL:
      process.env.AZURE_APP_CONFIG_CONNECTION_STRING ||
      process.env.DATABASE_URL,
  },
};

module.exports = nextConfig;
