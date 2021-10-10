# frozen_string_literal: true

class CreateNotes < ActiveRecord::Migration[6.1]
  def change
    create_table :notes do |t|
      t.references :user, null: false
      t.string :title, null: false
      t.text :body, null: true

      t.timestamps
    end
  end
end
