class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true
  scope :filter_by_date, ->(params){ 
    start_date = params[:start_date] ? params[:start_date].to_date : Date.today
    end_date = params[:end_date] ? params[:end_date].to_date : Date.today
    where("to_date(updated, 'YY-MM-DD') BETWEEN ? AND ?", start_date.beginning_of_day, end_date.end_of_day)
  }
  scope :filter_by_q, ->(params){ where("title LIKE ?", "%#{params[:q]}%") }
  scope :filter_by_domain, ->(params){ where("link_domain LIKE ?", "%#{params[:domain]}%") }
  scope :filter_by_list, ->(params){       
    list =  Ctlist.find_by(creator: params[:list]) 
    listid = list ? list.listid : params[:list]
    where("list LIKE ?", "#{listid}")
  }
end
