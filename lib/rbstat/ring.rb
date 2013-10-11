module Rbstat
  class Ring
    def initialize(size_limit)
      @size_limit = size_limit
      @cur_index = 0
      @records = []
    end

    def add(record)
      if @records.length >= @size_limit
        @records[@cur_index] = record
        @cur_index = (@cur_index + 1) % @size_limit
      else
        @records << record
      end
    end

    def get
      res = []
      if @records.length < @size_limit
        res = @records
      else
        i = @cur_index
        while res.length < @size_limit
          res << @records[i]
          i = (i + 1) % @size_limit
        end
      end
      res
    end
  end
end
