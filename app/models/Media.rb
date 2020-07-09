# frozen_string_literal: true

class Media < MediasBase
  self.primary_key = 'id'
  self.table_name = 'posts'


  def self.count_result(params)
    begin
      q = params[:q].split(' ').map {|val| "%#{val}%"}
      result = self.where("title ILIKE ALL (array[?]) AND source = 'news'", q).sort_by{ |h| h['updated'] }
      count = result.count
      {
        status: 'ok',
        params: params,
        count: count,
        result: result
      }
    rescue StandardError => e
      {
        status: e
      }
    end
  end
end
