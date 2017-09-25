class CreateChatsUsers < ActiveRecord::Migration[5.1]
  def change
    create_table :chats_users do |t|
      t.belongs_to :chat, foreign_key: true
      t.belongs_to :user, foreign_key: true

      t.timestamps
    end
  end
end
