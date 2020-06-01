# frozen_string_literal: true

class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true
  scope :filter_by_date, lambda { |params|
    start_date = params[:start_date].present? ? params[:start_date].to_date : Date.today - 365
    end_date = params[:end_date].present? ? params[:end_date].to_date : Date.today
    where("to_date(updated, 'YY-MM-DD') BETWEEN ? AND ?", start_date.beginning_of_day, end_date.end_of_day)
  }
  scope :filter_by_q, ->(params) { q=params[:q].split(' ').map {|val| "%#{val}%"}; where("title ILIKE ALL (array[?])", q) }
  scope :filter_by_domain, ->(params) { where('link_domain LIKE ?', "%#{params[:domain]}%") }
  scope :filter_by_list, lambda { |params|
    list = Ctlist.find_by(creator: params[:list])
    listid = list ? list.listid : params[:list]
    where('list LIKE ?', listid.to_s)
  }
  scope :filter_by_link, ->(params) { where('link LIKE ?', "%#{params[:link]}%") }

  def self.to_csv(header)
    attributes = header.split(' ')

    CSV.generate(headers: true) do |csv|
      csv << attributes

      all.each do |result|
        csv << attributes.map { |attr| result.send(attr) }
      end
    end
  end
end
