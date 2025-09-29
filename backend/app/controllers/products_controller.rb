class ProductsController < ApplicationController
  def index
    products = Product.all.order(created_at: :desc)

    render json: {
      products: products.as_json(only: [:id, :name, :price, :description])
    }
  end

  def scrape
    url = params[:url]
    return render json: { error: "URL is required" }, status: :bad_request if url.blank?

    scraper = FlipkartScraper.new(url)
    product = scraper.scrape_and_save

    render json: product, status: :created
  end
end
