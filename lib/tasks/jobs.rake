namespace :jobs do
  desc 'Gets Series Info'
  task blah: :environment do
    1000.times do |i|
      TwitterInterface.new.run
      sleep TwitterInterface::INTERVAL
      puts "Run: #{i} -------- "
    end
  end
end
