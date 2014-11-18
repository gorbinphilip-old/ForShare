module ApplicationHelper

  #title builder
  def full_title(page_title='')
    base_title = "ForShare: Simply Share"
    if page_title.empty?
      base_title
    else
      "#{page_title} | #{base_title}"
    end
  end

end
