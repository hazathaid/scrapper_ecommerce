require "open-uri"

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
    raw_price = doc.css("div.MWz963").text.strip rescue nil
    price = convert_price(raw_price)
    {
      title: extract_title(doc),
      description: extract_description(doc),
      price: price,
    }
  end

  def convert_price(raw_price)
    return 0 if raw_price.blank?

    numeric = raw_price.gsub(/[^\d]/, "")
    numeric.empty? ? 0 : numeric.to_i
  end
  
  def extract_title(doc)
    # get from og:title
    raw_title = doc.at("meta[property='og:title']")&.[]('content')
    # clear from unused for title of product
    title = raw_title&.gsub(/\s*\|\s*Flipkart.*/i, '')&.strip
    # if no content on og:title use content on tag H1
    if title.blank?
      title = doc.at('h1')&.text&.strip
    end

    # if still no content use from keywords but get content for title
    if title.blank?
      keywords = doc.at("meta[name='Keywords']")&.[]('content')
      title = keywords&.split(',')&.first&.strip
    end

    # if still not title create fallback for Unknown Product
    title.presence || "Unknown Product"
  end

  def extract_description(doc)
    #  get from og:description
    desc = doc.at("meta[property='og:description']")&.[]('content')&.strip

    # if no content on og:description use content on meta description
    if desc.blank?
      desc = doc.at("meta[name='description']")&.[]('content')&.strip
    end

    # 3. If still empty → get from h1 span
    if desc.blank?
      desc = doc.at("h1 span")&.text&.strip
      desc = nil if desc.blank?
    end

    # if still not description create fallback for No description
    desc.presence || "No description available"
  end
end
