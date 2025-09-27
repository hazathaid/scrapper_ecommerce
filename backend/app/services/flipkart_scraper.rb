class FlipkartScraper
  def initialize(url)
    @url = url
  end

  def scrape_and_save
    data = scrape

    Product.create!(
      name: data[:title],
      description: data[:description],
      price: data[:price],
    )
  end

  private

  def scrape
    # scraping use nokogiri
    doc = Nokogiri::HTML(URI.open(@url))
    raw_price = doc.css("div._30jeq3").text.strip rescue nil
    price = convert_price(raw_price)
    {
      title: doc.css("span.B_NuCI").text.strip,
      description: doc.css("div._1mXcCf").text.strip,
      price: price,
    }
  end

  def convert_price(raw_price)
    return 0 if raw_price.blank?

    numeric = raw_price.gsub(/[^\d]/, "")
    numeric.empty? ? 0 : numeric.to_i
  end
end
