class ProductsController < ApplicationController
  def scrape
    url = params[:url]
    return render json: { error: "URL is required" }, status: :bad_request if url.blank?

    scraper = FlipkartScraper.new(url)
    product = scraper.scrape_and_save

    render json: product, status: :created
  end
end
