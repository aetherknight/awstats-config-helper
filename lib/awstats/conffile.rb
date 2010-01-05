#--
# (The MIT License)
#
# Copyright (c) 2009 William Snow Orvis
#
# Permission is hereby granted, free of charge, to any person obtaining
# a copy of this software and associated documentation files (the
# 'Software'), to deal in the Software without restriction, including
# without limitation the rights to use, copy, modify, merge, publish,
# distribute, sublicense, and/or sell copies of the Software, and to
# permit persons to whom the Software is furnished to do so, subject to
# the following conditions:
#
# The above copyright notice and this permission notice shall be
# included in all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED 'AS IS', WITHOUT WARRANTY OF ANY KIND,
# EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
# MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
# IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
# CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
# TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
# SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
#++

require 'erb'

module AWStats

  class ConfFile

    def initialize(config, defaults)
      @config = config
      @defaults = defaults
    end

    def method_missing(sym, *args, &block)
      key = sym.to_s
      value = nil

      value = @defaults[key] if @defaults and @defaults.has_key? key
      value = @config[key] if @config and @config.has_key? key
      raise NoMethodError, "undefined method `#{sym}' for #{self}" if value == nil

      value = value.join(' ') if key == 'aliases' and value.is_a? Array
      return value
    end

    def identifier
      begin
        return "#{service}-#{domain}"
      rescue NoMethodError
        return nil
      end
    end

    def fill_in(input)
      template = ERB.new(input)
      return template.result(binding)
    end

    def target_file
      return targetformat % identifier if identifier != nil
      return nil
    end
  end # class Conffile

end # module AWStats
