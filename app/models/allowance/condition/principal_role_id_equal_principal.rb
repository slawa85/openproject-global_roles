module Allowance::Condition
  class PrincipalRoleIdEqualPrincipal < Base
    table User
    table PrincipalRole

    def arel_statement(**ignored)
      principal_roles[:principal_id].eq(users[:id])
    end
  end
end
