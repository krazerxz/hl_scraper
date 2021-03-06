class HoldingsParser
  def initialize
  end

  def parse(raw_holdings)
    holdings_table = HoldingsTable.new(raw_holdings)
    holdings_table.as_json
  end
end

class HoldingsTable
  def initialize(xml)
    @holdings_table = parse_table(xml)
  end

  def as_json
    { stocks: stocks, totals: totals }.to_json
  end

  def stocks
    raw_stock = @holdings_table[0].children.map { |row| row.text.split }.reject(&:empty?)
    raw_stock.map { |stock| Stock.parse(stock) }
  end

  def totals
    totals =  @holdings_table[2].text.split[1..-1]
    { value:    totals[0],
      cost:     totals[1],
      change_s: totals[2],
      change_p: totals[3]
    }
  end

  private

  def parse_table(raw_xml)
    xml = Nokogiri::HTML(raw_xml)
    xml.css('.holdings-table').children[3..-2].map { |child| child }
  end
end

class Stock
  def self.parse(stock_row)
    { ticker: ticker(stock_row),
      name:   name(stock_row),
      prices: prices(stock_row)
    }
  end

  def self.items_before_price(row)
    row[1..-7].count
  end

  def self.name(row)
    row[1..-7].join(' ')
  end

  def self.prices(row)
    prices = row[items_before_price(row) + 1..-1].map { |price| price.gsub(/,/, '').to_f }
    { shares:   prices[0].to_i,
      price:    prices[1],
      value:    prices[2],
      cost:     prices[3],
      change_s: prices[4],
      change_p: prices[5]
    }
  end

  def self.ticker(row)
    row[0]
  end

  private_class_method :items_before_price, :name, :prices, :ticker
end
