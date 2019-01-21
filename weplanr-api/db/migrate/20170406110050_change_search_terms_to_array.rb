class ChangeSearchTermsToArray < ActiveRecord::Migration[5.0]
  def up
    change_column :todos, :search_terms, :string, array: true, using: "(string_to_array(search_terms, ';'))"
  end

  def down
    change_column :todos, :search_terms, :string
  end
end
