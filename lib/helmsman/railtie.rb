require 'rails/railtie'

module Helmsman
  class Railtie < ::Rails::Railtie
    initializer 'helmsman.view_helper' do
      ActionView::Base.send :include, Helmsman::ViewHelper
    end
  end
end
