# encoding: UTF-8
require 'test_helper'

class ListOrdersTest < ActionDispatch::IntegrationTest
  test 'list invoices as employee has no create/edit/destroy links' do
    timeout_safe do
      list_invoices_as :pascal
      assert has_no_link?('Erstellen')
      assert has_no_link?('Bearbeiten')
      assert has_no_link?('Löschen')
    end
  end

  test 'list invoices as order responsible member has create/edit/destroy links' do
    timeout_safe do
      list_invoices_as :long_time_john
      assert has_link?('Erstellen')
      assert has_link?('Bearbeiten')
      assert has_link?('Löschen')
    end
  end

  test 'list invoices as management has create/edit/destroy links' do
    timeout_safe do
      list_invoices_as :mark
      assert has_link?('Erstellen')
      assert has_link?('Bearbeiten')
      assert has_link?('Löschen')
    end
  end

  private

  def list_invoices_as(employee)
    login_as employee
    visit order_invoices_path(order_id: orders(:webauftritt).id)
  end
end