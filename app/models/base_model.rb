class BaseModel
  attr_reader :errors

  def new_record?
    @id.blank?
  end

  def save
    return false unless valid?
    if new_record?
      insert
    else
      update
    end
    true
  end

  def destroy
    connection.execute("DELETE FROM #{table_name} WHERE #{table_name}.id = ?", id)
  end

  def self.table_name
    to_s.pluralize.downcase
  end

  def self.all
    record_hashes = connection.execute("SELECT * FROM #{table_name}")
    record_hashes.map do |record_hash|
      new(record_hash)
    end
  end

  def self.find(id)
    record_hash = connection.execute("SELECT * FROM #{table_name} WHERE posts.id = ? LIMIT 1", id).first
    new(record_hash)
  end

  private

  def self.connection
    db_connection = SQLite3::Database.new 'db/development.sqlite3'
    db_connection.results_as_hash = true
    db_connection
  end

  def connection
    self.class.connection
  end
end
