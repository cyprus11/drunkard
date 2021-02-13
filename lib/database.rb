require 'sqlite3'
require_relative 'player'

class Database
  def initialize
    if File.exist?("#{__dir__}/../db/drunkyard.db")
      @db = SQLite3::Database.new("#{__dir__}/../db/drunkyard.db")
    else
      @db = SQLite3::Database.new("#{__dir__}/../db/drunkyard.db")
      create_table
    end
  end

  def find_or_create_player(user_id, name)
    player_db = @db.execute('select * from players where user_id is (?)', [user_id])
    player_db.flatten!
    if player_db.empty?
      @db.execute('insert into players (user_id, user_name, user_score, bot_score) values(?, ?, ?, ?)',
                  [user_id, name, 0, 0])
      return Player.new(user_id, name, 0, 0)
    else
      return Player.new(player_db[0], player_db[1], player_db[2], player_db[3])
    end
  end

  def update_info(player)
    @db.execute('update players set user_score = (?), bot_score = (?) where user_id is (?)',
                [player.score, player.bot_score, player.user_id])
  end

  def score(id)
    @db.execute('select bot_score, user_score from players where user_id is (?)', id).flatten
  end

  private

  def create_table
    @db.execute <<~SQL
      create table players (
        user_id int,
        user_name varchar(50),
        user_score int,
        bot_score int
      );
    SQL
  end
end
