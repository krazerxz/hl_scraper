class HoldingsParser

  def initialize
  end

  def parse raw_holdings
    doc = Nokogiri::HTML(raw_holdings)
    holdings = doc.css('.holdings-table').children[3..-2].map{ |child| child }
    partial = holdings[0].children.map{ |row| row.text.split }.reject{|item| item.empty? }

    partial.map do |p|
      { ticker: p[0],
        name:   p[1..-7].join(' '),
        prices: p.each{ |pe| pe[p[1..-7].count+1..-1] }
      }

    end
  end
end
