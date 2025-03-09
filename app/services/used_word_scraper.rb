# app/services/wordle_scraper.rb
require 'nokogiri'
require 'open-uri'

class UsedWordScraper
  URL = "https://www.fiveforks.com/wordle/"

  def self.fetch_used_words
    doc = Nokogiri::HTML(URI.open(URL))

    # Find the div with id "alphalist"
    word_list = doc.at_css("#alphalist").text

    # Extract only the words (before the numbers)
    words = word_list.scan(/([A-Z]{5})/).flatten.map(&:downcase)

    words.each do |word|
      Word.where(word: word).update_all(used: true)
    end
  end
end
