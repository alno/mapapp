module IndexHelper

  def nav_link(title, path)
    if current_page? path
      "<li class=\"active\">#{link_to title, path, :onclick => 'return false'}</li>".html_safe
    else
      "<li>#{link_to title, path}</li>".html_safe
    end
  end

end
