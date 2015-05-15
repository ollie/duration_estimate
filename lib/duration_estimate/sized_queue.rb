class DurationEstimate
  # Queue (array) that can hold +max_size+ items at most.
  class SizedQueue
    # Collection of items.
    #
    # @return [Array]
    attr_accessor :items

    # Maximum number the collection will hold.
    #
    # @return [Fixnum]
    attr_accessor :max_size

    # Setup.
    #
    # @param max_size [Fixnum] What is the maximum size?
    def initialize(max_size)
      self.max_size = max_size
      self.items    = []
    end

    # Add an item into the collection.
    #
    # @param item [Object] Item to add.
    #
    # @return [SizedQueue] Self.
    def <<(item)
      items << item
      items.shift if items.size > max_size
      self
    end

    # Calculate mean (average). It is assumed that the objects in collection
    # respond to +:++ method.
    #
    # @return [Numeric, nil]
    def average
      size = items.size
      return if size.zero?
      items.reduce(:+) / size
    end
  end
end
