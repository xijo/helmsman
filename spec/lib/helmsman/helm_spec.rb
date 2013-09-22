require 'spec_helper'

describe Helmsman::Helm do
  it 'is always html_safe' do
    Helmsman::Helm.new.should be_html_safe
  end
end
