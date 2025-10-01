require 'rails_helper'

RSpec.describe "Products API", type: :request do
  describe "POST /product/scrape" do
    let(:url) { "https://www.flipkart.com/srpm-wayfarer-sunglasses/p/itmaf19ae5820c06" }

    it "scrapes and saves a product" do
      post "/products/scrape", params: { url: url }

      expect(response).to have_http_status(:success)
      expect(JSON.parse(response.body)["name"]).to be_present
    end
  end

  describe "GET /products" do
    before do
      # buat beberapa produk dummy
      @product1 = Product.create!(
        name: "iPhone 15",
        price: 1500,
        description: "Latest iPhone model",
        image: fixture_file_upload(Rails.root.join("spec/fixtures/files/sample.jpg"), "image/jpg")
      )

      @product2 = Product.create!(
        name: "Samsung Galaxy S23",
        price: 1200,
        description: "Flagship Samsung",
        image: fixture_file_upload(Rails.root.join("spec/fixtures/files/sample.jpg"), "image/jpg")
      )
    end

    it "returns a list of products" do
      get "/products"

      expect(response).to have_http_status(:ok)

      json = JSON.parse(response.body)
      expect(json["products"]).to be_an(Array)
      expect(json["products"].size).to eq(2)

      first = json["products"].first
      expect(first).to include("id", "name", "price", "description", "image")
    end
  end
end
