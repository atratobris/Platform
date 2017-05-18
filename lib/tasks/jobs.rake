namespace :jobs do
  desc 'Gets Series Info'
  task work: :environment do
    iterations = (10.minutes - TwitterInterface::INTERVAL).to_i
    # iterations.times do |i|
    #   TwitterInterface.new.run
    #   sleep TwitterInterface::INTERVAL
    #   puts "Run: #{i} out of #{iterations} -------- "
    # end
  end
end
