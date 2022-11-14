require 'json'
require 'open-uri'

class GamesController < ApplicationController
  def new
    @letters = (0...10).map { ('a'..'z').to_a[rand(26)] }
    @answer = params[:answer]
  end

  def score
    @answer = params[:answer]
    @letters = params[:letters].chars
    if !calltoAPI(@answer)
      @response = "Sorry but #{@answer} doesn't seem to be a valid English word..."
    elsif validator(@answer)
      @response = "Congratulations! #{@answer} is a valid English word"
    else
      @response = "Sorry but #{@answer} can't be built out of #{@letters}"
    end
  end

  def validator(answer)
    validate = true
    letters_array = @letters
    answer_array = answer.chars
    answer_array.each do |l|
      if letters_array.include? l
        letters_array.delete_at(letters_array.index(l))
      else
        validate = false
      end
    end
    validate
  end

  private

  def calltoAPI(word)
    url = "https://wagon-dictionary.herokuapp.com/#{word}"
    verif = URI.open(url).read
    data = JSON.parse(verif)
    return data['found']
  end
end
