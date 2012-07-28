module ApplicationHelper
  # Returns base title with its page title if page title is given
	def full_title(page_title)
  	base_title = 'Ruby on Rails Tutorial Sample App'

  	if page_title.empty?
  		base_title
  	else
  		"#{base_title} | #{page_title}"
  	end
  end
end
