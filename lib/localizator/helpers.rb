module Localizator

  module Helpers

    def self.locale_diff(a, b)
      diff = {}
      if b.nil? or (b.class != a.class)
        return a
      end
      if a.is_a? Hash
        a.keys.each do |key|
          ret = locale_diff(a[key], b[key])
          diff[key] = ret if !ret.empty?
        end
      end
      diff
    end
  end

end
