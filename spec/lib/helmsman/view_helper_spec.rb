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
      expect(result).to be_current
    end

    it 'is possible to override the current state' do
      result = helper.helm(:not_pictures, current: true)
      expect(result).to be_current
    end

    it 'highlights by action name as well' do
      result = helper.helm(:pictures, highlight: { pictures: :show })
      expect(result).not_to be_current
      result = helper.helm(:pictures, highlight: { pictures: :index })
      expect(result).to be_current
    end

    it 'passing disabled option disables the link' do
      result = helper.helm(:pictures, disabled: true)
      expect(result.to_s).not_to include '<a href'
      expect(result.to_s).to include 'disabled'
    end

    it 'adds block results to the result' do
      result = helper.helm(:pictures) { |entry| 'jambalaia' }
      expect(result.to_s).to include 'jambalaia'
    end

    it 'generates a link if it got a url' do
      result = helper.helm(:pictures, url: 'hellofoo.com')
      expect(result.to_s).to include '<a href="hellofoo.com">'
    end

    it 'generates html_safe output' do
      result = helper.helm(:pictures)
      expect(result.to_s).to be_html_safe
    end

    it 'setting visible to false will output nothing' do
      result = helper.helm(
        :pictures,
        url:     'http://defiant.ncc/pictures',
        visible: false
      )
      expect(result.to_s).to eq ''
    end

    describe 'yield the entry' do
      it 'knows if its the current' do
        helper.helm(:foo, current: true) { |e| expect(e).to be_current }
      end

      it 'knows if it is disabled' do
        helper.helm(:foo, disabled: true) do |entry|
          expect(entry).to be_disabled
          expect(entry).not_to be_enabled
        end
      end
    end

    describe '#highlight_helm?' do
      it 'highlights for a given controller' do
        expect(helper.highlight_helm?(:pictures)).to be_truthy
        expect(helper.highlight_helm?(:romulans)).to be_falsey
      end

      it 'accepts multiple controllers as highlight options' do
        expect(helper.highlight_helm?([:pictures, :romulans])).to be_truthy
        expect(helper.highlight_helm?([:borg, :romulans])).to be_falsey
      end

      it 'takes a flat conditions hash and treats it correctly' do
        expect(helper.highlight_helm?(pictures: :index)).to be_truthy
        expect(helper.highlight_helm?(romulans: :attack)).to be_falsey
      end

      it 'can highlight on multiple action names' do
        expect(helper.highlight_helm?(pictures: [:show, :index])).to be_truthy
      end

      it 'raises an type error for something unknown' do
        expect {
          helper.highlight_helm?(3)
        }.to raise_error(TypeError)
      end
    end

    describe '#helm_i18n_scope' do
      it 'raises an error if called without block' do
        expect {
          helper.helm_i18n_scope 'foobar'
        }.to raise_error(LocalJumpError)
      end

      it 'sets and resets the helm_i18n_scope' do
        expect(helper.instance_variable_get(:@helm_i18n_scope)).to be_nil
        helper.helm_i18n_scope 'foobar' do
          scope = helper.instance_variable_get(:@helm_i18n_scope)
          expect(scope).to eq 'foobar'
        end
        scope = helper.instance_variable_get(:@helm_i18n_scope)
        expect(scope).to be_nil
      end

      it 'influences #helm_expand_i18n_key' do
        expect(helper.helm_expand_i18n_key('picard')).to eq 'i18n_path'

        helper.helm_i18n_scope 'captain' do
          key = helper.helm_expand_i18n_key('.picard')
          expect(key).to eq 'captain.picard'
        end
      end

      it 'is used by #helm in the end' do
        helper.helm_i18n_scope 'captain' do
          helm = helper.helm(:picard, url: 'hello-jean-luc.com').to_s
          expect(helm).to include 'captain.picard'
        end
      end
    end
  end
end
