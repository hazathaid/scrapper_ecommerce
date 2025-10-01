# Scrapper E-Commerce

A simple web application for scraping product data from **Flipkart** and saving it to a Rails API backend.  
Frontend is built using **React + Vite + TailwindCSS**.

---

## Features

- Scrape product details from Flipkart:
  - Title (with multiple fallbacks: `og:title`, `<h1>`, `keywords`)
  - Description (with multiple fallbacks: `og:description`, `meta[name=description]`, `<h1> span`)
  - Price (integer, with fallback = `0` if unavailable)
  - Product Image (OpenGraph, Twitter card, or fallback from `<img>`)
- Save scraped data directly to the database (`Product` model).
- API endpoint to scrape product data via URL.
- Frontend interface to input Flipkart product URL and display result.

---

## Tech Stack

### Backend
- Ruby on Rails (API mode)
- PostgreSQL / SQLite (for local development)
- Nokogiri (for HTML parsing / scraping)
- RSpec (for testing)
- ActiveStorage (for image storage, optional)

### Frontend
- React + Vite
- Tailwind CSS (v4)
- Axios (for API calls)

---

## Setup

### 1. Clone the repository
```bash
git clone https://github.com/your-username/scrapper_ecommerce.git
cd scrapper_ecommerce
```

### 2. Backend (Rails API)
1. Install dependencies:
```bash
cd backend
bundle install
```

2. Setup database
- Copy the database configuration file
```bash
cp config/database.yml.example config/database.yml
```
- Edit config/database.yml according to your local setup (username, password, host, adapter).
- Setup the database
```bash
rails db:create db:migrate
```

3. Setup Active Storage
This project uses Active Storage for saving product images.
By default, it uses local disk storage.
- Install Active Storage
```bash
rails active_storage:install
rails db:migrate
```
- Configure storage in config/storage.yml.
Default is local. If you want to use cloud storage (e.g. Amazon S3), update the configuration

4. Run the Rails server
```bash
rails s
```

### 3. Frontend Setup (React + Vite + TailwindCSS)
1. Go to the frontend folder
```bash
cd frontend
```
2. Install dependencies
```bash
npm install
```
3. Start the dev server
```bash
npm run dev
```

4. Project structure:
- src/pages/Home.jsx → main page for inputting a Flipkart URL & displaying the scraped result
- src/pages/Products.jsx → page for listing products already saved
- src/components/Navbar.jsx → navigation component
- src/App.jsx → main routing and layout


#### Usage 
Scraping Flipkart products using the FlipkartScraper service can be done in multiple ways:

1. Rails console:
```bash
scraper = FlipkartScraper.new("https://www.flipkart.com/some-product-url")
product = scraper.scrape_and_save
```

2. API Endpoint (Postman / cURL)
- Postman
Create an endpoint POST /products/scrape with parameter url.
Request:
```bash
POST http://localhost:3000/products/scrape
Content-Type: application/json

{
  "url": "https://www.flipkart.com/some-product-url"
}
```

- cURL
```bash
curl -X POST http://localhost:3000/products/scrape \
  -H "Content-Type: application/json" \
  -d '{"url": "https://www.flipkart.com/some-product-url"}'
```

3. Web Form
Visit http://localhost:5173
Enter a Flipkart product URL, then submit.
The product will be scraped and automatically saved to the database


### Notes
- Ensure the backend (Rails API) is running at http://localhost:3000
- Ensure the frontend (React) is running at http://localhost:5173
- For product images, Active Storage is used. Make sure to configure it properly (local or cloud).

### Project Structure
```bash
scrapper_ecommerce/
├── backend/   # Rails API + Scraper
├── frontend/  # React + Vite + Tailwind
└── README.md
```

### License
MIT