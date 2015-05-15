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
  # Version, man!
  VERSION = '0.0.1'
end
