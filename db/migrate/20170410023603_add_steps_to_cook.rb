class AddStepsToCook < ActiveRecord::Migration[5.0]
  def change
    add_column :cooks, :steps, :string, array: true
  end
end
