require 'rails_helper'

RSpec.describe FlipkartScraper, type: :service do
  let(:url) { "https://www.flipkart.com/test-product" }
  let(:scraper) { described_class.new(url) }

  def stub_html(body)
    allow(URI).to receive(:open).with(url).and_return(body)
  end

  context "scraping product details" do
    it "extracts title from og:title" do
      html = <<-HTML
        <html>
          <head>
            <meta property="og:title" content="Cool Sunglasses | Flipkart.com">
          </head>
        </html>
      HTML
      stub_html(html)

      data = scraper.send(:scrape)
      expect(data[:title]).to eq("Cool Sunglasses")
    end

    it "falls back to h1 if og:title is missing" do
      html = <<-HTML
        <html><body><h1>Simple Sunglasses</h1></body></html>
      HTML
      stub_html(html)

      data = scraper.send(:scrape)
      expect(data[:title]).to eq("Simple Sunglasses")
    end

    it "returns 0 if price is missing" do
      html = "<html><body><div class='MWz963'></div></body></html>"
      stub_html(html)

      data = scraper.send(:scrape)
      expect(data[:price]).to eq(0)
    end

    it "parses numeric price correctly" do
      html = "<html><body><div class='MWz963'>₹1,299</div></body></html>"
      stub_html(html)

      data = scraper.send(:scrape)
      expect(data[:price]).to eq(1299)
    end

    it "saves product into database" do
      html = <<-HTML
        <html>
          <head>
            <meta property="og:title" content="Test Product | Flipkart.com">
            <meta property="og:description" content="Awesome product">
          </head>
          <body><div class="MWz963">₹999</div></body>
        </html>
      HTML
      stub_html(html)

      expect {
        scraper.scrape_and_save
      }.to change(Product, :count).by(1)

      product = Product.last
      expect(product.name).to eq("Test Product")
      expect(product.description).to eq("Awesome product")
      expect(product.price).to eq(999)
    end
  end
end
