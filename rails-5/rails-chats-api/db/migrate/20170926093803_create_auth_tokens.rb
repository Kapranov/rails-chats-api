class CreateAuthTokens < ActiveRecord::Migration[5.1]
  def change
    create_table :auth_tokens do |t|
      t.string :value
      t.belongs_to :user, foreign_key: true

      t.timestamps
    end
  end
end
