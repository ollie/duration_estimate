require 'benchmark'

require 'duration_estimate/version'
require 'duration_estimate/sized_queue'
require 'duration_estimate/null_time'
require 'duration_estimate/terminal_formatter'

# Do something to a collection of items and see how long it is going to take.
# Useful for long-running Rake tasks.
#
#   items = 0..10000 # Some data set.
#
#   DurationEstimate.each(items) do |item, e|
#     print "\r#{ DurationEstimate::TerminalFormatter.format(e) }"
#
#     # Do something time consuming with item.
#     sleep 0.001
#   end
#
#   puts
#
# You can specify the collection size if you are using some kind of ORM that
# does not respond to `:size` method.
#
#   media = Media
#     .where { created_at > Time.parse('some time') }
#     .order(:created_at)
#
#   File.open('missing-media.log', 'w') do |log|
#     DurationEstimate.each(media, size: media.count) do |medium, e|
#       print "\r#{ DurationEstimate::TerminalFormatter.format(e) }"
#
#       unless medium.on_s3?
#         log.puts medium.id
#         log.fsync # Write changes now, be able tail the file.
#       end
#
#       sleep 2 # Don't overload AWS S3
#     end
#   end
#
#   puts
#
# This is going to re-print a line with something like this:
#
#    1/11 (  9.09 %) -, -
#    2/11 ( 18.18 %) 11:47:29, 00:00:34
#    3/11 ( 27.27 %) 11:47:30, 00:00:31
#    4/11 ( 36.36 %) 11:47:31, 00:00:27
#    5/11 ( 45.45 %) 11:47:31, 00:00:23
#    6/11 ( 54.55 %) 11:47:30, 00:00:19
#    7/11 ( 63.64 %) 11:47:30, 00:00:15
#    8/11 ( 72.73 %) 11:47:30, 00:00:11
#    9/11 ( 81.82 %) 11:47:30, 00:00:07
#   10/11 ( 90.91 %) 11:47:30, 00:00:03
#   11/11 (100.00 %) 11:47:30, 00:00:00
class DurationEstimate
  # Some collection to run through.
  #
  # @return [Enumerable]
  attr_accessor :items

  # Number of items.
  #
  # @return [Fixnum]
  attr_accessor :items_size

  # Number of items done.
  #
  # @return [Fixnum]
  attr_accessor :items_done

  # Number of items remaining.
  #
  # @return [Fixnum]
  attr_accessor :items_remaining

  # Hold operation times.
  #
  # @return [SizedQueue]
  attr_accessor :times

  # Iterate through collection, measure how long it took, yield the item
  # as well as self to use helper methods.
  #
  # @yieldparam item [Object]           Current item in collection.
  # @yieldparam e    [DurationEstimate] This instance.
  def self.each(*args, &block)
    new(*args).each(&block)
  end

  # Setup.
  #
  # @param  items          [Enumerable] Some collection to run through.
  # @param  options        [Hash]
  # @option options :size  [Fixnum] Total number of items.
  def initialize(items, options = {})
    self.items           = items
    self.items_size      = options[:size] || items.size
    self.items_done      = 0
    self.items_remaining = items_size
    self.times           = SizedQueue.new(5)
  end

  # Iterate through collection, measure how long it took, yield the item
  # as well as self to use helper methods.
  #
  # @yieldparam item [Object]           Current item in collection.
  # @yieldparam e    [DurationEstimate] This instance.
  def each
    items.each do |item|
      measure do
        self.items_done      += 1 # rubocop:disable Style/SpaceAroundOperators
        self.items_remaining -= 1

        yield item, self
      end
    end
  end

  # Calculate end time when all will be done.
  #
  # @return [Time, NullTime]
  def ends_at
    seconds = seconds_left
    return NullTime.new unless seconds
    Time.now + seconds
  end

  # Calculate future time when all will be well and done.
  #
  # @return [String]
  def time_remaining
    seconds = seconds_left
    return '-' unless seconds

    minutes, seconds = seconds.divmod(60)
    hours, minutes   = minutes.divmod(60)

    [
      "#{ format('%02d', hours) }",
      "#{ format('%02d', minutes) }",
      "#{ format('%02d', seconds) }"
    ].compact.join(':')
  end

  # Calculates percentage of done items.
  #
  # @return [Float]
  def percentage
    items_done.to_f / items_size * 100
  end

  private

  # Calculate how many seconds are left until the end.
  #
  # @return [Numeric, nil]
  def seconds_left
    average = times.average
    return unless average
    items_remaining * average
  end

  # Do some operation and record how long it took.
  def measure
    times << Benchmark.realtime { yield }
  end
end
