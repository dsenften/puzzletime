# encoding: utf-8

class Puzzlebase::Employee < Puzzlebase::Base
  has_many :employments,
           foreign_key: 'FK_EMPLOYEE'

  MAPS_TO = ::Employee
  MAPPINGS = { shortname: :S_SHORTNAME,
               lastname: :S_LASTNAME,
               firstname: :S_FIRSTNAME,
               ldapname: :S_LDAPNAME,
               email: :S_EMAIL }

  # Synchronizes the Employees and their Employments.
  def self.synchronize
    reset_errors
    update_all
    Puzzlebase::Employment.update_all
    errors
  end

end


class Employee < ActiveRecord::Base
  def debug_string
    "#{shortname}: #{label} (#{ldapname})"
  end
end
