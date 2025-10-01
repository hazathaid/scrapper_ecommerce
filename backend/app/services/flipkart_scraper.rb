require "open-uri"

class FlipkartScraper
  def initialize(url)
    @url = url
  end

  def scrape_and_save
    data = scrape

    product = Product.find_or_initialize_by(name: data[:title])
    product.description = data[:description]
    product.price = data[:price]

    if data[:image].present?
      puts "IMAGE URL: #{data[:image]}"
      file = URI.parse(data[:image]).open
      puts "file: #{file}"
      product.image.attach(io: file, filename: "flipkart_#{product.id}.jpg")
    end

    product.save!
    product
  end

  private

  def scrape
    # scraping use nokogiri
    doc = Nokogiri::HTML(URI.open(@url))
    raw_price = extract_price(doc) rescue nil
    price = convert_price(raw_price)
    {
      title: extract_title(doc),
      description: extract_description(doc),
      price: price,
      image: extract_image(doc, @url)
    }
    # puts "extract_image(doc, @url) => #{extract_image(doc, @url)}"
  end

  def convert_price(raw_price)
    return 0 if raw_price.blank? || raw_price == 0

    raw_price.is_a?(String) ? raw_price.gsub(/[^\d]/, "").to_i : raw_price.to_i
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

    # If still empty → get from h1 span
    if desc.blank?
      desc = doc.at("h1 span")&.text&.strip
      desc = nil if desc.blank?
    end

    # if still not description create fallback for No description
    desc.presence || "No description available"
  end

  def extract_price(doc)
    # 1. meta tag
    meta_content = doc.at_css("meta[property='product:price:amount']")&.[]("content")
    price = normalize_price(meta_content)
    return price if price > 0

    # 2. cari div dengan simbol ₹
    if (price_div = doc.at_css("div:contains('₹')"))
      if m = price_div.text.match(/₹\s?([\d\.,]+)/)
        price = normalize_price(m[1])
        return price if price > 0
      end
    end

    # 3. fallback untuk class umum flipkart
    if (price_text = doc.at_css("div._30jeq3")&.text)
      price = normalize_price(price_text)
      return price if price > 0
    end

    0
  end

  def normalize_price(price_value)
    return 0 if price_value.nil?
    digits = price_value.to_s.gsub(/[^\d]/, "")
    digits.to_i
  end

  def extract_image(doc, base_url = nil)
    # get from og:image
    img = doc.at_css("meta[property='og:image']")&.[]("content")
    return absolutize_url(img, base_url) if img.present?

    # if not found get from twitter:image
    img = doc.at_css("meta[name='twitter:image']")&.[]("content")
    return absolutize_url(img, base_url) if img.present?

    # if not found get from rel=image_src
    img = doc.at("link[rel='image_src']")&.[]("href")
    return absolutize_url(img, base_url) if img.present?

    # use custom selectors
    selectors = [
      "img._396cs4",
      "img._2r_T1I",
      "img._2r_T1I._3kWf5",
      "div._2c7YLP img",
      "img",
    ]

    selectors.each do |sel|
      node = doc.at_css(sel)
      next if node.nil?
      src = node["data-src"] || node["data-image-src"] || node["data-original"] || node["src"] || node["srcset"]
      next if src.nil? || src.strip.empty?
      src = src.split(" ").first
      return absolutize_url(src, base_url)
    end

    # if still not found create fallback: get all image
    imgs = doc.css("img").map { |n| n["src"] || n["data-src"] || n["data-image-src"] || n["srcset"] }.compact
    imgs = imgs.map { |u| absolutize_url(u.split(" ").first, base_url) }.compact
    return imgs.first unless imgs.empty?

    nil
  end

  def absolutize_url(href, base_url)
    return nil if href.nil? || href.strip.empty?
    href = href.strip

    # ambil URL pertama kalau ada srcset ("url 2x")
    href = href.split(" ").first if href.include?(" ")

    # sudah absolut
    return href if href =~ /\Ahttps?:\/\//

    # protocol-relative //cdn...
    if href.start_with?("//")
      uri = URI.parse(base_url || @url)
      return "#{uri.scheme}:#{href}"
    end

    # relatif → gabung dengan base_url
    begin
      base = URI.parse(base_url || @url)
      URI.join(base, href).to_s
    rescue => e
      href # kalau gagal, balikin original
    end
  end

end
