class ProductsController < ApplicationController
  def index
    products = Product.all.order(created_at: :desc)

    render json: {
      products: products.map do |p|
        {
          id: p.id,
          name: p.name,
          price: p.price,
          description: p.description,
          image_url: p.image.attached? ? url_for(p.image) : nil
        }
      end
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
