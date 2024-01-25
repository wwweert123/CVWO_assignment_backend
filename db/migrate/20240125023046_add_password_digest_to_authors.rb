class AddPasswordDigestToAuthors < ActiveRecord::Migration[7.1]
  def change
    add_column :authors, :password_digest, :string
  end
end
