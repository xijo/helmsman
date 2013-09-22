module Helmsman
  class Helm
    attr_accessor :name, :url, :additional, :i18n_key
    include ActionView::Helpers::TagHelper
    include ActionView::Helpers::UrlHelper

    def initialize(options = {})
      @disabled = options.fetch(:disabled)
      @visible  = options.fetch(:visible)
      @current  = options.fetch(:current)
      @i18n_key = options.fetch(:i18n_key)
      @url      = options[:url]
    end

    def to_s
      visible? ? content_tag(:li, li_content, li_options) : ''.html_safe
    end

    def html_safe?
      true
    end

    def to_str
      to_s
    end

    def li_content
      link = link_to_if(enabled?, name, url) if url
      disabled? ? link : "#{link}#{additional}".html_safe
    end

    def li_options
      if enabled?
        { class: ('current-menu-item' if current?) }
      else
        { rel: 'tooltip', title: disabled_title, class: 'disabled-menu-item', data: { placement: 'bottom' } }
      end
    end

    def name
      I18n.translate(i18n_key)
    end

    def disabled_title
      I18n.translate("#{i18n_key}_disabled")
    end

    def disabled?
      @disabled
    end

    def visible?
      @visible
    end

    def enabled?
      !@disabled
    end

    def current?
      @current
    end
  end
end