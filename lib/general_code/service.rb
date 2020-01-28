# frozen_string_literal: true

# Small foundation for all service classes.
#
# Typical definition of service class will go like doing something with `subject`:
#
# ```ruby
# class DoSomethingService < Service::Base
#   transaction!   -  wrap call method in ActiveRecord::Base.transaction, by default it turned off
#
#   subject :subject_name
#   param :param1, default: 5, &:to_i
#   param(:param2) { |val| convert_somehow(val) }
#   param :param3 # no converter block, just passed as is
#
#   # this DSL will auto-define initialize looking like this:
#   #
#   #   def initialize(performer, subject_name:, param1: 5, param2: nil, param3: nil)
#   #
#   # ..and will run the converting blocks where they are defined
#
#   private
#
#   def allowed?
#     performer.admin? || performer.something_else? # if this will not be matched, ValidationError is raise
#   end
#
#   def validate!
#     invalid(param1: 'Explanation') if something
#   end
#
#   def _call
#     # do the real work
#   end
# end
#
# # usage of this class:
# DoSomethingService.new(subject_name: something, param1_name: something, param2_name: something).call
# # or
# DoSomethingService.new(params.to_unsafe_hash.symbolize_keys).call
# ```
#
module Service
  # Thrown when mandatory parameter, described with param: DSL is not passed.
  class MissingParameter < ArgumentError
    attr_reader :param

    def initialize(param, message = nil)
      @param = param
      super(message || "Missing parameter: #{param}")
    end
  end

  # Validation error, when parameter has wrong value
  class ValidationError < ArgumentError
    attr_reader :subject, :errors

    def initialize(subject: nil, **errors)
      @record = subject
      @errors = errors
      super(@errors.values.join('. '))
    end
  end

  # Base for all services.
  class Base
    ABSENT = Object.new.freeze

    attr_reader :params

    def initialize(**attrs)
      @params = {}

      initialize_subject(attrs)
      initialize_attrs(attrs)
    end

    def subject
      raise 'No subject declared' unless self.class._subject

      instance_variable_get "@#{self.class._subject}"
    end

    def call
      transaction_wrap do
        validate!
        _call
      end
    end

    class_attribute :_subject, instance_accessor: false
    class_attribute :_params, instance_accessor: false
    class_attribute :_transaction_wrap, instance_accessor: false
    # Rails 5.1 doesn't have :default options for class_attribute method
    self._subject = nil
    self._params = {}
    self._transaction_wrap = false

    class << self
      # DSL for specify subject and params and automatically declare attr accessors and assign params to it

      def subject(name)
        self._subject = name.to_sym
        attr_reader name.to_sym
      end

      def param(name, **options, &converter)
        options[:converter] = converter if block_given?

        attr_reader name.to_sym
        # Replace _params because we need to invoke class attribute setter
        # If we are use .update we will have one params instance for all child classes.
        self._params = _params.merge(name.to_sym => options)
      end

      # DSL to specify that service `call` method should be wrapped in transaction,
      # be aware if you use this setting in you service that `call` method can raise
      # ActiveRecord:Rollback exception, so it is responsibility of caller to rescue it
      def transaction!(value = true)
        self._transaction_wrap = value
      end

      # In some cases we expect to receive array, but from controller we receive hash which looks like:
      #   {'1' => item, '2' => item2}
      # So for this case we should to transform it to array
      def ensure_array(val)
        if val.is_a?(Hash)
          val.compact.values
        else
          val
        end
      end
    end

    private

    def transaction_wrap
      return yield unless self.class._transaction_wrap

      ActiveRecord::Base.transaction { yield }
    end

    def _subject
      self.class._subject
    end

    def initialize_subject(attrs)
      return if _subject.blank?

      value = attrs.fetch(_subject) { raise ArgumentError, "#{_subject} is missing" }
      raise ArgumentError, "#{_subject} attrs is not present" if value.nil?

      instance_variable_set "@#{_subject}", value
    end

    def initialize_attrs(attrs)
      self.class._params.each do |name, **definition|
        initialize_attr(attrs, name, **definition)
      end
    end

    # Notice that:
    # * default could be proc, in this case it is evaluated
    # * converter is performed only on NON-DEFAULT value. This allows to have
    #
    #     param :foo, default: nil, &JSON.method(:parse)
    #
    #   -- e.g., "it could be absent, but if not, should be parsed"
    def initialize_attr(attrs, name, default: ABSENT, converter: nil, **)
      if !attrs.key?(name) && default == ABSENT
        raise MissingParameter.new(name, "Service parameter :#{name} missing, passed params: #{attrs.keys}")
      end

      value =
        if attrs.key?(name)
          attrs[name].then { |val| converter ? instance_exec(val, &converter) : val }
        else
          default.then { |val| val.is_a?(Proc) ? instance_eval(&val) : val }
        end
      instance_variable_set "@#{name}", value
      @params[name] = value
    end

    def validate!; end

    def allowed?
      true
    end

    def _call
      raise NotImplementedError
    end

    def invalid(**errors)
      raise Service::ValidationError, errors
    end
  end
end
