#encoding: utf-8

# This is a template for a Ruby scraper on morph.io (https://morph.io)
# including some code snippets below that you should find helpful

require 'scraperwiki'
require 'nokogiri'

# Read in a page
url = "https://docs.google.com/spreadsheets/d/1QkkIRF-3Qrz-aRIxERbGbB7YHWz2-t4ix-7TEcuBNfE/pubhtml?gid=1823583981&single=true"
page = Nokogiri::HTML(open(url), nil, 'utf-8')
rows = page.xpath('//table[@class="waffle"]/tbody/tr')

# Find somehing on the page using css selectors
content = []
rows.collect do |r|
  content << r.xpath('td').map { |td| td.text.strip }
end

content.shift
content.each do |row|
  record = {
    "uid" => row[0],
    "macro_area" => row[1],
    "category" => row[2],
    "promess" => row[3],
    "description" => row[4],
    "quality" => row[5],
    "readmore_quality" => row[9],
    "fulfillment" => row[6],
    "readmore_fulfillment" => row[8],
    "ponderator" => row[7],
    "last_update" => Date.today.to_s
  }

  # Storage record
  if ((ScraperWiki.select("* from data where `source`='#{record['uid']}'").empty?) rescue true)
    ScraperWiki.save_sqlite(["uid"], record)
    puts "Adds new record " + record['uid']
  else
    ScraperWiki.save_sqlite(["uid"], record)
    puts "Updating already saved record " + record['uid']
  end
end
