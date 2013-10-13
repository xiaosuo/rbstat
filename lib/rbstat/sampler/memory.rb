require 'rbstat/sampler/sampler'

module Rbstat
  module Sampler
    class Memory < Rbstat::Sampler::Sampler
      def sample
        total = nil
        free = nil
        IO.foreach('/proc/meminfo') do |line|
          k, v = line.split(/\s*:\s*/)
          case k
          when 'MemTotal'
            total = parse_value(v)
          when 'MemFree'
            free = parse_value(v)
          end
          break if total and free
        end
        (total - free)/total.to_f
      end

      def parse_value(v)
        v, unit = v.split(/\s+/)
        mul = 1
        case unit
        when 'kB'
          mul = 1024
        end
        v.to_i * mul
      end
    end
  end
end
