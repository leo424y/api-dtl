class Gene < ApplicationRecord
  validates_uniqueness_of :url

  def self.news_api_import
    require 'net/http'
    medias = 'yahoo,chinatimes,setn,nownews,tvbs,ltn,udn,upmedia,ebc,ctitv,cna,nius,inside,ftv,cnyes,nikkei,pts,yahoo,apple,epochtimes,storm,newtalk,tnl,cmmedia,rfi,bbc,womany'.split(',')
    medias.each do |media|
        begin
        uri = URI("http://tag.analysis.tw/api/news_dump.php?media=#{media}")
        request = Net::HTTP.get_response(uri)
        rows_hash = JSON.parse(request.body)
        rows_hash.each do |p|
          begin
            pharse_result_url =  URI "http://np.doublethinklab.org/apis?url=#{p['url']}"
            request = Net::HTTP.get_response(pharse_result_url)
            content = JSON.parse(request.body)['content']
          rescue
            content = ""
          end
          Dtl.to_dtl(
            source: 'dtlnewstw',
            url: p['url'],
            channel_id: media,
            domain: URI(p['url']).host,
            title: p['title'],
            description: p['description'],
            content: content,
            pub_time: p['create_time']
          )
        end

        # rows_hash.each do |row_hash|
        #     Gene.create({
        #         media: media,
        #         url: row_hash['url'], 
        #         title: row_hash['title'], 
        #         image: row_hash['image'],
        #         tags: row_hash['tags'].join(' '), 
        #         create_time: row_hash['create_time'],
        #         description: row_hash['description'],
        #   }) if (row_hash['create_time'].to_date == Date.today) && row_hash['title'].present?
        # end if rows_hash

        rescue
         p media+" timeout"
        end
    end
  end
end
