# frozen_string_literal: true

class ApplicationRecord < ActiveRecord::Base
  primary_abstract_class

  def self.date_conv(direction, year, month, day)
    if direction == 'from'
      year = year == '' ? (Time.now - 20.years).year : year.to_i
      month = month == '' ? 1 : month.to_i
      if day == ''
        Date.new(year, month, 1)
      elsif day.to_i > Date.new(year, month, 1).next_month.prev_day.day
        Date.new(year, month, 1).next_month.prev_day
      else
        Date.new(year, month, day.to_i)
      end
    else
      year = year == '' ? Time.now.year : year.to_i
      month = month == '' ? Time.now.month : month.to_i
      if day != '' && day.to_i > Date.new(year, month, 1).next_month.prev_day.day
        Date.new(year, month, day.to_i)
      else
        Date.new(year, month, 1).next_month.prev_day
      end
    end
  end

  def self.sort_key_order(key_order_query = 'created_at desc')
    { key: key_order_query.split.first.to_sym, order: key_order_query.split.last.upcase.to_sym }
  end
end
