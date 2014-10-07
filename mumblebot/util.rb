module Mumblebot
  module Util
    def self.constantize name
      Object.const_get("Mumblebot::#{name}", true)
    end

    def self.symbolize_keys hsh
      hsh.inject({}) do |h,(k,v)|
        h[k.to_sym] = v.is_a?(Hash) ? symbolize_keys(v) : v; h
      end
    end
  end
end
