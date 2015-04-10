require 'spec_helper'

describe Helmsman::Helm do
  let(:helm) { Helmsman::Helm.new(i18n_scope: 'helmsman.', i18n_key: 'foo') }

  it 'is always html_safe' do
    expect(helm).to be_html_safe
  end

  context 'translations' do
    it 'treats translations as html safe' do
      expect(helm.name).to be_html_safe
      expect(helm.disabled_title).to be_html_safe
    end

    it '#name_translation_key returns the right thing' do
      expect(helm.name_translation_key).to eq 'helmsman.foo'
    end

    it '#disabled_tooltip_translation_key' do
      expect(helm.disabled_tooltip_translation_key).to\
        eq 'helmsman.foo_disabled_tooltip'
    end

    it '#default_disabled_tooltip_translation_key' do
      expect(helm.default_disabled_tooltip_translation_key).to\
        eq 'helmsman.disabled_tooltip'
    end

    it '#name returns the setted name before the i18n fallback' do
      helm.name = 'Foobar'
      expect(helm.name).to eq 'Foobar'
    end
  end

  context '#li_options' do
    it 'contains li_class if enabled' do
      helm = Helmsman::Helm.new(
        i18n_scope: 'helmsman.',
        i18n_key:   'key',
        li_class:   'foo bar'
      )
      expect(helm.li_options[:class]).to respond_to :to_str
      expect(helm.li_options[:class]).to include 'foo'
      expect(helm.li_options[:class]).to include 'bar'
    end

    it 'contains li_class if disabled' do
      helm = Helmsman::Helm.new(
        i18n_scope: 'helmsman.',
        i18n_key: 'key',
        li_class: 'bar foo',
        disabled: true
      )
      expect(helm.li_options[:class]).to respond_to :to_str
      expect(helm.li_options[:class]).to include 'foo'
      expect(helm.li_options[:class]).to include 'bar'
    end

    it 'contains li_class if passed as an array' do
      helm = Helmsman::Helm.new(
        i18n_scope: 'helmsman.',
        i18n_key: 'key',
        li_class: %w[foo bar] << ' ' << nil
      )
      expect(helm.li_options[:class]).to respond_to :to_str
      expect(helm.li_options[:class]).to eq 'bar foo'
    end
  end
end
