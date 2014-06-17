# encoding: utf-8
# == Schema Information
#
# Table name: departments
#
#  id        :integer          not null, primary key
#  name      :string(255)      not null
#  shortname :string(3)        not null
#


class Department < ActiveRecord::Base

  include Evaluatable
  extend Manageable

  has_many :projects, -> { where(parent_id: nil) }

  has_many :all_projects, class_name: 'Project'

  before_destroy :protect_worktimes

  scope :list, -> { order('name') }

  def to_s
    name
  end

  def worktimes
    Worktime.joins(:project).
             where(projects: { department_id: id })
  end

  ##### interface methods for Manageable #####

  def self.puzzlebase_map
    Puzzlebase::Unit
  end

  ##### interface methods for Evaluatable #####

  def self.worktimes
    Worktime.all
  end

end
