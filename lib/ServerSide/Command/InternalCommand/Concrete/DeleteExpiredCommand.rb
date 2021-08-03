require_relative '../Abstract/InternalCommand'

class DeleteExpiredCommand < InternalCommand
  def initialize(target_hash)
    @target_hash = target_hash
  end

  def execute
    delete_expired_command
  end

  def delete_expired_command
    data = @target_hash.data_hash 

    if !data.empty?
      data.each do |key, entry|
        entry.update_ttl
        if entry.ttl <= 0
          data.delete(key)
        end
      end
      @target_hash.data_hash = data
    end
  end
end