class Ability
  include CanCan::Ability

  attr_reader :user

  def initialize(user)
    @user = user
    alias_action :create, :read, :update, :destroy, :delete, to: :crud

    if user.management?
      management_abilities
    elsif user.order_responsible?
      order_responsible_abilities
    end

    everyone_abilities
  end

  private

  def management_abilities
    can :manage, [Absence,
                  AccountingPost,
                  BillingAddress,
                  Client,
                  Contact,
                  Department,
                  Employment,
                  Invoice,
                  Holiday,
                  Contract,
                  Order,
                  OrderKind,
                  OrderStatus,
                  OrderTarget,
                  OrderComment,
                  OvertimeVacation,
                  PortfolioItem,
                  TargetScope,
                  UserNotification,
                  WorkingCondition,
                  WorkItem]

    # cannot change settings of other employees
    can [:crud, :update_committed_worktimes], Employee do |_|
      true
    end

    can [:read, :create, :update], Worktime

    can [:clients,
         :employees,
         :overtime,
         :clientworkitems,
         :departments,
         :departmentorders,
         :managed,
         :employeeworkitems,
         :employeesubworkitems,
         :absences,
         :employeeabsences,
         :export_capacity_csv,
         :export_extended_capacity_csv,
         :export_ma_overview], Evaluation
  end

  def order_responsible_abilities
    can :manage, [Client, BillingAddress, Contact]
    can :create, WorkItem
    can :manage, Order, responsible_id: user.id
    can :manage, [AccountingPost, Contract, Invoice, OrderComment, Ordertime] do |instance|
      instance.order.responsible_id == user.id
    end
    can :managed, Evaluation
  end

  def everyone_abilities
    can :manage, Worktime, employee_id: user.id
    can :search, WorkItem

    can :read, Employee
    can [:passwd, :update_passwd, :settings, :update_settings,
         :update_committed_worktimes], Employee do |employee|
      employee == user
    end

    can [:read, :accounting_posts, :services, :show_targets, :show_contract, :show_comments,
         :show_invoices], Order

    can :read, [AccountingPost, Invoice, OrderComment]

    can :manage, Planning

    can :manage, EmployeeList

    can [:select_period,
         :current_period,
         :change_period,
         :compose_report,
         :report,
         :export_csv,
         :absencedetails,
         :userworkitems,
         :userabsences,
         :usersubworkitems,
         :subworkitems,
         :workitememployees,
         :orderworkitems], Evaluation
  end
end
