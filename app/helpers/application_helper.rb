module ApplicationHelper
	# return a title on a per page basis
	def full_title(page_title)
		base_title = "Hartl Chapter 3 sample app"
		if page_title.empty?
			base_title
		else
			"#{base_title} | #{page_title}"
		end
	end
end
