class RemoveUpvotesFromForumThreads < ActiveRecord::Migration[7.1]
  def change
    remove_column :forum_threads, :upvotes, :integer
  end
end
