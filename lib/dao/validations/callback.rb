# -*- encoding : utf-8 -*-
module Dao
  module Validations
    class Callback < ::Proc
      attr :options

      def initialize(options = {}, &block)
        @options = Map.for(options || {})
        super(&block)
      end

      def block
        self
      end

      class Chain
        def initialize
          @chain = []
        end

        def add(callback)
          @chain.push(callback)
        end

        def each(&block)
          @chain.each(&block)
        end

        def each_with_index(&block)
          @chain.each_with_index(&block)
        end
      end
    end
  end
end
