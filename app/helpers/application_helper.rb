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

  FRACTIONS = { '1/4' => 'BC', '1/2' => 'BD', '3/4' => 'BE', '1/3' => '2153',
                '2/3' => '2154', '1/5' => '2155', '2/5' => '2156',
                '3/5' => '2157', '4/5' => '2158', '1/6' => '2159',
                '5/6' => '215A', '1/8' => '215B', '3/8' => '215C',
                '5/8' => '215D', '7/8' => '215E' }

  def fractionize(value)
    value.gsub(/(\d+\/\d+)/) do |fraction|
      if code = FRACTIONS[fraction]
        '&#x' + code + ';'
      else
        fraction
      end
    end
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
    breadcrumbs = [ ['bake.rb', root_path] ]
    if controller.respond_to?(:index)
      breadcrumbs <<  [controller.controller_name, { :action => 'index' }]
    end
    if !@breadcrumbs.blank?
      breadcrumbs += @breadcrumbs
    end
    @breadcrumbs_title = breadcrumbs.map {|title, url| h(title)}.join(' ')
    @breadcrumbs_links = breadcrumbs.map do |title, url|
      url.nil? ? h(title) : link_to(h(title), url)
    end.join(' ')
  end
end
