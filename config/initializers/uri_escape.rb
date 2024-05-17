module URI
  def self.escape(*arg)
    warn "URI.escape is obsolete", uplevel: 1 if $VERBOSE
    DEFAULT_PARSER.escape(*arg)
  end
end