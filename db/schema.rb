# This file is autogenerated. Instead of editing this file, please use the
# migrations feature of ActiveRecord to incrementally modify your database, and
# then regenerate this schema definition.

ActiveRecord::Schema.define(:version => 8) do

  create_table "absences", :force => true do |t|
    t.column "name",  :string,                     :null => false
    t.column "payed", :boolean, :default => false
  end

  create_table "clients", :force => true do |t|
    t.column "name",      :string,              :null => false
    t.column "contact",   :string,              :null => false
    t.column "shortname", :string, :limit => 4
  end

  create_table "employees", :force => true do |t|
    t.column "firstname",             :string,                                  :null => false
    t.column "lastname",              :string,                                  :null => false
    t.column "shortname",             :string,  :limit => 3,                    :null => false
    t.column "passwd",                :string,                                  :null => false
    t.column "email",                 :string,                                  :null => false
    t.column "management",            :boolean,              :default => false
    t.column "initial_vacation_days", :float,                :default => 0.0
    t.column "ldapname",              :string
  end

  add_index "employees", ["shortname"], :name => "chk_unique_name", :unique => true

  create_table "employments", :force => true do |t|
    t.column "employee_id", :integer
    t.column "percent",     :integer, :null => false
    t.column "start_date",  :date,    :null => false
    t.column "end_date",    :date
  end

  create_table "holidays", :force => true do |t|
    t.column "holiday_date",  :date,  :null => false
    t.column "musthours_day", :float, :null => false
  end

  create_table "overtime_vacations", :force => true do |t|
    t.column "hours",         :float,   :null => false
    t.column "employee_id",   :integer, :null => false
    t.column "transfer_date", :date,    :null => false
  end

  create_table "projectmemberships", :force => true do |t|
    t.column "project_id",        :integer
    t.column "employee_id",       :integer
    t.column "projectmanagement", :boolean, :default => false
    t.column "last_completed",    :date
  end

  create_table "projects", :force => true do |t|
    t.column "client_id",            :integer
    t.column "name",                 :string,                                    :null => false
    t.column "description",          :text
    t.column "billable",             :boolean,              :default => true
    t.column "report_type",          :string,               :default => "month"
    t.column "description_required", :boolean,              :default => false
    t.column "shortname",            :string,  :limit => 3
  end

  create_table "worktimes", :force => true do |t|
    t.column "project_id",      :integer
    t.column "absence_id",      :integer
    t.column "employee_id",     :integer
    t.column "report_type",     :string,                     :null => false
    t.column "work_date",       :date,                       :null => false
    t.column "hours",           :float
    t.column "from_start_time", :time
    t.column "to_end_time",     :time
    t.column "description",     :text
    t.column "billable",        :boolean, :default => true
    t.column "booked",          :boolean, :default => false
    t.column "type",            :string
  end

end
