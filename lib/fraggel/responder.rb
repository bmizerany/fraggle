module Fraggel

  class Responder

    def initialize(&blk)
      @receiver = blk
    end

    def receive_event(name, value)
      receive_event! name, value do |x|
        @receiver.call(x)
      end
    end

    def receive_event!(name, value, &blk)
      @rcs ||= lambda {|x|
        blk.call(x)
        @rcs = nil
      }

      case name
      when :array
        @rcs = array!(value, [], &@rcs)
      when :value
        @rcs.call(value)
      when :error
        @rcs.call(StandardError.new(value))
      when :status
        # I'm not sure if this is a good idea.  Symbols are not garbage
        # collected.  If there server sends and arbitrary number of status
        # messages, this could get ugly.  I'm not sure that's a problem yet.
        @rcs.call(value.to_sym)
      else
        fail "Unknown Type #{name.inspect}"
      end
    end

    def array!(c, a, &blk)
      lambda {|x|
        a << x
        if c == a.length
          blk.call(a)
          @rcs = blk
        else
          array!(c, a, &blk)
        end
      }
    end

  end

end