require 'rbstat/sampler/sampler'

module Rbstat
  module Sampler
    class Stat < Rbstat::Sampler::Sampler
      def initialize
        @last = snapshot
      end

      def sample
        cur = snapshot
        res = to_sample(cur)
        @last = cur
        res
      end

      def to_sample
      end

      def snapshot
      end
    end
  end
end
