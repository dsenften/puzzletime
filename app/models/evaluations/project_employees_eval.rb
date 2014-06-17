# encoding: utf-8

class ProjectEmployeesEval < Evaluation

  self.division_method  = :employees
  self.division_column  = :employee_id
  self.label            = 'Mitarbeiter'
  self.category_ref     = 'ANY ( path_ids )'

  def initialize(project_id, alltime)
    super(Project.find(project_id))
    @alltime = alltime
  end

  def divisions(period = nil)
    @alltime ? category.employees : category.managed_employees
  end

  def division_supplement(user)
    [[:last_completion, 'Komplettiert']]
  end

  def employee_id
    division.id if division
  end

  def account_id
    category.id
  end

  ####### overwritten methods for working with project hierarchies

  def category_label
    "Projekt: #{category.top? ? category.label : category.label_verbose}"
  end

  def worktime_query(receiver, period = nil, division = nil)
    super(receiver, period, division).joins(:project)
  end

  def set_division_id(division_id = nil)
    return if division_id.nil?
    @division = Employee.find(division_id.to_i)
  end

end
