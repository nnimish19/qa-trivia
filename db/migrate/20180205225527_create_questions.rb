class CreateQuestions < ActiveRecord::Migration[5.1]
  def change
    create_table :questions do |t|
      t.text :statement
      t.text :answer
      t.references :user, foreign_key: true

      t.timestamps
    end
  end
end
