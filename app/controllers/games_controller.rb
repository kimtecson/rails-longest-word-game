require "json"
require "open-uri"

class GamesController < ApplicationController
  def new
    @letters =  ['A','E','I','O','U']
    @letters += Array.new(5) { (('A'..'Z').to_a - @letters).sample }
    @letters.shuffle!
  end
  def score
    @word = params[:word].upcase
    @letters = params[:letters]

    url = "https://wagon-dictionary.herokuapp.com/#{@word}"

    words = JSON.parse(URI.open(url).read)
    letter_count = @word.chars.uniq.all? do |element|
      @letters.count(element) >= @word.count(element)
    end

    if words['found'] && letter_count
      @results = "<b>Congratulations!</b> #{@word} is a valid English word!".html_safe
      @score = words['length']
    elsif words['found']
      @results = "Sorry but <b>#{@word}</b> can't be built out of #{@letters.split.join(',')}".html_safe
      @score = 0
    else
      @results = "Sorry but <b>#{@letters}</b> does not seem to be a valid English word...".html_safe
      @score = 0
    end
  end
end
