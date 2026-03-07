class Employee
  DB_PATH = Rails.root.join("db", "employees.json")

  attr_accessor :id, :name, :position, :salary

  def initialize(attrs = {})
    @id       = attrs["id"] || attrs[:id]
    @name     = attrs["name"] || attrs[:name]
    @position = attrs["position"] || attrs[:position]
    @salary   = attrs["salary"] || attrs[:salary]
  end

  # ---- Class methods ----

  def self.all
    data = JSON.parse(File.read(DB_PATH))
    data.map { |attrs| new(attrs) }
  end

  def self.find(id)
    all.find { |e| e.id.to_s == id.to_s }
  end

  def self.create(attrs)
    employees = JSON.parse(File.read(DB_PATH))
    new_id = (employees.map { |e| e["id"] }.max || 0) + 1
    record = { "id" => new_id, "name" => attrs[:name], "position" => attrs[:position], "salary" => attrs[:salary] }
    employees << record
    File.write(DB_PATH, JSON.pretty_generate(employees))
    new(record)
  end

  # ---- Instance methods ----

  def update(attrs)
    employees = JSON.parse(File.read(DB_PATH))
    index = employees.index { |e| e["id"].to_s == @id.to_s }
    return false unless index

    employees[index].merge!("name" => attrs[:name], "position" => attrs[:position], "salary" => attrs[:salary])
    File.write(DB_PATH, JSON.pretty_generate(employees))
    @name     = attrs[:name]
    @position = attrs[:position]
    @salary   = attrs[:salary]
    true
  end

  def destroy
    employees = JSON.parse(File.read(DB_PATH))
    employees.reject! { |e| e["id"].to_s == @id.to_s }
    File.write(DB_PATH, JSON.pretty_generate(employees))
  end

  def persisted?
    @id.present?
  end

  def to_param
    @id.to_s
  end
end
