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
end
