class Puzzlebase < ActiveRecord::Migration
  def self.up
    add_column :clients, :shortname, :string, :limit => 4
    change_column :clients, :contact, :string, :null => true
    add_column :projects, :shortname, :string, :limit => 3  
    
    setShortnames Client, 4
    setShortnames Project, 3
    Employee.find(:all).each do |entry|
      entry.update_attribute(:shortname, entry.shortname.upcase)
    end
  end

  def self.down
    remove_column :clients, :shortname
    remove_column :projects, :shortname
  end
  
  def self.setShortnames(clazz, length)
    clazz.find(:all).each do |entry|
      entry.update_attribute(:shortname, entry.name.upcase.slice(0..(length-1)))
    end
  end
end
