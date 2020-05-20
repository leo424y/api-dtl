class ApplicationController < ActionController::Base
  private 

  def count_record recored 
    {params: params, count: recored.count}
  end

  def log_search
    Searchword.create(word: params[:q], start_date: params[:start_date], end_date: params[:end_date]) if params[:q] 
  end

  def set_filter recored 
    recored = recored.filter_by_date params
    recored = recored.filter_by_list params if params[:list]
    recored = recored.filter_by_domain params if params[:domain]
    recored = recored.filter_by_q params if params[:q]
    recored = recored.filter_by_link params if params[:link]
    recored
  end

  def a_to_csv(array, header)
    attributes = header.split(" ")

    CSV.generate(headers: true) do |csv|
      csv << attributes

      array.each do |result|
        csv << attributes.map{ |attr| result[attr] }
      end
    end
  end
end
