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

  def scope_key_by_partial(_)
    'i18n_path'
  end
end

describe Helmsman::ViewHelper do
  let(:helper) { FakeHelper.new }

  describe '#helm' do
    it 'highlights per class name on a given controller name' do
      result = helper.helm(:pictures)
      result.should be_current
    end

    it 'is possible to override the current state' do
      result = helper.helm(:not_pictures, current: true)
      result.should be_current
    end

    it 'highlights by action name as well' do
      result = helper.helm(:pictures, actions: :show)
      result.should_not be_current
      result = helper.helm(:pictures, actions: :index)
      result.should be_current
    end

    it 'passing disabled option disables the link' do
      result = helper.helm(:pictures, disabled: true)
      result.to_s.should_not include '<a href'
      result.to_s.should include 'disabled-menu-item'
    end

    it 'adds block results to the result' do
      result = helper.helm(:pictures) { |entry| 'jambalaia' }
      result.to_s.should include 'jambalaia'
    end

    it 'generates a link if it got a url' do
      result = helper.helm(:pictures, url: 'hellofoo.com')
      result.to_s.should include '<a href="hellofoo.com">'
    end

    it 'generates html_safe output' do
      result = helper.helm(:pictures)
      result.to_s.should be_html_safe
    end

    it 'setting visible to false will output nothing' do
      result = helper.helm(:pictures, url: 'http://defiant.ncc/pictures', visible: false)
      result.to_s.should eq ''
    end

    describe 'yield the entry' do
      it 'knows if its the current' do
        helper.helm(:foo, current: true) { |e| e.should be_current }
      end

      it 'knows if it is disabled' do
        helper.helm(:foo, disabled: true) do |entry|
          entry.should be_disabled
          entry.should_not be_enabled
        end
      end
    end
  end
end
