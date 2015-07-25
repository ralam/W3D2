#crashes

require "active_record"
require "byebug"

module Save
  def save
    instance_vars = self.instance_variables
    vars_hash = Hash.new{ |h, k| h[k] }
    instance_vars.each do |var|
      vars_hash[var] = self.instance_variable_get(var)
    end

    vars_keys_to_string = ""

    vars_hash.each do |k, v|
      next if k == 'id'
      vars_keys_to_string += k.to_s + ", "
    end

    vars_keys_to_string = vars_keys_to_string[0..-3]
    vars_values = ""

    vars_hash.each do |k, v|
      unless k == 'id'
        vars_values += v.to_s + ", "
      end
    end

    vars_values = vars_values[0..-3]

    vars_set = ""

    vars_hash.each do |k, v|
      next if k == 'id'
      vars_set += k.to_s + " = " + v.to_s + ", "
    end

    vars_set = vars_set[0..-3]

    if vars_hash[:id].nil?
      QuestionsDatabase.instance.execute(<<-SQL)
      INSERT INTO
        #{table_name}(#{vars_keys_to_string})
      VALUES
        (#{vars_values})
      SQL

      @id = QuestionsDatabase.instance.last_insert_row_id
    else
      QuestionsDatabase.instance.execute(<<-SQL, id: @id)
      UPDATE
        users
      SET
        #{vars_set}
      WHERE id = :id
      SQL
    end
  end
end
