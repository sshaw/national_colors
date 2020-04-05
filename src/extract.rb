# frozen_string_literal: true

require "open-uri"
require "json"
require "nokogiri"
require "normalize_country"

def to_hex(name)
  # CSS names only
  return name unless name =~ /\A[a-z]+\z/i
  HEX_COLOR[name.downcase]
end

def get_colors(styles)
  colors = []
  styles && styles.each do |s|
    # match hex or CSS color name
    next unless s["style"] =~ /background-color:\s*([#0-9a-zA-Z]+)/

    value = $1
    colors << to_hex(value)
    abort "unknown color #{value}" unless colors[-1]
  end

  colors
end

OUTPUT_FILENAME = "national_colors.json"
HEX_COLOR = JSON.load(File.read(File.join(__dir__, "html-colors.json")))
HEADINGS = ["Africa", "North America", "South America", "Asia", "Europe", "Oceania"].freeze
RESULTS = []

open("https://en.m.wikipedia.org/wiki/National_colours") do |io|
  doc = Nokogiri::HTML(io)
  doc.css("h2.section-heading").each do |node|
    name = node.at(".mw-headline")
    next unless name && HEADINGS.include?(name = name.text.strip)
    next unless node.next && table = node.next.at("table")

    # Skip table heading
    table.css("tr")[1..-1].each do |tr|
      next unless tr.children.any?

      a = tr.children[0].at("a")
      next unless a

      country = a.text.strip

      primary = get_colors(tr.css("td:nth-of-type(5) span[style]"))
      secondary = get_colors(tr.css("td:nth-of-type(6) span[style]"))

      abort "no colors found for #{country}" unless primary.any?

      RESULTS << {
        :country => country,
        :alpha2  => NormalizeCountry(country, :to => :alpha2),
        :colors => {
          :primary => primary,
          :secondary => secondary
        }
      }
    end
  end
end

File.write(ARGV[0] || OUTPUT_FILENAME, JSON.pretty_generate(RESULTS))
