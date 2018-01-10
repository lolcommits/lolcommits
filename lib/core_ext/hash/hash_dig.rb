# Backport Hash#dig to Ruby < 2.3
# inspired by https://github.com/Invoca/ruby_dig

module HashDig
  def dig(key, *rest)
    value = self[key]
    if value.nil? || rest.empty?
      value
    elsif value.respond_to?(:dig)
      value.dig(*rest)
    else
      raise TypeError, "#{value.class} does not have #dig method"
    end
  end
end

if RUBY_VERSION < '2.3'
  class Hash
    include HashDig
  end
end
