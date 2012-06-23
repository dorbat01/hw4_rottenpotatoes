class AddDirectorColumn < ActiveRecord::Migration
  def up
    add_column(:movies, :director, :string, :null => true)
  end

  def down
  end
end
