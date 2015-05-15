class DurationEstimate
  # Null Object Pattern for nil time.
  class NullTime
    # Be able to call strftime on nil time.
    #
    # @return [String]
    def strftime(*_args)
      '-'
    end
  end
end
