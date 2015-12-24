namespace :data_download do
  task :initial_download => :environment do
    DataSyncService.new.initial_data_download
  end
end
