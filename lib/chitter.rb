require 'pg'
require_relative 'peep'

class Chitter

  def self.print_peeps
    if ENV['ENVIRONMENT'] == 'test'
      connection = PG.connect(dbname: 'chitter_test')
    else
      connection = PG.connect(dbname: 'chitter')
    end

    result = connection.exec("SELECT * FROM peeps;")
    result.map do |peep|
      Peep.new(id: peep['id'], peep: peep['peep'], post_time: peep['post_time'], post_date: peep['post_date'])
    end
  end

  def self.post_peep(peep:, post_time:, post_date:)
    if ENV['ENVIRONMENT'] == 'test'
      connection = PG.connect(dbname: 'chitter_test')
    else
      connection = PG.connect(dbname: 'chitter')
    end

    result = connection.exec("INSERT INTO peeps (peep, post_time, post_date) VALUES('#{peep}', '#{post_time}', '#{post_date}') RETURNING id, peep, post_time, post_date;")
    Peep.new(id: result[0]['id'], peep: result[0]['peep'], post_time: result[0]['post_time'], post_date: result[0]['post_date'])
  end
end
