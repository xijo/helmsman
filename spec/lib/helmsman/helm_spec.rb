require 'spec_helper'

describe Helmsman::Helm do
  let(:helm) { Helmsman::Helm.new(i18n_scope: 'helmsman.', i18n_key: 'foo') }

  it 'is always html_safe' do
    helm.should be_html_safe
  end

  context 'translations' do
    it 'treats translations as html safe' do
      helm.name.should be_html_safe
      helm.disabled_title.should be_html_safe
    end

    it '#name_translation_key returns the right thing' do
      helm.name_translation_key.should eq 'helmsman.foo'
    end

    it '#disabled_tooltip_translation_key' do
      helm.disabled_tooltip_translation_key.should eq 'helmsman.foo_disabled_tooltip'
    end

    it '#default_disabled_tooltip_translation_key' do
      helm.default_disabled_tooltip_translation_key.should eq 'helmsman.disabled_tooltip'
    end
  end
end
