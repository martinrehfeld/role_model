require 'role_model/roles'

module RoleModel

  INHERITABLE_CLASS_ATTRIBUTES = [:roles_attribute_name, :valid_roles]

  def self.included(base) # :nodoc:
    base.extend ClassMethods
    base.class_eval do
      class << self
        attr_accessor(*::RoleModel::INHERITABLE_CLASS_ATTRIBUTES)
      end
      roles_attribute :roles_mask
    end

    # assign roles
    def roles=(*roles)
      self.send("#{self.class.roles_attribute_name}=", (Array[*roles].flatten.map { |r| r.to_sym } & self.class.valid_roles).map { |r| 2**self.class.valid_roles.index(r) }.inject { |sum, bitvalue| sum + bitvalue })
    end

    # query assigned roles
    def roles
      Roles.new(self, self.class.valid_roles.reject { |r| ((self.send(self.class.roles_attribute_name) || 0) & 2**self.class.valid_roles.index(r)).zero? })
    end
    alias role_symbols roles

    # check if a given role has been assigned
    def has_role?(role)
      roles.include?(role.to_sym)
    end
    alias is_a? has_role?
  end

  module ClassMethods
    def inherited(subclass) # :nodoc:
      ::RoleModel::INHERITABLE_CLASS_ATTRIBUTES.each do |attribute|
        instance_var = "@#{attribute}"
        subclass.instance_variable_set(instance_var, instance_variable_get(instance_var))
      end
      super
    end

    # set the bitmask attribute role assignment will be stored in
    def roles_attribute(name)
      self.roles_attribute = name
    end

    # alternative method signature: set the bitmask attribute role assignment will be stored in
    def roles_attribute=(name)
      self.roles_attribute_name = name.to_sym
    end

    # declare valid roles
    def roles(*roles)
      self.valid_roles = Array[*roles].flatten.map { |r| r.to_sym }
    end
  end

end
