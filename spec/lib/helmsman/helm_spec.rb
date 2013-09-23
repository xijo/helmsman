require 'spec_helper'

describe Helmsman::Helm do
  let(:helm) { Helmsman::Helm.new }

  it 'is always html_safe' do
    helm.should be_html_safe
  end

  context 'translations' do
    it 'treats translations as html safe' do
      helm.name.should be_html_safe
      helm.disabled_title.should be_html_safe
    end

  end
end
