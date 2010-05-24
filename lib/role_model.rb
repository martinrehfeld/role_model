module RoleModel
  def self.included(base) # :nodoc:

    # add class methods
    base.instance_eval do
      def roles_attribute(name)
        @@roles_attribute = name.to_sym
      end
      roles_attribute :roles_mask

      def roles(*roles)
        @@valid_roles = Array[*roles].flatten.map { |r| r.to_sym }
      end
    end

    # add instance methods
    base.class_eval do
      def roles=(*roles)
        self.send("#{@@roles_attribute}=", (Array[*roles].flatten.map { |r| r.to_sym } & @@valid_roles).map { |r| 2**@@valid_roles.index(r) }.inject { |sum, bitvalue| sum + bitvalue })
      end

      def roles
        @@valid_roles.reject { |r| ((self.send(@@roles_attribute) || 0) & 2**@@valid_roles.index(r)).zero? }
      end
      alias_method :role_symbols, :roles

      def has_role?(role)
        roles.include?(role.to_sym)
      end
    end

  end
end
