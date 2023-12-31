class CreateForumThreads < ActiveRecord::Migration[7.1]
  def change
    create_table :forum_threads do |t|
      t.string :title
      t.string :description
      t.integer :upvotes

      t.timestamps
    end
  end
end
