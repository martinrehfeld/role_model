require 'set'

module RoleModel
  class Roles < ::Set # :nodoc:
    attr_reader :model_instance

    def initialize(sender, *roles)
      super(*roles)
      @model_instance = sender
    end

    def <<(role)
      model_instance.roles = super
      self
    end

    def delete(role)
      model_instance.roles = super(role.to_sym)
      self
    end

  end
end

