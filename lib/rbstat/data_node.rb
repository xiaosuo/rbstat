require 'rbstat/ring'

module Rbstat
  class DataNode
    RING_SIZE_LIMIT = 100
    def initialize
      @observers = []
      @ring = Ring.new(RING_SIZE_LIMIT)
    end

    def add(value)
      @ring.add(value)
      @observers.each do |ob|
        ob.call(value)
      end
    end

    def add_observer(ob)
      @observers << ob
    end

    def get
      @ring.get
    end
  end
end
