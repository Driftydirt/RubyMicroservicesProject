class CreateUsers < ActiveRecord::Migration[7.0]
  def change
    create_table :users do |t|
      t.string :auth_id
      t.timestamps
    end
  end
end
