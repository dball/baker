# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  def title(title)
    content_for(:title) { title }
  end

  def javascript(*files)
    content_for(:head) { javascript_include_tag(*files) }
  end

  def stylesheet(*files)
    content_for(:head) { stylesheet_link_tag(*files) }
  end

  def edit_form_for(name, model, options = {}, &block)
    url = model.new_record? ? { :action => 'create' } : { :action => 'update', :id => model }
    html = model.new_record? ? {} : { :method => :put }
    form_for(name, model, options.merge({ :url => url, :html => html }), &block)
  end
end
