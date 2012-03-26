module IndexHelper

  def page_link(slug)
    link_to(Page.find_by_slug(slug).try(:title) || slug, '#', :onclick => "app.showPage('pages/#{slug}');false")
  end

end
