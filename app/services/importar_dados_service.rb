class ImportarDadosService
  def initialize(classes_data, members_data)
    @classes = classes_data
    @members = members_data
    @counts = Hash.new(0)
  end

  def call
    ActiveRecord::Base.transaction do
      @members.each { |entry| import_entry(entry) }
    end
    { success: true, summary: build_summary }
  rescue StandardError => e
    { success: false, errors: [ e.message ] }
  end

  private

  def import_entry(entry)
    class_info = find_class_info(entry["code"], entry["classCode"], entry["semester"])
    return unless class_info

    departamento = find_or_create_departamento(entry.dig("docente", "departamento"))
    materia      = find_or_create_materia(class_info, departamento)
    professor    = find_or_create_professor(entry["docente"])
    turma        = find_or_create_turma(class_info, materia, professor)

    Array(entry["dicente"]).each { |student| import_student(student, turma) }
  end

  def find_class_info(code, class_code, semester)
    @classes.find do |c|
      c["code"] == code &&
        c.dig("class", "classCode") == class_code &&
        c.dig("class", "semester") == semester
    end
  end

  def find_or_create_departamento(nome)
    record = Departamento.find_or_create_by!(nome_departamento: nome)
    @counts[:departamentos] += 1 if record.previously_new_record?
    record
  end

  def find_or_create_materia(class_info, departamento)
    record = Materia.find_or_create_by!(codigoMateria: class_info["code"]) do |m|
      m.nome_materia = class_info["name"]
      m.departamento = departamento
    end
    @counts[:materias] += 1 if record.previously_new_record?
    record
  end

  def find_or_create_professor(docente_data)
    usuario = find_or_create_usuario(
      nome: docente_data["nome"],
      email: docente_data["email"],
      matricula: docente_data["usuario"],
      role: :professor
    )
    record = Professor.find_or_create_by!(usuario: usuario)
    @counts[:professores] += 1 if record.previously_new_record?
    record
  end

  def find_or_create_turma(class_info, materia, professor)
    numero = class_numero(class_info.dig("class", "classCode"))
    record = Turma.find_or_create_by!(
      materia: materia,
      numero_turma: numero,
      semestre_string: class_info.dig("class", "semester")
    ) do |t|
      t.professor = professor
    end
    @counts[:turmas] += 1 if record.previously_new_record?
    record
  end

  def import_student(student_data, turma)
    usuario = find_or_create_usuario(
      nome: student_data["nome"],
      email: student_data["email"],
      matricula: student_data["matricula"],
      role: :estudante
    )
    estudante = Estudante.find_or_create_by!(usuario: usuario) do |e|
      e.matricula = student_data["matricula"]
    end
    @counts[:estudantes] += 1 if estudante.previously_new_record?

    matricula = Matricula.find_or_create_by!(estudante: estudante, turma: turma)
    @counts[:matriculas] += 1 if matricula.previously_new_record?
  end

  def find_or_create_usuario(nome:, email:, matricula:, role:)
    record = Usuario.find_or_create_by!(email: email.to_s.downcase.strip) do |u|
      u.nome = nome
      u.matricula = matricula
      u.role = role
      temp_password = "Camaar#{matricula}"
      u.password = temp_password
      u.password_confirmation = temp_password
    end
    @counts[:usuarios] += 1 if record.previously_new_record?
    record
  end

  # "TA" → 1, "TB" → 2, etc. (last alphabetic character maps to ordinal)
  def class_numero(class_code)
    letter = class_code.to_s[-1] || "A"
    (letter.upcase.ord - "A".ord + 1).clamp(1, 26)
  end

  def build_summary
    parts = @counts.filter_map { |k, v| "#{v} #{k}" if v > 0 }
    parts.any? ? "#{parts.join(', ')} criados." : "Nenhum registro novo criado."
  end
end
