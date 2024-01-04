class CreateForumThreads < ActiveRecord::Migration[7.1]
  def change
    create_table :forum_threads do |t|
      t.string :title
      t.string :description
      t.integer :upvotes
      t.string :author
      t.belongs_to :author, null: false, foreign_key: true

      t.timestamps
    end
  end
end
