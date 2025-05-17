require 'open-uri'
require 'json'

class GamesController < ApplicationController
  def new
    @letters = Array.new(10) { ('A'..'Z').to_a.sample }
  end

  def score
    @word = params[:word].upcase
    @letters = params[:letters].split(" ")

    if !included_in_grid?(@word, @letters)
      @message = "Sorry, but #{@word} can't be built from #{@letters.join(', ')}"
      @score = 0
    elsif !english_word?(@word)
      @message = "Sorry, but #{@word} is not a valid English word."
      @score = 0
    else
      @message = "Congratulations! #{@word} is a valid English word!"
      @score = compute_score(@word)
    end
  end

  private

  def included_in_grid?(word, grid)
    word.chars.all? do |letter|
      word.count(letter) <= grid.count(letter)
    end
  end

  def english_word?(word)
    url = "https://dictionary.lewagon.com/#{word}"
    response = URI.open(url).read
    json = JSON.parse(response)
    json['found']
  end

  def compute_score(word)
    word.length
  end
end
