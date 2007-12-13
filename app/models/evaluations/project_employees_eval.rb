class ProjectEmployeesEval < Evaluation

  DIVISION_METHOD  = :employees
  LABEL            = 'Mitarbeiter'
  CATEGORY_REF     = :project_id      
  
  def initialize(project_id)
    super(Project.find(project_id))
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
  
end
