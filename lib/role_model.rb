require 'role_model/class_methods'
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
    alias is_an? has_role?
  end

end
