require 'spec_helper'

describe Helmsman do
  describe '#current_css_class' do
    after { Helmsman.current_css_class = 'active' }

    it 'defaults to active' do
      Helmsman.current_css_class.should eq 'active'
    end

    it 'is settable and gettable' do
      Helmsman.current_css_class = 'foo'
      Helmsman.current_css_class.should eq 'foo'
    end
  end

  describe '#disabled_css_class' do
    after { Helmsman.disabled_css_class = 'disabled' }

    it 'defaults to disabled' do
      Helmsman.disabled_css_class.should eq 'disabled'
    end

    it 'is settable and gettable' do
      Helmsman.disabled_css_class = 'foo'
      Helmsman.disabled_css_class.should eq 'foo'
    end
  end
end
