require 'rbstat/sampler/stat'
require 'rbstat/hash'

module Rbstat
  module Sampler
    class NIC < Rbstat::Sampler::Stat
      def to_sample(cur)
        time = cur[:time] - @last[:time]
        time = 0 if time < 0
        delta = cur[:data].do_with(:-, @last[:data])
        delta.map_in_depth do |k, v|
          if time > 0 and v > 0
            v = v * 8 if k == :bps # to bits
            v / time
          else
            0
          end
        end
      end

      def snapshot
        # save the sample time
        skip = 2
        data = {}
        IO.foreach('/proc/net/dev') do |line|
          # skip the title lines
          if skip > 0
            skip -= 1
            next
          end
          name, numbers = line.split(/\s*:\s*/)
          name = name.strip
          numbers = numbers.split(/\s+/).map { |i| i.to_i }
          data[name.to_sym] = {
            :rx => {
              :bps => numbers[0],
              :pps => numbers[1]
            },
            :tx => {
              :bps => numbers[8],
              :pps => numbers[9]
            }
          }
        end
        { :time => Time.new, :data => data }
      end
    end
  end
end
