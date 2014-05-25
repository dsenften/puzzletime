# encoding: utf-8

class BaseCapacityReport

  def initialize(period, filename_prefix)
    @period = period
    @filename_prefix = filename_prefix
  end

  def filename
    "#{@filename_prefix}_#{format_date(@period.startDate)}_#{format_date(@period.endDate)}.csv"
  end

  def find_billable_time(employee, project_id, period)
    Worktime.find_by_sql [''"SELECT SUM(w.hours) AS HOURS, w.billable FROM worktimes w
                             LEFT JOIN projects p ON p.id = w.project_id
                             WHERE w.employee_id = ? AND ? = ANY(p.path_ids)
                             AND w.work_date BETWEEN ? AND ?
                             GROUP BY w.billable"'',
                          employee.id, project_id, period.startDate, period.endDate]
  end

  def extract_billable_hours(result, billable)
    entry = result.select { |w| w.billable == billable }.first
    entry ? entry.hours : 0
  end

  def employee_absences(employee, period)
    employee.worktimes.includes(:absence).
                       where("type = 'Absencetime' AND absences.payed AND work_date BETWEEN ? AND ?",
                             period.startDate,
                             period.endDate).
                       sum(:hours).
                       to_f
  end

  private

  def format_date(date)
    I18n.l(date, format: '%Y%m%d')
  end

end