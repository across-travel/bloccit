module ApplicationHelper
  def form_group_tag(errors, &block)
    css_class = 'form-group'
    css_class << ' has-error' if errors.any?
    content_tag :div, capture(&block), class: css_class
  end

  def ajax_flash(div_class)
    response = ""
    flash_div = ""

    flash.each do |name, msg|
      if msg.is_a?(String)
        flash_div = "<div class=\"alert alert-#{name == :notice ? 'success' : 'danger'} ajax_flash\"><a class=\"close\" data-dismiss=\"alert\">&#215;</a> <div id=\"flash_#{name == :notice ? 'notice' : 'error'}\">#{h(msg)}</div> </div>"
      end
    end

    response = "$('.ajax_flash').remove();$('#{div_class}').prepend('#{flash_div}');"
    response.html_safe
  end

  def render_with_hashtags(body)
    body.gsub(/#\w+/){|word| link_to word, "/hashtag/#{word.delete('#')}"}.html_safe
  end

end
