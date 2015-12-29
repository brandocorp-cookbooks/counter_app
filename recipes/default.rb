#
# Cookbook Name:: counter_app
# Recipe:: default
#
# The MIT License (MIT)
#
# Copyright (c) 2015 Brandon Raabe
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in
# all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
# THE SOFTWARE.

include_recipe 'build-essential'

user 'webuser'

application '/srv/web_counter' do
  owner 'webuser'
  group 'webuser'

  ruby '2'
  ruby_gem 'puma'

  git '/srv/web_counter' do
    repository 'https://github.com/brandocorp/web-counter.git'
    action :export
  end

  bundle_install do
    deployment true
  end

  template '/srv/web_counter/config.ru' do
    source 'config.ru.erb'
    variables redis_host: node['counter_app']['redis_host']
  end

  poise_service 'web_counter' do
    command '/usr/bin/ruby2.0 /usr/local/bin/bundle exec /usr/bin/ruby2.0 /srv/web_counter/vendor/bundle/ruby/2.0.0/bin/puma --port 8080'
    directory '/srv/web_counter'
    user 'webuser'
    stop_signal 'KILL'
    reload_signal 'HUP'
    environment BUNDLE_GEMFILE: "/srv/web_counter/Gemfile"
  end
end
