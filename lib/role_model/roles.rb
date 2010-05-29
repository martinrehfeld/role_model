module RoleModel
  class Roles < Array
    attr_reader :model_instance

    def initialize(sender, *roles)
      super(*roles)
      @model_instance = sender
    end

    def <<(role)
      model_instance.roles = super
    end
  end
end
