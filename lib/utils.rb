module Utils
  def symbolize_keys( str_hash)
    symbolized_hash = {}

    str_hash.each { |k, v| symbolized_hash[k.to_sym] = v.is_a?(Hash) ? symbolize_keys(v) : v }

    symbolized_hash
  end
end