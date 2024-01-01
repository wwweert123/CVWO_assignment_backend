class CreateComments < ActiveRecord::Migration[7.1]
  def change
    create_table :comments do |t|
      t.string :text
      t.string :author
      t.belongs_to :forum_thread, null: false, foreign_key: true

      t.timestamps
    end
  end
end
