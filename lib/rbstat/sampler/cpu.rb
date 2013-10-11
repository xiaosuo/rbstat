require 'rbstat/sampler/stat'
require 'rbstat/hash'

module Rbstat
  module Sampler
    class CPU < Rbstat::Sampler::Stat
      def to_sample(cur)
        res = {}
        @last.each do |cpu, data|
          cur_total = cur[cpu].reduce_in_depth(:+)
          total = data.reduce_in_depth(:+)
          if total == cur_total
            res[cpu] = { :user => 0, :sys => 0, :idle => 1.0 }
          else
            total = (cur_total - total).to_f
            res[cpu] = cur[cpu].do_with(:-, data)
            res[cpu] = res[cpu].map_in_depth { |k, v| v / total }
          end
          res[cpu][:use] = 1 - res[cpu][:idle]
        end
        res
      end

      def snapshot
        data = {}
        IO.foreach('/proc/stat') do |line|
          next if line !~ /^cpu[0-9]*\s/
          # cpu user nice sys idle iowait irq softirq steal guest
          cpu, *times = line.split(/\s+/)
          times = times.map { |i| i.to_i }
          total = times.reduce(:+)
          user, nice, sys, idle = times
          user = user + nice
          sys = total - idle - user
          data[cpu.to_sym] = { :sys => sys, :user => user, :idle => idle }
        end
        data
      end
    end
  end
end
