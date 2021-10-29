class AddLikesToDogs < ActiveRecord::Migration[5.2]
  def change
    add_column :dogs, :likes, :integer,  default: 0
  end
end
