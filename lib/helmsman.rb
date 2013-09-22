require 'i18n'
require 'active_support'
require 'action_view'

require 'helmsman/version'
require 'helmsman/helm'
require 'helmsman/view_helper'
require 'helmsman/railtie' if defined?(Rails)

module Helmsman
  class << self
    attr_writer :current_css_class, :disabled_css_class

    def current_css_class
      @current_css_class || 'active'
    end

    def disabled_css_class
      @disabled_css_class || 'disabled'
    end
  end
end
