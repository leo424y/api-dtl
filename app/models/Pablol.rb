
class Pablol < AnimalsBase
  self.primary_key = 'art_id'
  self.table_name = 'article'

  def self.count_result(params)
    begin
      iparams = params[:q].split(' ')
      q = "(#{(iparams).join('+')})|(#{iparams.map{|x| Tradsim::to_sim(x)}.join('+')})"
      s = params[:start_date].to_date
      e = params[:end_date].to_date      
      result = self.where(pub_time: s..e).where("(title RLIKE :q) OR (summary RLIKE :q)", q: q).sort_by { |h| h['pub_time'] }
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


