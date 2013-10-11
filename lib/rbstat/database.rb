require 'rbstat/data_node'

module Rbstat
  class Database
    def initialize
      @root = {}
    end

    def add(key, value)
      _add(@root, key, value)
    end

    def _add(parent, key, value)
      if value.instance_of?(Hash)
        parent[key] = {} if parent[key].nil?
        value.each do |k, v|
          _add(parent[key], k, v)
        end
      else
        parent[key] = DataNode.new if parent[key].nil?
        parent[key].add(value)
      end
    end

    def get(keys)
      node = resolve(keys)
      return nil if node.nil?
      node.get
    end

    def resolve(keys)
      cur = @root
      keys.each do |k|
        k = k.to_sym
        return nil if cur[k].nil?
        cur = cur[k]
      end
      return nil if cur.instance_of?(Hash)
      cur
    end

    def add_observer(keys, ob)
      parent = nil
      cur = @root
      k = nil
      keys.each do |k|
        parent = cur
        cur[k] = {} if cur[k].nil?
        cur = cur[k]
      end
      cur = parent[k] = DataNode.new if cur.instance_of?(Hash) and cur.length == 0
      cur.add_observer(ob) if cur.instance_of?(DataNode)
    end
  end
end
