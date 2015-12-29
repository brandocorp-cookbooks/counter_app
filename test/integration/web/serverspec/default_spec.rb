require 'spec_helper'

describe command('curl http://localhost') do
  its(:stdout) { is_expected.to match(/You are visitor \#\d+/)}
end
