class AddCategoryIdToServices < ActiveRecord::Migration[5.0]
  def change
    add_reference :services, :category, index: true
  end
end
