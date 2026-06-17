# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[8.1].define(version: 2024_06_02_000001) do
  create_table "departments", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "name", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_departments_on_name", unique: true
  end

  create_table "enrollments", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.integer "turma_id", null: false
    t.datetime "updated_at", null: false
    t.integer "user_id", null: false
    t.index ["turma_id"], name: "index_enrollments_on_turma_id"
    t.index ["user_id", "turma_id"], name: "index_enrollments_on_user_id_and_turma_id", unique: true
    t.index ["user_id"], name: "index_enrollments_on_user_id"
  end

  create_table "formularios", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.integer "created_by_id", null: false
    t.datetime "deadline", null: false
    t.integer "department_id", null: false
    t.text "description"
    t.integer "template_id"
    t.string "title", null: false
    t.datetime "updated_at", null: false
    t.index ["department_id"], name: "index_formularios_on_department_id"
    t.index ["template_id"], name: "index_formularios_on_template_id"
  end

  create_table "questoes", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.text "enunciado", null: false
    t.integer "formulario_id", null: false
    t.integer "position", default: 0, null: false
    t.boolean "required", default: true, null: false
    t.datetime "updated_at", null: false
    t.index ["formulario_id"], name: "index_questoes_on_formulario_id"
  end

  create_table "resposta_questoes", force: :cascade do |t|
    t.text "answer"
    t.datetime "created_at", null: false
    t.integer "questao_id", null: false
    t.integer "resposta_id", null: false
    t.datetime "updated_at", null: false
    t.index ["questao_id"], name: "index_resposta_questoes_on_questao_id"
    t.index ["resposta_id", "questao_id"], name: "index_resposta_questoes_on_resposta_id_and_questao_id", unique: true
    t.index ["resposta_id"], name: "index_resposta_questoes_on_resposta_id"
  end

  create_table "respostas", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.integer "formulario_id", null: false
    t.datetime "submitted_at", null: false
    t.integer "turma_id", null: false
    t.datetime "updated_at", null: false
    t.integer "user_id", null: false
    t.index ["formulario_id"], name: "index_respostas_on_formulario_id"
    t.index ["turma_id"], name: "index_respostas_on_turma_id"
    t.index ["user_id", "formulario_id", "turma_id"], name: "index_respostas_on_user_id_and_formulario_id_and_turma_id", unique: true
    t.index ["user_id"], name: "index_respostas_on_user_id"
  end

  create_table "templates", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "name", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_templates_on_name", unique: true
  end

  create_table "turma_formularios", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.integer "formulario_id", null: false
    t.integer "turma_id", null: false
    t.datetime "updated_at", null: false
    t.index ["formulario_id"], name: "index_turma_formularios_on_formulario_id"
    t.index ["turma_id", "formulario_id"], name: "index_turma_formularios_on_turma_id_and_formulario_id", unique: true
    t.index ["turma_id"], name: "index_turma_formularios_on_turma_id"
  end

  create_table "turmas", force: :cascade do |t|
    t.string "codigo", null: false
    t.datetime "created_at", null: false
    t.integer "department_id", null: false
    t.string "name", null: false
    t.string "semester", null: false
    t.datetime "updated_at", null: false
    t.index ["department_id"], name: "index_turmas_on_department_id"
  end

  create_table "users", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.integer "department_id"
    t.string "email", null: false
    t.string "name", null: false
    t.string "password_digest", null: false
    t.integer "role", default: 0, null: false
    t.datetime "updated_at", null: false
    t.index ["department_id"], name: "index_users_on_department_id"
    t.index ["email"], name: "index_users_on_email", unique: true
  end

  add_foreign_key "enrollments", "turmas"
  add_foreign_key "enrollments", "users"
  add_foreign_key "formularios", "departments"
  add_foreign_key "formularios", "templates"
  add_foreign_key "formularios", "users", column: "created_by_id"
  add_foreign_key "questoes", "formularios"
  add_foreign_key "resposta_questoes", "questoes"
  add_foreign_key "resposta_questoes", "respostas"
  add_foreign_key "respostas", "formularios"
  add_foreign_key "respostas", "turmas"
  add_foreign_key "respostas", "users"
  add_foreign_key "turma_formularios", "formularios"
  add_foreign_key "turma_formularios", "turmas"
  add_foreign_key "turmas", "departments"
  add_foreign_key "users", "departments"
end
