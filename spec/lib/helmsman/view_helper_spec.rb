require 'spec_helper'

class FakeHelper
  include Helmsman::ViewHelper
  include ActionView::Context
  include ActionView::Helpers::CaptureHelper
  include ActionView::Helpers::TranslationHelper
  include ActionView::Helpers::TagHelper
  include ActionView::Helpers::UrlHelper

  def controller_name
    'pictures'
  end

  def action_name
    'index'
  end
end

describe Helmsman::ViewHelper do
  let(:helper) { FakeHelper.new }

  before do
    helper.stub(
      scope_key_by_partial: 'i18npath',
      controller_name: 'foos',
      action_name: 'bar'
    )
  end

  describe '#admin_sidebar_entry' do
    it 'highlights per class name on a given controller name' do
      result = helper.admin_sidebar_entry(:foos)
      result.should include 'current-menu-item'
    end

    it 'is possible to override the current state' do
      result = helper.admin_sidebar_entry(:nooo, current: true)
      result.should include 'current-menu-item'
    end

    it 'highlights by action name as well' do
      result = helper.admin_sidebar_entry(:foos, actions: :noe)
      result.should_not include 'current-menu-item'
      result = helper.admin_sidebar_entry(:foos, actions: :bar)
      result.should include 'current-menu-item'
    end

    it 'passing disabled option disables the link' do
      result = helper.admin_sidebar_entry(:foos, disabled: true)
      result.should_not include '<a href'
      result.should include 'disabled-menu-item'
    end

    it 'adds block results to the result' do
      result = helper.admin_sidebar_entry(:foos) { |entry| 'jambalaia' }
      result.should include 'jambalaia'
    end

    it 'generates a link if it got a url' do
      result = helper.admin_sidebar_entry(:foos, url: 'hellofoo.com')
      result.should include '<a href="hellofoo.com">'
    end

    it 'generates html_safe output' do
      result = helper.admin_sidebar_entry(:foos)
      result.to_s.should be_html_safe
    end

    describe 'yield the entry' do
      it 'knows if its the current' do
        helper.admin_sidebar_entry(:foo, current: true) { |e| e.should be_current }
      end

      it 'knows if it is disabled' do
        helper.admin_sidebar_entry(:foo, disabled: true) do |entry|
          entry.should be_disabled
          entry.should_not be_enabled
        end
      end
    end
  end
end
