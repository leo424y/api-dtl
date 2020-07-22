# frozen_string_literal: true

class Domain < DomainsBase
  self.primary_key = 'pk'
  self.table_name = 'site_link'


  def self.count_result(params)
    begin
      iparams = params[:q].split(' ')
      q = "(#{(iparams).join('+')})|(#{iparams.map{|x| Tradsim::to_sim(x)}.join('+')})"
      s = params[:start_date].to_date
      e = params[:end_date].to_date
      result = self.where(ctime: s..e).where("(title RLIKE :q) OR (description RLIKE :q)", q: q).sort_by { |h| h['ctime'] }
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
