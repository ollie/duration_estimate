class DurationEstimate
  # Format a status line for terminal.
  class TerminalFormatter
    # Reference to the estimate instance.
    #
    # @return [DurationEstimate]
    attr_accessor :estimate

    # Format a status line for terminal.
    #
    # @return [String]
    def self.format(estimate)
      new(estimate).format
    end

    # Format a status line for terminal.
    #
    # @param estimate [DurationEstimate] Reference to the estimate instance.
    def initialize(estimate)
      self.estimate = estimate
    end

    # Format estimate as a string.
    # Prevent trailing junk characters by setting fixed widths for things.
    #
    # @return [String]
    def format
      [
        "#{ items_done }/#{ estimate.items_size }",
        "(#{ percentage } %)",
        "#{ estimate.ends_at.strftime('%H:%M:%S') },",
        "#{ estimate.time_remaining }"
      ].join(' ')
    end

    private

    # Align the items_done number to the right.
    #
    # @return [String]
    def items_done
      estimate.items_done.to_s.rjust(items_size_digits)
    end

    # Number of digits for the items_size number.
    #
    # @return [Fixnum]
    def items_size_digits
      estimate.items_size.to_s.size
    end

    # Format percentage number.
    #
    # @return [String]
    def percentage
      Kernel.format('%6.02f', estimate.percentage)
    end
  end
end
