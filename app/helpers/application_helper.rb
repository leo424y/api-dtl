module ApplicationHelper
  def icon_url(url)
    image_tag "https://s2.googleusercontent.com/s2/favicons?domain_url=#{URI(url).host}", size: '16x16'
  end

  def to_title(text)
    content_for :title, text
  end
end
