class Hash
  def do_with(sym, other)
    res = {}
    each do |k, v|
      if v.instance_of?(Hash)
        res[k] = v.do_with(sym, other[k])
      else
        res[k] = v.send(sym, other[k])
      end
    end
    res
  end

  def map_in_depth(&block)
    res = {}
    each do |k, v|
      if v.instance_of?(Hash)
        res[k] = v.map_in_depth { |nk, nv| block.call(nk, nv) }
      else
        res[k] = block.call(k, v)
      end
    end
    res
  end

  def reduce_in_depth(sym)
    s = nil
    each do |k, v|
      v = v.reduce_in_depth(sym) if v.instance_of?(Hash)
      if s
        s = s.send(sym, v)
      else
        s = v
      end
    end
    s
  end
end
