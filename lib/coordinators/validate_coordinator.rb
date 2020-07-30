# frozen_string_literal

class ValidateCoordinator
  attr_reader :card_number

  INDUSTRY_MAP = {
    '0' => 'ISO/TC 68 Assignment',
    '1' => 'Airline cards',
    '2' => 'Airlines cards (and other future industry assignments)',
    '3' => 'Travel and Entertainment Cards',
    '4' => 'Banking and Financial Cards',
    '5' => 'Banking and Financial Cards',
    '6' => 'Merchandising and Financial Cards',
    '7' => 'Gas Cards, Other Future Industry Assignments',
    '8' => 'Healthcare Cards, Telecommunications, Other Future Industry Assignments',
    '9' => 'For Use by National Standards Bodies'
  }

  def initialize(card_number:)
    @card_number = card_number
  end

  def call
    validate!

    {
      mii: card_number[0],
      industry: industry,
      iin: card_number[0..5],
      account_number: card_number[6..14],
      check_number: card_number[15]
    }
  end

  private

  def validate!
    raise InvalidCardNumberError if card_number.length != 16
    raise InvalidCardNumberError unless luhn_test
    Integer(card_number)
  rescue ArgumentError
    raise InvalidCardNumberError
  end

  def industry
    INDUSTRY_MAP[card_number[0]]
  end

  def luhn_sum
    sum = 0
    card_number.split('').reverse.each_with_index do |digit, index|
      if digit % 2 == 1
        total = digit.to_i * 2
        sum += total > 9 ? total - 9 : total
      else
        sum += digit.to_i
      end
    end
    sum
  end

  def luhn_test
    luhn_sum % 10 == 0
  end

  class InvalidCardNumberError < StandardError; end
end