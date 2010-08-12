module RoleModel
  module Implementation

    # assign roles
    def roles=(*roles)
      self.send("#{self.class.roles_attribute_name}=", (Array[*roles].flatten.map { |r| r.to_sym } & self.class.valid_roles).map { |r| 2**self.class.valid_roles.index(r) }.inject { |sum, bitvalue| sum + bitvalue })
    end

    # query assigned roles
    def roles
      Roles.new(self, self.class.valid_roles.reject { |r| ((self.send(self.class.roles_attribute_name) || 0) & 2**self.class.valid_roles.index(r)).zero? })
    end
    alias_method :role_symbols, :roles

    # check if a given role has been assigned 
    # if a list of roles: check if ALL of the given roles have been assigned 
    def has_roles?(*roles)
      (roles.to_a - roles.flatten).empty?      
    end
    alias_method :is?, :has_roles?
    # alias_method :have_roles?, :has_roles?
    
    # check if any (at least ONE) of the given roles have been assigned
    def has_role? *roles
      !(roles.flatten & self.class.valid_roles).empty?            
    end
    alias_method :has?, :has_role?
    # alias_method :have_role?, :has_role?
  end
end
