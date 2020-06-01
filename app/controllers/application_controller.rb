class ApplicationController < ActionController::Base
  private 

  def count_record recored 
    result = {
      params: params, 
      count: recored.count,
    } 
    if recored.count < 100
      result = result.merge({posts_by_date: recored.sort_by { |h| h['date'] }})
    end
    result
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
  
  def api_result params, rows_hash, platform 
    sort_by_param = case platform 
    when 'cofacts'
      'createdAt'
    when 'crowdtangle'
      'date'
    end
    count = rows_hash.is_a?(Array) ? rows_hash.count : rows_hash
    result = {
      params: params,
      count: (count==100 ? 'over 100' : count), 
    }
    if count < 100  
      result = result.merge(posts_by_date: rows_hash.sort_by { |h| h[sort_by_param] }) 
    end

    result
  end

  def name_file model, params
    "#{model}-#{Date.today}-#{params[:q]}-#{params[:start_date]}-#{params[:end_date]}.csv"
  end
end
