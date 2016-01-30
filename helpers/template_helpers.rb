module TemplateHelpers
  def current_page_url
    "#{data.site.url}#{current_page.url}"
  end

  def page_url page
    "#{data.site.url}#{page.url}"
  end

  def nofollow(param)
    if param then 'nofollow' else 'prefetch' end
  end
end