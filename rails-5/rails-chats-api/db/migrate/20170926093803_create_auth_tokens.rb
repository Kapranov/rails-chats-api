class CreateAuthTokens < ActiveRecord::Migration[5.1]
  def change
    create_table :auth_tokens do |t|
      t.string :value
      t.belongs_to :user, index: { unique: true }, foreign_key: true

      t.timestamps
    end
  end
end
