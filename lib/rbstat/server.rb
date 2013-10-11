require 'rbstat/database'
require 'rbstat/sampler'
require 'thread'

module Rbstat
  class Server
    def initialize(sampler_interval = 3)
      @mutex = Mutex.new
      @sampler_interval = sampler_interval
      @db = Rbstat::Database.new
      @samplers = {}
      yield self if block_given?
    end

    def register_sampler(key, sampler)
      @samplers[key] = sampler
    end

    def register_observer(keys, ob)
      @mutex.synchronize do
        @db.add_observer(keys, ob)
      end
    end

    def start
      while true
        sleep(@sampler_interval)
        @samplers.each do |key, sampler|
          @mutex.synchronize do
            @db.add(key, sampler.sample)
          end
        end
      end
    end

    def get(keys)
      @mutex.synchronize do
        @db.get(keys)
      end
    end
  end
end
