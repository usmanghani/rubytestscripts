class CreatePeople < ActiveRecord::Migration
  def self.up
    create_table :people do |t|
      t.column :id, :int, :null => false
      t.column :name, :string
    end
  end
  
  def self.down
    drop_table :people
  end
  
end
