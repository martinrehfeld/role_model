require 'set'

module RoleModel
  class Roles < ::Set # :nodoc:
    attr_reader :model_instance

    def initialize(sender, roles)
      super(roles)
      @model_instance = sender
    end

    def add(role)
      roles = super
      model_instance.roles = roles if model_instance
      self
    end

    alias_method :<<, :add

    def delete(role)
      if role.is_a? Array
        model_instance.roles = subtract(role)
      else
        model_instance.roles = super(role.to_sym)
      end
      self
    end

  end
end
