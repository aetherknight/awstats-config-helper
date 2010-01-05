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

module AWStats

  class ConfFile

    def initialize(config, defaults)
      @config = config
      @defaults = defaults
    end

    def lookup_key(key)
      return @config[key.to_s] if @config and @config.has_key?(key.to_s)
      @defaults[key.to_s]
    end

    def domain
      lookup_key('domain')
    end

    def service
      lookup_key('service')
    end

    def aliases
      lookup_key('aliases')
    end

    def logfile
      lookup_key('logfile')
    end

    def logformat
      lookup_key('logformat')
    end
  end

end
