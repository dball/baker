# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
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

  def argumentize(title)
    /\s/.match(title) ? '"' + title + '"' : title
  end

  def breadcrumb(title, url = nil)
    @breadcrumbs ||= []
    @breadcrumbs << [title, url]
  end

  def breadcrumbs_title
    if @breadcrumbs_title.nil?
      breadcrumbs!
    end
    @breadcrumbs_title
  end

  def breadcrumbs_links
    if @breadcrumbs_links.nil?
      breadcrumbs!
    end
    @breadcrumbs_links
  end

  private

  def breadcrumbs!
    breadcrumbs = [
      ['bake.rb', root_path],
      [controller.controller_name, { :action => 'index' }]
    ]
    if !@breadcrumbs.blank?
      breadcrumbs += @breadcrumbs
    end
    @breadcrumbs_title = breadcrumbs.map {|title, url| h(title)}.join(' ')
    @breadcrumbs_links = breadcrumbs.map do |title, url|
      url.nil? ? h(title) : link_to(h(title), url)
    end.join(' ')
  end
end
