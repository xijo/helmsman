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
      result = helper.helm(:pictures, highlight: { pictures: :show })
      result.should_not be_current
      result = helper.helm(:pictures, highlight: { pictures: :index })
      result.should be_current
    end

    it 'passing disabled option disables the link' do
      result = helper.helm(:pictures, disabled: true)
      result.to_s.should_not include '<a href'
      result.to_s.should include 'disabled'
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

    describe '#highlight_helm?' do
      it 'highlights for a given controller' do
        helper.highlight_helm?(:pictures).should be_true
        helper.highlight_helm?(:romulans).should be_false
      end

      it 'accepts multiple controllers as highlight options' do
        helper.highlight_helm?([:pictures, :romulans]).should be_true
        helper.highlight_helm?([:borg, :romulans]).should be_false
      end

      it 'takes a flat conditions hash and treats it correctly' do
        helper.highlight_helm?(pictures: :index).should be_true
        helper.highlight_helm?(romulans: :attack).should be_false
      end

      it 'can highlight on multiple action names' do
        helper.highlight_helm?(pictures: [:show, :index]).should be_true
      end

      it 'raises an type error for something unknown' do
        expect {
          helper.highlight_helm?(3)
        }.to raise_error(TypeError)
      end
    end
  end
end
